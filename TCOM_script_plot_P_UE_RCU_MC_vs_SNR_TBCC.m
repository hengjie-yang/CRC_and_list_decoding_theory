% This script is to generate P_{e, \lambda} vs. SNR curve and compare it
% with the RCU bound and MC bound. The plot is mainly for CRC-TBCC codes.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)    03/04/21.
%



clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


%% Case 1:  k = 64, n = 134, m = 3
% basic parameters
k = 64;
m = 3;
omega = 2;
n = omega*(k + m);



% load file 
path = './TCOM_sim_data/';

fileName = '030821_231648_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_17_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_17 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_17 = SNRs;

fileName = '030421_115833_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_17_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_17 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_17 = SNRs;

fileName = '030421_125256_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_11_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_11 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_11 = SNRs;

fileName = '030421_132529_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_17_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_17 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_17 = SNRs;

fileName = '030421_171402_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_17_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_17 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_17 = SNRs;

fileName = '030521_094115_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_17_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_17 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_17 = SNRs;

fileName = '030721_134506_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_1131_1537_CRC_15_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_15 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_15 = SNRs;

fileName = '030821_211518_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_2473_3217_CRC_17_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_2473_3217_CRC_17 = P_UE_maxs;
SNRs_TBCC_2473_3217_CRC_17 = SNRs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_17, P_UE_TBCC_13_17_CRC_17, '-+'); hold on
semilogy(SNRs_TBCC_27_31_CRC_17, P_UE_TBCC_27_31_CRC_17, '-+'); hold on
semilogy(SNRs_TBCC_53_75_CRC_11, P_UE_TBCC_53_75_CRC_11, '-+'); hold on
semilogy(SNRs_TBCC_133_171_CRC_17, P_UE_TBCC_133_171_CRC_17, '-+'); hold on
semilogy(SNRs_TBCC_247_371_CRC_17, P_UE_TBCC_247_371_CRC_17, '-+'); hold on
semilogy(SNRs_TBCC_561_753_CRC_17, P_UE_TBCC_561_753_CRC_17, '-+'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_15, P_UE_TBCC_1131_1537_CRC_15, '-+'); hold on
semilogy(SNRs_TBCC_2473_3217_CRC_17, P_UE_TBCC_2473_3217_CRC_17, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=3, \nu=3$ CRC-TBCC',...
    '$m=3, \nu=4$ CRC-TBCC',...
    '$m=3, \nu=5$ CRC-TBCC',...
    '$m=3, \nu=6$ CRC-TBCC',...
    '$m=3, \nu=7$ CRC-TBCC',...
    '$m=3, \nu=8$ CRC-TBCC',...
    '$m=3, \nu=9$ CRC-TBCC',...
    '$m=3, \nu=10$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 134, R = 0.478');




%% Case 2:  k = 64, n = 136, m = 4
% basic parameters
k = 64;
m = 4;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '030821_224936_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_37_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_37 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_37 = SNRs;

fileName = '030821_225400_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_21_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_21 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_21 = SNRs;

fileName = '030421_145713_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_21_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_21 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_21 = SNRs;

fileName = '030421_190407_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_33_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_33 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_33 = SNRs;

fileName = '030421_203611_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_21_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_21 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_21 = SNRs;

fileName = '030521_093846_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_21_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_21 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_21 = SNRs;

fileName = '030821_211235_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_1131_1537_CRC_25_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_25 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_25 = SNRs;

fileName = '030821_210831_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_2473_3217_CRC_33_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_2473_3217_CRC_33 = P_UE_maxs;
SNRs_TBCC_2473_3217_CRC_33 = SNRs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_37, P_UE_TBCC_13_17_CRC_37, '-+'); hold on
semilogy(SNRs_TBCC_27_31_CRC_21, P_UE_TBCC_27_31_CRC_21, '-+'); hold on
semilogy(SNRs_TBCC_53_75_CRC_21, P_UE_TBCC_53_75_CRC_21, '-+'); hold on
semilogy(SNRs_TBCC_133_171_CRC_33, P_UE_TBCC_133_171_CRC_33, '-+'); hold on
semilogy(SNRs_TBCC_247_371_CRC_21, P_UE_TBCC_247_371_CRC_21, '-+'); hold on
semilogy(SNRs_TBCC_561_753_CRC_21, P_UE_TBCC_561_753_CRC_21, '-+'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_25, P_UE_TBCC_1131_1537_CRC_25, '-+'); hold on
semilogy(SNRs_TBCC_2473_3217_CRC_33, P_UE_TBCC_2473_3217_CRC_33, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=4, \nu=3$ CRC-TBCC',...
    '$m=4, \nu=4$ CRC-TBCC',...
    '$m=4, \nu=5$ CRC-TBCC',...
    '$m=4, \nu=6$ CRC-TBCC',...
    '$m=4, \nu=7$ CRC-TBCC',...
    '$m=4, \nu=8$ CRC-TBCC',...
    '$m=4, \nu=9$ CRC-TBCC',...
    '$m=4, \nu=10$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 136, R = 0.471');



