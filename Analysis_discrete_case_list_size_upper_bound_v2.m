% 
%   This script computes an array of proposed upper bounds in a single
%   plot. This script requires simulation data from the following files had
%   it not been generated earlier.
%       1) "Compute_brute_force_bound.m"
%       2) "Analysis_conditional_expected_list_sizes.m"
%       3) "Simulation_expected_list_size_hard_SLVD.m"
%
%   The proposed upper bounds so far:
%       1) Brute-force upper bound, see 11-13-20 slides, Page 9, Eq. (8)
%       2) Randomized brute-force upper bound: similar to bound (1) except
%       that the \# codewords at smallest undetected distance is only taken
%       half assuming they are all randomized.
%       3) Vanila covering-sphere upper bound: see 11-20-20, Page, 8, Eq. (6).
%       3) Covering-sphere upper bound: see 11-13-20 slides, Page 9, Eq. (10).
%       4) Improved covering-sphere upper bound: see 11-20-20 slides, Page 19, Eq. (21).
%       5) Hybrid upper bound: minimum between bound (3) and (4).
%
%   v2 version: exactly the same as v1 except the example is changed:
%       k = 4, m = 3, v = 3, ZTCC(13, 17), CRC(11).
%
%   Written by Hengjie Yang (hengjie.yang@ucla.edu) 11/05/20.
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% Input parameters
k = 4; % the information length
m = 3; % the CRC degree
v = 3; % the # memory elements
omega = 2;
n = omega*(k + m + v); % the blocklength
weights = 0:n;
Max_list_size = 2^(k+m) - 2^k + 1;
rho = 9; % the true covering radius
d_crc = 10; % the minimum distance of the low-rate code.


crc_gen_poly = '11';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high
crc_coded_sequence = zeros(1, k+m+v);


constraint_len = v+1;
code_generator = [13, 17];
trellis = poly2trellis(constraint_len, code_generator);

% constraint_len_overall = constraint_len + m;
% code_generator_overall = [151, 125];


%% Compute the brute-force and randomization-based brute-force bound

% This bound assumes that the codewords at undetected distance are all
% equally likely to be drawn.



path = './Simulation_results/';
load([path, '111320_201103_brute_force_bound_ZTCC_13_17_CRC_11_k_4.mat'],...
    'Upper_bound_instances', 'Relative_distance_spectra');


brute_force_bound_cond_exp_list_size = zeros(n+1, 1);
rand_brute_force_bound_cond_exp_list_size = zeros(n+1, 1);

num_noise = 2^n;
for ii = 0:num_noise - 1
    noise_vec = dec2bin(ii, k) - '0';
    w = sum(noise_vec);
    udist = size(Relative_distance_spectra{ii+1}, 1) - 1;
    rand_brute_force_bound_cond_exp_list_size(w+1) = ...
        rand_brute_force_bound_cond_exp_list_size(w+1) + sum(Relative_distance_spectra{ii+1}(1:udist));
    if Relative_distance_spectra{ii+1}(udist+1) > 1 % randomization only works for more than 1 codeword
        rand_brute_force_bound_cond_exp_list_size(w+1) = ...
            rand_brute_force_bound_cond_exp_list_size(w+1) + floor((1/2)*Relative_distance_spectra{ii+1}(udist+1)); % randomization assumption
    else
        rand_brute_force_bound_cond_exp_list_size(w+1) = ...
            rand_brute_force_bound_cond_exp_list_size(w+1) + 1;
    end
%     rand_brute_force_bound_cond_exp_list_size(w+1) = ...
%         rand_brute_force_bound_cond_exp_list_size(w+1) + 1; % smallest weight assumption
end


for w = 0:n
    N = nchoosek(n, w);
    rand_brute_force_bound_cond_exp_list_size(w+1) = ...
        rand_brute_force_bound_cond_exp_list_size(w+1) / N;
    brute_force_bound_cond_exp_list_size(w+1) = ...
        mean(Upper_bound_instances{w+1});
end






%% Compute the covering-sphere upper bound on E[L|W = w]

weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
weight_spectrum_low_rate = weight_node.distance_spectrum_low_rate;
covering_sphere_bound_cond_exp_list_size = zeros(n+1, 1);
% half_dist = floor((d_crc - 1)/2);


for w = 0:n
    threshold = min([w, rho]);
%     threshold = w;
    for d = 0:threshold
        for t = w-d: min(w+d, 2*n-(w+d))
            if (mod(d+t-w, 2) == 0)
                a = floor((d+t-w)/2);
