% This script is to generate the plot of P_UE vs. SNR for the family of 
% CRC-TBCC codes with m = 10. RCU and MC bounds are also displayed.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   04/05/21
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


k = 64;
m = 10;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '031521_183317_sim_data_vs_SNR_TBCC_13_17_CRC_2235_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_2235 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_2235 = SNRs;

fileName = '031521_183330_sim_data_vs_SNR_TBCC_27_31_CRC_2321_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_2321 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_2321 = SNRs;

fileName = '041221_104348_sim_data_vs_SNR_TBCC_53_75_CRC_2033_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_2033 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_2033 = SNRs;

fileName = '041221_104204_sim_data_vs_SNR_TBCC_133_171_CRC_2561_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_2561 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_2561 = SNRs;

fileName = '041221_104533_sim_data_vs_SNR_TBCC_247_371_CRC_2727_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_2727 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_2727 = SNRs;

fileName = '041221_104654_sim_data_vs_SNR_TBCC_561_753_CRC_2365_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_2365 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_2365 = SNRs;

fileName = '051621_104807_sim_data_vs_SNR_TBCC_1131_1537_CRC_2603_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_2603 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_2603 = SNRs;

fileName = '051621_104531_sim_data_vs_SNR_TBCC_2473_3217_CRC_2335_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_2473_3217_CRC_2335 = P_UE_maxs;
SNRs_TBCC_2473_3217_CRC_2335 = SNRs;

% delete last point
P_UE_TBCC_2473_3217_CRC_2335(end) = [];
SNRs_TBCC_2473_3217_CRC_2335(end) = [];


fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



%% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_2235, P_UE_TBCC_13_17_CRC_2235, '-x','Color','#0072BD'); hold on
semilogy(SNRs_TBCC_27_31_CRC_2321, P_UE_TBCC_27_31_CRC_2321, '-s','Color','#D95319'); hold on
semilogy(SNRs_TBCC_53_75_CRC_2033, P_UE_TBCC_53_75_CRC_2033, '-d','Color','#EDB120'); hold on
semilogy(SNRs_TBCC_133_171_CRC_2561, P_UE_TBCC_133_171_CRC_2561, '-*','Color','#7E2F8E'); hold on
semilogy(SNRs_TBCC_247_371_CRC_2727, P_UE_TBCC_247_371_CRC_2727, '-v','Color','#77AC30'); hold on
semilogy(SNRs_TBCC_561_753_CRC_2365, P_UE_TBCC_561_753_CRC_2365, '-^','Color','#4DBEEE'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_2603, P_UE_TBCC_1131_1537_CRC_2603, '-+','Color','#FF0000'); hold on
semilogy(SNRs_TBCC_2473_3217_CRC_2335, P_UE_TBCC_2473_3217_CRC_2335, '-o','Color','#0000FF'); hold on
semilogy(gamma_s, rcu_bounds, '-.k'); hold on
semilogy(gamma_s, mc_bounds, '-','Color','#A2142F'); hold on
grid on
ylim([10^(-7), 10^(-1)]);
xlim([1, 3])
legend('$m=10, \nu=3$',...
    '$m=10, \nu=4$',...
    '$m=10, \nu=5$',...
    '$m=10, \nu=6$',...
    '$m=10, \nu=7$',...
    '$m=10, \nu=8$',...
    '$m=10, \nu=9$',...
    '$m=10, \nu=10$',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of UE $P_{e, \lambda}$', 'interpreter', 'latex');
% title('k = 64, n = 148, R = 0.432');