%% Case 3:  k = 64, n = 138, m = 5
% basic parameters
k = 64;
m = 5;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '030821_225951_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_55_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_55 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_55 = SNRs;

fileName = '030521_150812_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_63_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_63 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_63 = SNRs;

fileName = '030521_150852_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_77_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_77 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_77 = SNRs;

fileName = '030521_150949_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_75_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_75 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_75 = SNRs;

fileName = '030521_163812_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_63_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_63 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_63 = SNRs;

fileName = '030821_211823_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_63_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_63 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_63 = SNRs;

fileName = '030821_212054_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_1131_1537_CRC_63_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_63 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_63 = SNRs;

fileName = '030821_212241_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_2473_3217_CRC_63_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_2473_3217_CRC_63 = P_UE_maxs;
SNRs_TBCC_2473_3217_CRC_63 = SNRs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_55, P_UE_TBCC_13_17_CRC_55, '-+'); hold on
semilogy(SNRs_TBCC_27_31_CRC_63, P_UE_TBCC_27_31_CRC_63, '-+'); hold on
semilogy(SNRs_TBCC_53_75_CRC_77, P_UE_TBCC_53_75_CRC_77, '-+'); hold on
semilogy(SNRs_TBCC_133_171_CRC_75, P_UE_TBCC_133_171_CRC_75, '-+'); hold on
semilogy(SNRs_TBCC_247_371_CRC_63, P_UE_TBCC_247_371_CRC_63, '-+'); hold on
semilogy(SNRs_TBCC_561_753_CRC_63, P_UE_TBCC_561_753_CRC_63, '-+'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_63, P_UE_TBCC_1131_1537_CRC_63, '-+'); hold on
semilogy(SNRs_TBCC_2473_3217_CRC_63, P_UE_TBCC_2473_3217_CRC_63, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=5, \nu=3$ CRC-TBCC',...
    '$m=5, \nu=4$ CRC-TBCC',...
    '$m=5, \nu=5$ CRC-TBCC',...
    '$m=5, \nu=6$ CRC-TBCC',...
    '$m=5, \nu=7$ CRC-TBCC',...
    '$m=5, \nu=8$ CRC-TBCC',...
    '$m=5, \nu=9$ CRC-TBCC',...
    '$m=5, \nu=10$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 138, R = 0.464');




%% Case 4:  k = 64, n = 140, m = 6
% basic parameters
k = 64;
m = 6;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '030521_164036_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_143_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_143 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_143 = SNRs;

fileName = '030521_164120_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_117_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_117 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_117 = SNRs;

fileName = '030521_164220_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_143_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_143 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_143 = SNRs;

fileName = '030521_170021_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_177_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_177 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_177 = SNRs;

fileName = '030521_194806_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_143_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_143 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_143 = SNRs;

fileName = '030821_212438_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_177_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_177 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_177 = SNRs;

fileName = '030821_212555_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_1131_1537_CRC_121_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_121 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_121 = SNRs;

fileName = '030821_212713_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_2473_3217_CRC_171_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_2473_3217_CRC_171 = P_UE_maxs;
SNRs_TBCC_2473_3217_CRC_171 = SNRs;


fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_143, P_UE_TBCC_13_17_CRC_143, '-+'); hold on
semilogy(SNRs_TBCC_27_31_CRC_117, P_UE_TBCC_27_31_CRC_117, '-+'); hold on
semilogy(SNRs_TBCC_53_75_CRC_143, P_UE_TBCC_53_75_CRC_143, '-+'); hold on
semilogy(SNRs_TBCC_133_171_CRC_177, P_UE_TBCC_133_171_CRC_177, '-+'); hold on
semilogy(SNRs_TBCC_247_371_CRC_143, P_UE_TBCC_247_371_CRC_143, '-+'); hold on
semilogy(SNRs_TBCC_561_753_CRC_177, P_UE_TBCC_561_753_CRC_177, '-+'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_121, P_UE_TBCC_1131_1537_CRC_121, '-+'); hold on
semilogy(SNRs_TBCC_2473_3217_CRC_171, P_UE_TBCC_2473_3217_CRC_171, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=6, \nu=3$ CRC-TBCC',...
    '$m=6, \nu=4$ CRC-TBCC',...
    '$m=6, \nu=5$ CRC-TBCC',...
    '$m=6, \nu=6$ CRC-TBCC',...
    '$m=6, \nu=7$ CRC-TBCC',...
    '$m=6, \nu=8$ CRC-TBCC',...
    '$m=6, \nu=9$ CRC-TBCC',...
    '$m=6, \nu=10$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 140, R = 0.457');