%               disp(['a: ',num2str(a),' t: ', num2str(t), ' d: ',num2str(d)]);
                temp = weight_spectrum_high_rate(t+1)*nchoosek(t, a)*nchoosek(n-t, d-a);
%                 temp = weight_spectrum_high_rate(t+1);
                covering_sphere_bound_cond_exp_list_size(w+1) =...
                    covering_sphere_bound_cond_exp_list_size(w+1)+temp;
            end
        end
    end  
    N = nchoosek(n, w);
    covering_sphere_bound_cond_exp_list_size(w+1) = covering_sphere_bound_cond_exp_list_size(w+1)/N;
end


%% Vanila covering-sphere upper bound on E[L| W =w]

vanila_covering_sphere_bound_cond_exp_list_size = zeros(n+1, 1);

for w = 0:n
    threshold = min(w, rho);
    vanila_covering_sphere_bound_cond_exp_list_size(w+1) = ...
        1+sum(weight_spectrum_high_rate(max(0,w-rho)+1:min(w+threshold, n)+1)) - sum(weight_spectrum_low_rate(max(0,w-rho)+1:min(w+threshold, n)+1));
end


%% Compute the improved covering-sphere upper bound on E[L|W = w]

weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
weight_spectrum_low_rate = weight_node.distance_spectrum_low_rate;

improved_covering_sphere_bound_cond_exp_list_size = zeros(n+1, 1);
% hybrid_bound_cond_exp_list_size = zeros(n+1, 1);

for w = 0:n
    threshold = min([w, rho]);
    for d = 0:threshold
        for t = w-d: min(w+d, 2*n-(w+d))
            if (mod(d+t-w, 2) == 0)
                a = floor((d+t-w)/2);
                temp = (weight_spectrum_high_rate(t+1) - weight_spectrum_low_rate(t+1))...
                    *nchoosek(t, a)*nchoosek(n-t, d-a);
                improved_covering_sphere_bound_cond_exp_list_size(w+1) =...
                    improved_covering_sphere_bound_cond_exp_list_size(w+1)+temp;
            end
        end
    end
    improved_covering_sphere_bound_cond_exp_list_size(w+1) =...
                    improved_covering_sphere_bound_cond_exp_list_size(w+1)+nchoosek(n, w);
    N = nchoosek(n, w);
    improved_covering_sphere_bound_cond_exp_list_size(w+1) =...
        improved_covering_sphere_bound_cond_exp_list_size(w+1) / N;
    
%     hybrid_bound_cond_exp_list_size(w+1) = ...
%         min(improved_covering_sphere_bound_cond_exp_list_size(w+1), covering_sphere_bound_cond_exp_list_size(w+1));
end


%% Compute the sphere-packing upper bound

% weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
% weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
% weight_spectrum_low_rate = weight_node.distance_spectrum_low_rate;
% 
% improved_covering_sphere_bound_cond_exp_list_size = zeros(n+1, 1);
% hybrid_bound_cond_exp_list_size = zeros(n+1, 1);
% 
% for w = 0:n
%     threshold = min(w, rho);
%     for t = 0:min(w+threshold, n)
% %         temp = weight_spectrum_low_rate(t+1) +...
% %             (weight_spectrum_high_rate(t+1) - weight_spectrum_low_rate(t+1))*...
% %             (sum(weight_spectrum_high_rate(1:min(2*threshold, n)+1))-sum(weight_spectrum_low_rate(1:min(2*threshold, n)+1)));
%         temp = 1 + ...
%             (weight_spectrum_high_rate(t+1) - weight_spectrum_low_rate(t+1))*...
%             (sum(weight_spectrum_high_rate(1:min(2*threshold, n)+1))-sum(weight_spectrum_low_rate(1:min(2*threshold, n)+1)));
%         if t < w
%             temp = temp*nchoosek(n-t, w-t);
%         else
%             temp = temp*nchoosek(t, t-w);
%         end
%         improved_covering_sphere_bound_cond_exp_list_size(w+1) = ...
%             improved_covering_sphere_bound_cond_exp_list_size(w+1) + temp;
%     end
%     N = nchoosek(n, w);
%     improved_covering_sphere_bound_cond_exp_list_size(w+1) = ...
%         improved_covering_sphere_bound_cond_exp_list_size(w+1)  / N;
%     
%     hybrid_bound_cond_exp_list_size(w+1) = ...
%         min(improved_covering_sphere_bound_cond_exp_list_size(w+1), covering_sphere_bound_cond_exp_list_size(w+1));
%     
%     sphere_packing_bound_cond_exp_list_size(w+1) = ...
%         min(sphere_packing_bound_cond_exp_list_size(w+1), covering_sphere_bound_cond_exp_list_size(w+1)); % take the min between both
% end





