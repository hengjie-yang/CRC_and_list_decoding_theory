% 
%   This script is to find upper bound on s^*(z) using relative distance
%   spectrums.
%
%   v2 version: the same as original except the example is changed to k =
%   4, m = 3, v = 3, CRC: '11', ZTCC: (13, 17);
%
%   Algorithm: the upper bound on s^*(z) 
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
rho_opt = 6; % the optimal covering radius
d_crc = 10; % the minimum distance of the low-rate code.


crc_gen_poly = '11';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high
crc_coded_sequence = zeros(1, k+m+v);


constraint_len = v+1;
code_generator = [13, 17];
trellis = poly2trellis(constraint_len, code_generator);

constraint_len_overall = constraint_len + m;
code_generator_overall = [151, 125];


path = './Simulation_results/';
load([path, '111320_201103_brute_force_bound_ZTCC_13_17_CRC_11_k_4.mat'],...
    'Upper_bound_instances');


% Compute the brute-force upper bound on E[L|W=w]

Brute_force_bound_cond_exp_list_size = zeros(n+1, 1);


for w = 0:n
    Brute_force_bound_cond_exp_list_size(w+1) = mean(Upper_bound_instances{w+1});
end




%% Compute the covering-sphere upper bound on E[L|W = w]

weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
weight_spectrum_low_rate = weight_node.distance_spectrum_low_rate;
covering_sphere_bound_cond_exp_list_size = zeros(n+1, 1);
half_dist = floor((d_crc - 1)/2);


for w = 0:n
    threshold = min(w, rho);
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
    
%     if w > half_dist
%         temp = 0;
%         for r = 1:half_dist
%             for t = (w-r):min([w+r, 2*n-(w+r)])
%                 if (mod(t+r-w, 2) == 0)
%                     a = floor((t+r-w)/2);
%                     temp = temp + weight_spectrum_low_rate(t+1)*nchoosek(t, a)*nchoosek(n-t, r-a)*(sum(weight_spectrum_high_rate(1:w+1)));
%                 end
%             end
%         end
%         covering_sphere_bound_cond_exp_list_size(w+1) = ...
%         covering_sphere_bound_cond_exp_list_size(w+1) - temp;
%     end
    
    
    N = nchoosek(n, w);
    covering_sphere_bound_cond_exp_list_size(w+1) = covering_sphere_bound_cond_exp_list_size(w+1)/N;
end

%% Compute the sphere-packing upper bound on E[L|W = w]

weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
weight_spectrum_low_rate = weight_node.distance_spectrum_low_rate;

sphere_packing_bound_cond_exp_list_size = zeros(n+1, 1);
half_dist = floor((d_crc - 1)/2);

for w = 0:n
    threshold = min([w, rho]);
    for d = 0:threshold
        for t = w-d: min(w+d, 2*n-(w+d))
            if (mod(d+t-w, 2) == 0)
                a = floor((d+t-w)/2);
                temp = (weight_spectrum_high_rate(t+1)-weight_spectrum_low_rate(t+1))*nchoosek(t, a)*nchoosek(n-t, d-a);
                sphere_packing_bound_cond_exp_list_size(w+1) =...
                    sphere_packing_bound_cond_exp_list_size(w+1)+temp;
            end
        end
    end

%     for t = 0:2*threshold
%         for a = max(0, t-w): min(ceil((threshold-t+w)/2), n-w)
%             temp = (weight_spectrum_high_rate(t+1) - weight_spectrum_low_rate(t+1))*nchoosek(t, a)*nchoosek(n-t, w-t+a);
%             sphere_packing_bound_cond_exp_list_size(w+1) = ...
%                 sphere_packing_bound_cond_exp_list_size(w+1) + temp;
%         end
%     end
    
    for t = 0:min(2*threshold, n)
        if t < w
            temp = weight_spectrum_low_rate(t+1)*nchoosek(n-t, w-t);
        else
            temp = weight_spectrum_low_rate(t+1)*nchoosek(t, t-w);
        end
        sphere_packing_bound_cond_exp_list_size(w+1) =...
                    sphere_packing_bound_cond_exp_list_size(w+1)+temp;
    end
    N = nchoosek(n, w);
    sphere_packing_bound_cond_exp_list_size(w+1) =...
        sphere_packing_bound_cond_exp_list_size(w+1) / N;
end


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


%% plot curves

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
plot(weights, Max_list_sizes, '^-'); hold on
plot(weights, covering_sphere_bound_cond_exp_list_size, '+-'); hold on
plot(weights, sphere_packing_bound_cond_exp_list_size, '+-'); hold on
% plot(weights, optimal_bound_cond_exp_list_size, '+-'); hold on
plot(weights, Brute_force_bound_cond_exp_list_size, '+-'); hold on
plot(weights, Conditional_expected_list_sizes, 'o-');hold on
plot(weights, Min_list_sizes, 'v-'); hold on
grid on
legend('Max list size','Covering-sphere upper bound, $\rho = 9$',...
    'Sphere-packing upper bound','Brute-force upper bound',...
    'Expected list size','Min list size');
xlabel('Noise weight $w$','interpreter', 'latex');
ylabel('List size', 'interpreter', 'latex');
title('k = 4, m = 3, CRC:(11), ZTCC (13, 17)');


%% Plot the final upper bound

path = './Simulation_results/';
load([path, '110620_123541_sim_list_sizes_ZTCC_13_17_CRC_11_k_4.mat'], 'Ave_list_sizes', 'snr_dBs');



snrs = 10.^(snr_dBs./10);
alphas = qfunc(sqrt(snrs));

Covering_sphere_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % covering-sphere upper bound on E[L]
Sphere_packing_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % sphere-packing upper bound on E[L]
% Optimal_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % optimal possible bound, not a bound on E[L]
Upper_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % brute-force bound
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
        Upper_bound_exp_list_sizes(iter) = Upper_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*Brute_force_bound_cond_exp_list_size(w+1);
        Covering_sphere_bound_exp_list_sizes(iter) = Covering_sphere_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*covering_sphere_bound_cond_exp_list_size(w+1);
        Sphere_packing_bound_exp_list_sizes(iter) = Sphere_packing_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*sphere_packing_bound_cond_exp_list_size(w+1);
        
%         Optimal_bound_exp_list_sizes(iter) = Optimal_bound_exp_list_sizes(iter)+...
%             nchoosek(n, w)*2^(-n*(D+H))*optimal_bound_cond_exp_list_size(w+1);
    end
end


% Plot both curves
figure;
plot(snr_dBs, Covering_sphere_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Sphere_packing_bound_exp_list_sizes, '--'); hold on
% plot(snr_dBs, Optimal_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Upper_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Theoretical_exp_list_sizes, '--'); hold on
plot(snr_dBs, Ave_list_sizes, '+-'); hold on
legend('Covering-sphere upper bound, $\rho = 9$','Sphere-packing upper bound',...
    'Brute-force upper bound','Theoretical $\mathrm{E}[L]$', 'Simulation');
grid on
xlabel('$E_s/N_0$ (dB)', 'interpreter', 'latex');
ylabel('Expected list size', 'interpreter', 'latex');

title('k = 4, m = 3, CRC: (11), ZTCC: (13, 17)');





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





