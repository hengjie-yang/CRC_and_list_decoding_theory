% This script is to generate the plot of P_{e, 1} and P_{e, \lambda} as a
% function of SNR. We will also compute the full distance spectra of the
% low-rate code and high-rate code 
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/01/21.
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% basic parameters
k = 64;
m = 6;
v = 3;
code_generator = [13, 17];
omega = size(code_generator, 2);
n = omega*(k+m+v);
trellis = poly2trellis(v+1, code_generator);


% load file
path = './TCOM_sim_data/';
fileName = '030221_114109_sim_data_P_UE_and_exp_list_size_vs_SNR_ZTCC_13_17_CRC_103_k_64';
load([path, fileName, '.mat'],'P_UE_mins', 'P_UE_maxs','SNRs');


% Compute the union bound for P_{e, 1} and P_{e, \lambda}
Union_bound_mins = zeros(1, length(SNRs));
Union_bound_maxs = zeros(1, length(SNRs));

overall_code_generator = [1653, 1057];

fileName = ['weight_node_ZTCC_',num2str(overall_code_generator(1)),'_',num2str(overall_code_generator(2)),'_N_',num2str(k+m+v),'.mat'];
if ~exist(fileName, 'file')
    weight_node = Compute_ZTCC_weight_spectrum(m+v+1, overall_code_generator, k+m+v);
else
    load(fileName, 'weight_node');
end
low_rate_weight_spectrum = weight_node.weight_spectrum;

d_max = length(low_rate_weight_spectrum) - 1;
index = find(low_rate_weight_spectrum>0);
d_min = index(2) - 1;

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    A = sqrt(snr);
    for d = d_min:d_max
        C_d = low_rate_weight_spectrum(d+1);
        Union_bound_maxs(iter) = Union_bound_maxs(iter) + C_d*qfunc(A*sqrt(d));
    end
end

NNA_maxs = zeros(1, length(SNRs));
for iter = 1:length(SNRs)
    A = sqrt(10^(SNRs(iter)/10));
    NNA_maxs(iter) = low_rate_weight_spectrum(d_min+1)*qfunc(A*sqrt(d_min));
end

% Plot curves
figure;
semilogy(SNRs, Union_bound_maxs, '-.');hold on
semilogy(SNRs, NNA_maxs, '-.');hold on
semilogy(SNRs, P_UE_maxs, '-+','MarkerSize',5);hold on
semilogy(SNRs, P_UE_mins, '-+','MarkerSize',5);hold on
grid on
ylim([10^(-7), 1]);
legend('Union bound on $P_{e, \lambda}$',...
    'NNA on $P_{e, \lambda}$',...
    '$P_{e, \lambda}$',...
    '$P_{e, 1}$');
xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, degree-6 CRC (103), ZTCC (13, 17)');