%% Case 5:  k = 64, n = 142, m = 7
% basic parameters
k = 64;
m = 7;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '030521_195504_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_355_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_355 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_355 = SNRs;

fileName = '030521_195547_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_265_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_265 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_265 = SNRs;

fileName = '030521_195733_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_275_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_275 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_275 = SNRs;

fileName = '030521_204400_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_377_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_377 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_377 = SNRs;

fileName = '030621_231334_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_357_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_357 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_357 = SNRs;

fileName = '030821_212850_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_377_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_377 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_377 = SNRs;

fileName = '030821_213015_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_1131_1537_CRC_305_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_305 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_305 = SNRs;

fileName = '030921_100949_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_2473_3217_CRC_273_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_2473_3217_CRC_273 = P_UE_maxs;
SNRs_TBCC_2473_3217_CRC_273 = SNRs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_355, P_UE_TBCC_13_17_CRC_355, '-+'); hold on
semilogy(SNRs_TBCC_27_31_CRC_265, P_UE_TBCC_27_31_CRC_265, '-+'); hold on
semilogy(SNRs_TBCC_53_75_CRC_275, P_UE_TBCC_53_75_CRC_275, '-+'); hold on
semilogy(SNRs_TBCC_133_171_CRC_377, P_UE_TBCC_133_171_CRC_377, '-+'); hold on
semilogy(SNRs_TBCC_247_371_CRC_357, P_UE_TBCC_247_371_CRC_357, '-+'); hold on
semilogy(SNRs_TBCC_561_753_CRC_377, P_UE_TBCC_561_753_CRC_377, '-+'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_305, P_UE_TBCC_1131_1537_CRC_305, '-+'); hold on
semilogy(SNRs_TBCC_2473_3217_CRC_273, P_UE_TBCC_2473_3217_CRC_273, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=7, \nu=3$ CRC-TBCC',...
    '$m=7, \nu=4$ CRC-TBCC',...
    '$m=7, \nu=5$ CRC-TBCC',...
    '$m=7, \nu=6$ CRC-TBCC',...
    '$m=7, \nu=7$ CRC-TBCC',...
    '$m=7, \nu=8$ CRC-TBCC',...
    '$m=7, \nu=9$ CRC-TBCC',...
    '$m=7, \nu=10$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 142, R = 0.451');


%% Case 6:  k = 64, n = 144, m = 8
% basic parameters
k = 64;
m = 8;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '030621_231558_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_407_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_407 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_407 = SNRs;

fileName = '030621_231657_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_653_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_653 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_653 = SNRs;

fileName = '030621_231749_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_555_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_555 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_555 = SNRs;

fileName = '030621_231914_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_505_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_505 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_505 = SNRs;

fileName = '030621_235756_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_505_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_505 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_505 = SNRs;

fileName = '030821_213208_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_653_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_653 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_653 = SNRs;

fileName = '030921_101125_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_1131_1537_CRC_777_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_777 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_777 = SNRs;

fileName = '031121_163302_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_2473_3217_CRC_631_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_2473_3217_CRC_631 = P_UE_maxs;
SNRs_TBCC_2473_3217_CRC_631 = SNRs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_407, P_UE_TBCC_13_17_CRC_407, '-+'); hold on
semilogy(SNRs_TBCC_27_31_CRC_653, P_UE_TBCC_27_31_CRC_653, '-+'); hold on
semilogy(SNRs_TBCC_53_75_CRC_555, P_UE_TBCC_53_75_CRC_555, '-+'); hold on
semilogy(SNRs_TBCC_133_171_CRC_505, P_UE_TBCC_133_171_CRC_505, '-+'); hold on
semilogy(SNRs_TBCC_247_371_CRC_505, P_UE_TBCC_247_371_CRC_505, '-+'); hold on
semilogy(SNRs_TBCC_561_753_CRC_653, P_UE_TBCC_561_753_CRC_653, '-+'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_777, P_UE_TBCC_1131_1537_CRC_777, '-+'); hold on
semilogy(SNRs_TBCC_2473_3217_CRC_631, P_UE_TBCC_2473_3217_CRC_631, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=8, \nu=3$ CRC-TBCC',...
    '$m=8, \nu=4$ CRC-TBCC',...
    '$m=8, \nu=5$ CRC-TBCC',...
    '$m=8, \nu=6$ CRC-TBCC',...
    '$m=8, \nu=7$ CRC-TBCC',...
    '$m=8, \nu=8$ CRC-TBCC',...
    '$m=8, \nu=9$ CRC-TBCC',...
    '$m=8, \nu=10$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 144, R = 0.444');