%% Compute the actual maximum undetected distance at each noise weight W = w

path = './Simulation_results/';
file_name = '111320_201103_brute_force_bound_ZTCC_13_17_CRC_11_k_4.mat';
[hist_udists, nontrivial_udist_instances] = Compute_hist_cond_undetected_dist(path, file_name, n);

figure;
plot(weights, sum(hist_udists, 2)','+-');
grid on;
xlabel('Noise weight $w$','interpreter', 'latex');
ylabel('Max. undetected distance', 'interpreter', 'latex');
title('k = 4, m = 3, CRC:(11), ZTCC (13, 17)');


%% Compute the upper bound on # noise vectors with u(z) = w.

% upper_bound_nontrivial_noise_vecs = zeros(n+1, 1);
% threshold = floor((d_crc-1)/2);
% for w = floor((d_crc+1)/2):rho
%     temp = 0;
%     for r = 0:threshold
%         for t = (w-r):min(w+r, 2*n-w-r)
%             if mod(t+r-w, 2) == 0
%                 a = (t+r-w)/2;
%                 temp = temp + weight_spectrum_low_rate(t+1)*nchoosek(t,a)*nchoosek(n-t, r-a);
%             end
%         end
%     end
%     upper_bound_nontrivial_noise_vecs(w+1) = nchoosek(n, w) - temp;
% end

% Remark (11/16/20): turns out this is much loose than only taking one ball


%% Compute the optimal theoretical upper bound on E[L|W = w] using optimal \rho


% optimal_bound_cond_exp_list_size = zeros(n+1, 1);
% 
% for w = 0:n
%     threshold = min(w, rho_opt);
% %     threshold = w;
%     for d = 0:threshold
%         for t = w-d: min(w+d, 2*n-(w+d))
%             if mod(d + t - w, 2) == 0
%                 a = floor((d+t-w)/2);
% %               disp(['a: ',num2str(a),' t: ', num2str(t), ' d: ',num2str(d)]);
%                 temp = weight_spectrum_high_rate(t+1)*nchoosek(t, a)*nchoosek(n-t, d-a);
%                 optimal_bound_cond_exp_list_size(w+1) =...
%                     optimal_bound_cond_exp_list_size(w+1)+temp;
%             end
%         end
%         if w > 0
%         optimal_bound_cond_exp_list_size(w+1) =...
%             optimal_bound_cond_exp_list_size(w+1) - weight_spectrum_high_rate(d+1)*weight_spectrum_low_rate(w+1);
%         end
%     end
%     N = nchoosek(n, w);
%     optimal_bound_cond_exp_list_size(w+1) = optimal_bound_cond_exp_list_size(w+1)/N;
% end


%% plot curves on conditional expected list sizes

path = './Simulation_results/';
load([path, '110520_155445_cond_exp_list_sizes_ZTCC_13_17_CRC_11_k_4.mat'],...
    'Conditional_expected_list_sizes', 'Error_instances');

% Compute the maximum of list size given a particular noise weight
Max_list_sizes = zeros(1, n+1);
Min_list_sizes = zeros(1, n+1);
for w = 0:n
    Max_list_sizes(w+1) = max(Error_instances{w+1});
    Min_list_sizes(w+1) = min(Error_instances{w+1});
end

% plot comparison curves
figure;
plot(weights, vanila_covering_sphere_bound_cond_exp_list_size, '+-'); hold on
plot(weights, covering_sphere_bound_cond_exp_list_size, '+-'); hold on
plot(weights, improved_covering_sphere_bound_cond_exp_list_size, '+-'); hold on
plot(weights, Max_list_sizes, '^-'); hold on
% plot(weights, hybrid_bound_cond_exp_list_size, '+-'); hold on
plot(weights, brute_force_bound_cond_exp_list_size, '+-'); hold on
plot(weights, rand_brute_force_bound_cond_exp_list_size, '+-'); hold on
plot(weights, Conditional_expected_list_sizes, 'o-');hold on
plot(weights, Min_list_sizes, 'v-'); hold on
grid on
legend('Vanila covering-sphere upper bound',...
    'Covering-sphere upper bound',...
    'Improved covering-sphere upper bound',...
    'Max list size',...
    'Brute-force upper bound',...
    'Randomized brute-force upper bound',...
    'Expected list size',...
    'Min list size');
xlabel('Noise weight $w$','interpreter', 'latex');
ylabel('List size', 'interpreter', 'latex');
title('k = 4, m = 3, \rho = 9, CRC:(11), ZTCC (13, 17)');


%% Plot the final upper bound

path = './Simulation_results/';
load([path, '110620_123541_sim_list_sizes_hard_ZTCC_13_17_CRC_11_k_4.mat'], 'Ave_list_sizes', 'snr_dBs');



snrs = 10.^(snr_dBs./10);
alphas = qfunc(sqrt(snrs));

Vanila_covering_sphere_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % the vanila covering-sphere upper bound on E[L]
Covering_sphere_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % covering-sphere upper bound on E[L]
Improved_covering_sphere_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % sphere-packing upper bound on E[L]
% Hybrid_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % sphere-packing upper bound on E[L]
% Optimal_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % optimal possible bound, not a bound on E[L]
Brute_force_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % brute-force bound
Rand_brute_force_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % randomization-based brute-force bound
Theoretical_exp_list_sizes = zeros(1, size(snrs, 2)); % true E[L]

% pre-compute each type
P = zeros(n+1, 2); % P(kk+1,:) = [1-kk/n, kk/n];
for kk = 0:n
    P(kk+1,1) = 1 - kk/n;
    P(kk+1,2) = kk/n;
end


% compute the theoretical expected list size
for iter = 1:size(snrs, 2)
    alpha = alphas(iter);
    Q = [1-alpha, alpha];
    for w = 0:n
        D = Relative_Entropy(P(w+1, :), Q);
        H = Entropy(P(w+1, :));
        Theoretical_exp_list_sizes(iter) = Theoretical_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*Conditional_expected_list_sizes(w+1);
        Rand_brute_force_bound_exp_list_sizes(iter) = Rand_brute_force_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*rand_brute_force_bound_cond_exp_list_size(w+1);
        Brute_force_bound_exp_list_sizes(iter) = Brute_force_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*brute_force_bound_cond_exp_list_size(w+1);
%         Hybrid_bound_exp_list_sizes(iter) = Hybrid_bound_exp_list_sizes(iter)+...
%             nchoosek(n, w)*2^(-n*(D+H))*hybrid_bound_cond_exp_list_size(w+1);
        Covering_sphere_bound_exp_list_sizes(iter) = Covering_sphere_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*covering_sphere_bound_cond_exp_list_size(w+1);
        Improved_covering_sphere_bound_exp_list_sizes(iter) = Improved_covering_sphere_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*improved_covering_sphere_bound_cond_exp_list_size(w+1);  
        Vanila_covering_sphere_bound_exp_list_sizes(iter) = Vanila_covering_sphere_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*vanila_covering_sphere_bound_cond_exp_list_size(w+1);
%         Optimal_bound_exp_list_sizes(iter) = Optimal_bound_exp_list_sizes(iter)+...
%             nchoosek(n, w)*2^(-n*(D+H))*optimal_bound_cond_exp_list_size(w+1);
    end
end


%% Plot both curves
figure;
% plot(snr_dBs, Vanila_covering_sphere_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Covering_sphere_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Improved_covering_sphere_bound_exp_list_sizes, '--'); hold on
% plot(snr_dBs, Hybrid_bound_exp_list_sizes, '--'); hold on
% plot(snr_dBs, Optimal_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Brute_force_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Rand_brute_force_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Theoretical_exp_list_sizes, '--'); hold on
plot(snr_dBs, Ave_list_sizes, '+-'); hold on
legend('Covering-sphere upper bound',...
    'Improved covering-sphere upper bound',...
    'Brute-force upper bound',...
    'Randomized brute-force upper bound',...
    'Theoretical $\mathrm{E}[L]$',...
    'Simulation');
grid on
xlabel('$E_s/N_0$ (dB)', 'interpreter', 'latex');
ylabel('Expected list size', 'interpreter', 'latex');

title('k = 4, m = 3, \rho = 9, CRC: (11), ZTCC: (13, 17)');





function D = Relative_Entropy(P, Q)

% make sure P, Q are of the same dimension
if P(1)<1 && P(1)>0
    D = sum(P.*log2(P./Q));
elseif P(1) == 1
    D = P(1)*log2(P(1)/Q(1));
else
    D = P(2)*log2(P(2)/Q(2));
end   

end


function H = Entropy(P)

if P(1) == 1 || P(2) == 1
    H = 0;
else
    H = -sum(P.*log2(P));
end

end





