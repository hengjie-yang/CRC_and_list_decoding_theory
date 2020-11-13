% 
%   This script is to find upper bound on s^*(z) using relative distance
%   spectrums.
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


crc_gen_poly = '17';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high
crc_coded_sequence = zeros(1, k+m+v);


constraint_len = v+1;
code_generator = [13, 17];
trellis = poly2trellis(constraint_len, code_generator);

constraint_len_overall = constraint_len + m;
code_generator_overall = [151, 125];


num_noise = 2^n;

Upper_bound_instances = cell(n+1, 1);
Conditional_upper_bounds = zeros(n+1, 1); % the upper bound on E[L|W=w]


%%
tic
disp('Step 1: Compute relative distance spectra for all noise vectors.');
for ii = 0:num_noise-1
    
    % generate the noise vector
    rxSig = dec2bin(ii, n) - '0';
    w = sum(rxSig);
    
    % compute the relative distance spectrum of ZTCC and CRC-ZTCC
%     weight_node_high_rate = Compute_relative_distance_spectrum(constraint_len, code_generator, k+m+(constraint_len-1), rxSig);
%     distance_spectrum_high_rate = weight_node_high_rate.weight_spectrum;
%     
%     weight_node_low_rate = Compute_relative_distance_spectrum(constraint_len_overall, code_generator_overall, k+(constraint_len_overall-1), rxSig);
%     distance_spectrum_low_rate = weight_node_low_rate.weight_spectrum;

    % use brute-force version to compute distance spectra
    weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, rxSig);
    distance_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
    distance_spectrum_low_rate = weight_node.distance_spectrum_low_rate;
    
    % Find the partial sum of ZTCCs up to undetected distance
    undetected_dist = find(distance_spectrum_low_rate > 0);
    undetected_dist = undetected_dist(1); % take the smallest value
    
    
    % decode based on the noise vector
    [check_flag, correct_flag, path_rank, dec] = ...
            DBS_LVA_Hamming(trellis, rxSig, poly, crc_coded_sequence, Max_list_size);
    
    % Compute the upper bound on s^*(z)
    val = sum(distance_spectrum_high_rate(1:undetected_dist));
    if val >= path_rank % check if val is indeed an upper bound
        Upper_bound_instances{w+1} = [Upper_bound_instances{w+1}; val];
    else
        Upper_bound_instances{w+1} = [Upper_bound_instances{w+1}; -1];
    end
    
    if mod(ii, 1000) == 0
        timeVal = tic;
        disp(['Current instance: ',num2str(ii),'/ ',num2str(num_noise),...
            ' upper bound: ',num2str(val), ' Time spent: ', num2str(toc)]);
    end 
end
toc
    

% Compute the upper bound on conditional list sizes
disp('Step 2: Compute the upper bound for E[L|W=w]');
for w = 0:n
    correct_num = nchoosek(n, w);
    if correct_num == size(Upper_bound_instances{w+1}, 1) 
        Conditional_upper_bounds(w+1) = mean(Upper_bound_instances{w+1});
    end
end


% save the results
timestamp = datestr(now, 'mmddyy_HHMMSS');
path = './Simulation_results/';
save([path, timestamp, '_cond_upper_bound_ZTCC_13_17_CRC_11_k_4.mat'],...
    'Upper_bound_instances','Conditional_upper_bounds');



%% Compute the new theoretical upper bound on E[L|W = w]

weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;

theoretical_bound_cond_exp_list_size = zeros(n+1, 1);

for w = 0:n
    threshold = min(w, rho);
%     threshold = w;
    for d = 0:threshold
        for t = w-d: min(w+d, 2*n-(w+d))
            if (mod(d+t-w, 2) == 0)
                a = floor((d+t-w)/2);
%               disp(['a: ',num2str(a),' t: ', num2str(t), ' d: ',num2str(d)]);
                temp = weight_spectrum_high_rate(t+1)*nchoosek(t, a)*nchoosek(n-t, d-a);
                theoretical_bound_cond_exp_list_size(w+1) =...
                    theoretical_bound_cond_exp_list_size(w+1)+temp;
            end
        end
    end
    N = nchoosek(n, w);
    theoretical_bound_cond_exp_list_size(w+1) = theoretical_bound_cond_exp_list_size(w+1)/N;
end



%% Compute the optimal theoretical upper bound on E[L|W = w] using optimal \rho


optimal_bound_cond_exp_list_size = zeros(n+1, 1);

for w = 0:n
    threshold = min(w, rho_opt);
%     threshold = w;
    for d = 0:threshold
        for t = w-d: min(w+d, 2*n-(w+d))
            if mod(d + t - w, 2) == 0
                a = floor((d+t-w)/2);
%               disp(['a: ',num2str(a),' t: ', num2str(t), ' d: ',num2str(d)]);
                temp = weight_spectrum_high_rate(t+1)*nchoosek(t, a)*nchoosek(n-t, d-a);
                optimal_bound_cond_exp_list_size(w+1) =...
                    optimal_bound_cond_exp_list_size(w+1)+temp;
            end
        end
    end
    N = nchoosek(n, w);
    optimal_bound_cond_exp_list_size(w+1) = optimal_bound_cond_exp_list_size(w+1)/N;
end


%% plot curves

path = './Simulation_results/';
load([path, '110420_220611_cond_exp_list_sizes_ZTCC_13_17_CRC_17_k_4.mat'],...
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
plot(weights, theoretical_bound_cond_exp_list_size, '+-'); hold on
plot(weights, optimal_bound_cond_exp_list_size, '+-'); hold on
plot(weights, Conditional_upper_bounds, '+-'); hold on
plot(weights, Conditional_expected_list_sizes, 'o-');hold on
plot(weights, Min_list_sizes, 'v-'); hold on
grid on
legend('Max list size','True upper bound, $\rho = 9$','Optimal curve, $\rho^* = 6$','Brute-force upper bound', 'Expected list size','Min list size');
xlabel('Noise weight $w$','interpreter', 'latex');
ylabel('List size', 'interpreter', 'latex');
title('k = 4, m = 3, CRC:(17), ZTCC (13, 17)');


%% Plot the final upper bound

path = './Simulation_results/';
load([path, '110420_180539_sim_list_sizes_ZTCC_13_17_CRC_17_k_4.mat'], 'Ave_list_sizes', 'snr_dBs');



snrs = 10.^(snr_dBs./10);
alphas = qfunc(sqrt(snrs));

Theoretical_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % true upper bound on E[L]
Optimal_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % optimal possible bound, not a bound on E[L]
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
            nchoosek(n, w)*2^(-n*(D+H))*Conditional_upper_bounds(w+1);
        Theoretical_bound_exp_list_sizes(iter) = Theoretical_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*theoretical_bound_cond_exp_list_size(w+1);
        Optimal_bound_exp_list_sizes(iter) = Optimal_bound_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*optimal_bound_cond_exp_list_size(w+1);
    end
end


% Plot both curves
figure;
plot(snr_dBs, Theoretical_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Optimal_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Upper_bound_exp_list_sizes, '--'); hold on
plot(snr_dBs, Theoretical_exp_list_sizes, '--'); hold on
plot(snr_dBs, Ave_list_sizes, '+-'); hold on
legend('True upper bound, $\rho = 9$','Optimal curve, $\rho^* = 6$','Brute-force upper bound','Theoretical $\mathrm{E}[L]$', 'Simulation');
grid on
xlabel('$E_s/N_0$ (dB)', 'interpreter', 'latex');
ylabel('Expected list size', 'interpreter', 'latex');

title('k = 4, m = 3, CRC: (17), ZTCC: (13, 17)');





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