%% Case 7:  k = 64, n = 146, m = 9
% basic parameters
k = 64;
m = 9;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '030621_232102_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_1511_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_1511 = P_UE_maxs;
SNRs_TBCC_13_17_CRC_1511 = SNRs;

fileName = '030621_232149_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_1145_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_1145 = P_UE_maxs;
SNRs_TBCC_27_31_CRC_1145 = SNRs;

fileName = '030621_232232_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_1511_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_1511 = P_UE_maxs;
SNRs_TBCC_53_75_CRC_1511 = SNRs;

fileName = '030621_232312_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_1275_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_1275 = P_UE_maxs;
SNRs_TBCC_133_171_CRC_1275 = SNRs;

fileName = '030721_134920_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_1641_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_1641 = P_UE_maxs;
SNRs_TBCC_247_371_CRC_1641 = SNRs;

fileName = '030921_102214_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_1401_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_1401 = P_UE_maxs;
SNRs_TBCC_561_753_CRC_1401 = SNRs;

fileName = '031121_163630_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_1131_1537_CRC_1511_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_1131_1537_CRC_1511 = P_UE_maxs;
SNRs_TBCC_1131_1537_CRC_1511 = SNRs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_TBCC_13_17_CRC_1511, P_UE_TBCC_13_17_CRC_1511, '-+'); hold on
semilogy(SNRs_TBCC_27_31_CRC_1145, P_UE_TBCC_27_31_CRC_1145, '-+'); hold on
semilogy(SNRs_TBCC_53_75_CRC_1511, P_UE_TBCC_53_75_CRC_1511, '-+'); hold on
semilogy(SNRs_TBCC_133_171_CRC_1275, P_UE_TBCC_133_171_CRC_1275, '-+'); hold on
semilogy(SNRs_TBCC_247_371_CRC_1641, P_UE_TBCC_247_371_CRC_1641, '-+'); hold on
semilogy(SNRs_TBCC_561_753_CRC_1401, P_UE_TBCC_561_753_CRC_1401, '-+'); hold on
semilogy(SNRs_TBCC_1131_1537_CRC_1511, P_UE_TBCC_1131_1537_CRC_1511, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=9, \nu=3$ CRC-TBCC',...
    '$m=9, \nu=4$ CRC-TBCC',...
    '$m=9, \nu=5$ CRC-TBCC',...
    '$m=9, \nu=6$ CRC-TBCC',...
    '$m=9, \nu=7$ CRC-TBCC',...
    '$m=9, \nu=8$ CRC-TBCC',...
    '$m=9, \nu=9$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 146, R = 0.438');



%% Case 8:  k = 64, n = 148, m = 10
% basic parameters
k = 64;
m = 10;
omega = 2;
n = omega*(k + m);


% load file 
path = './TCOM_sim_data/';

fileName = '030721_135158_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_13_17_CRC_2235_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_13_17_CRC_2235 = P_UE_maxs;
SNRs_regular = SNRs;

fileName = '030721_135415_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_27_31_CRC_2321_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_27_31_CRC_2321 = P_UE_maxs;

fileName = '030721_135503_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_53_75_CRC_2033_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_53_75_CRC_2033 = P_UE_maxs;

fileName = '030721_142240_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_133_171_CRC_2561_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_133_171_CRC_2561 = P_UE_maxs;

fileName = '031121_174953_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_247_371_CRC_2727_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_247_371_CRC_2727 = P_UE_maxs;

fileName = '030521_093946_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_2365_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');
P_UE_TBCC_561_753_CRC_2365 = P_UE_maxs;
SNRs_temporary = SNRs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs_regular, P_UE_TBCC_13_17_CRC_2235, '-+'); hold on
semilogy(SNRs_regular, P_UE_TBCC_27_31_CRC_2321, '-+'); hold on
semilogy(SNRs_regular, P_UE_TBCC_53_75_CRC_2033, '-+'); hold on
semilogy(SNRs_regular, P_UE_TBCC_133_171_CRC_2561, '-+'); hold on
semilogy(SNRs_regular, P_UE_TBCC_247_371_CRC_2727, '-+'); hold on
semilogy(SNRs_temporary, P_UE_TBCC_561_753_CRC_2365, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-.'); hold on
semilogy(gamma_s, mc_bounds, '-.'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=10, \nu=3$ CRC-TBCC',...
    '$m=10, \nu=4$ CRC-TBCC',...
    '$m=10, \nu=5$ CRC-TBCC',...
    '$m=10, \nu=6$ CRC-TBCC',...
    '$m=10, \nu=7$ CRC-TBCC',...
    '$m=10, \nu=8$ CRC-TBCC',...
    'RCU bound',...
    'MC bound','Location','southwest');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 148, R = 0.432');


