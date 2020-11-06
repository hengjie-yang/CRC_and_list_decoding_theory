% This script is to compare the upper bound and actual conditional expected
% list sizes.
% 
% Remarks
%   1) Only execute this script AFTER running
%   "Analysis_conditional_expected_list_sizes.m". This will compute each
%   conditionoal expected list sizes using brute-force method.
%   2) Only execute this script AFTER running
%   "Compute_ZTCC_weight_spectrum.m" to obtain the full weight spectrum of
%   the ZTCC.
%   3) The default example: k = 4, m = 3, v = 3, CRC: (17), ZTCC: (13,17).
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/05/20.
%

clear;
clc;

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');



% Load files
load('weight_node_ZTCC_13_17_N_10.mat', 'weight_node');
weight_spectrum = weight_node.weight_spectrum;

path = './Simulation_results/';
load([path, '110420_220611_cond_exp_list_sizes_ZTCC_13_17_CRC_17_k_4.mat'],...
    'Conditional_expected_list_sizes', 'Error_instances');

% Basic parameters
k = 4;
m = 3;
v = 3;
omega = 2;
n = omega*(k + m + v);
weights = 0:n;
d_CRC = 10;


% Compute the partial sum of distance spectrum
Partial_dist = zeros(n+1, 1); % Partial_sum(ii) = \sum_{d=0}^{ii-1} A_d, ii>=1
Partial_dist(1) = weight_spectrum(1); % note that the i-th entry has distance (i-1), i>=1

for ii = 2:n+1
    if ii <= size(weight_spectrum, 1) % d_max could be less than blocklength
        Partial_dist(ii) = Partial_dist(ii-1)+weight_spectrum(ii);
    else
        Partial_dist(ii) = Partial_dist(ii-1);
    end
end

% Compute the proposed upper bound on s^*(z)
Upper_bounds = zeros(1, n+1);
dist_threshold = floor((d_CRC-1)/2);
rho = floor((d_CRC+1)/2);
for ii = 1:n+1
    if ii<= dist_threshold
        Upper_bounds(ii) = Partial_dist(2*ii+1);
    else
        Upper_bounds(ii) = Partial_dist(2*rho+1);
    end
end

% Compute the maximum of list size given a particular noise weight
Max_list_sizes = zeros(1, n+1);
Min_list_sizes = zeros(1, n+1);
for w = 0:n
    Max_list_sizes(w+1) = max(Error_instances{w+1});
    Min_list_sizes(w+1) = min(Error_instances{w+1});
end
    



% plot comparison curves
figure;
plot(weights, Upper_bounds, '+-'); hold on
plot(weights, Max_list_sizes, '^-'); hold on
plot(weights, Conditional_expected_list_sizes, 'o-');hold on
plot(weights, Min_list_sizes, 'v-'); hold on
grid on
legend('Proposed upper bound','Max list size', 'Expected list size','Min list size');
xlabel('Noise weight $w$','interpreter', 'latex');
ylabel('List size', 'interpreter', 'latex');
title('k = 4, m = 3, CRC:(17), ZTCC (13, 17)');


