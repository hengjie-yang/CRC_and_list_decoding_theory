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

crc_gen_poly = '17';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly);


constraint_len = 4;
code_generator = [13, 17];

constraint_len_overall = constraint_len + m;
code_generator_overall = [151, 125];


num_noise = 2^n;

Upper_bound_instances = cell(n+1, 1);
Conditional_upper_bounds = zeros(n+1, 1); % the upper bound on E[L|W=w]


tic
disp('Step 1: Compute relative distance spectra for all noise vectors.');
for ii = 0:num_noise - 1
    
    % generate the noise vector
    rxSig = dec2bin(ii, n) - '0';
    w = sum(rxSig);
    
    % compute the relative distance spectrum of ZTCC and CRC-ZTCC
    weight_node_high_rate = Compute_relative_distance_spectrum(constraint_len, code_generator, k+m+(constraint_len-1), rxSig);
    weight_spectrum_high_rate = weight_node_high_rate.weight_spectrum;
    
    weight_node_low_rate = Compute_relative_distance_spectrum(constraint_len_overall, code_generator_overall, k+(constraint_len_overall-1), rxSig);
    weight_spectrum_low_rate = weight_node_low_rate.weight_spectrum;
    
    % Find the partial sum of ZTCCs up to undetected distance
    undetected_dist = find(weight_spectrum_low_rate > 0);
    undetected_dist = undetected_dist(1); % take the smallest value
    
    % Compute the upper bound on s^*(z)
    val = sum(weight_spectrum_high_rate(1:undetected_dist));
    Upper_bound_instances{w+1} = [Upper_bound_instances{w+1}, val];
    
    if mod(ii, 10000) == 0
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
plot(weights, Conditional_upper_bounds, '+-'); hold on
plot(weights, Conditional_expected_list_sizes, 'o-');hold on
plot(weights, Min_list_sizes, 'v-'); hold on
grid on
legend('Max list size','Upper bound', 'Expected list size','Min list size');
xlabel('Noise weight $w$','interpreter', 'latex');
ylabel('List size', 'interpreter', 'latex');
title('k = 4, m = 3, CRC:(17), ZTCC (13, 17)');





