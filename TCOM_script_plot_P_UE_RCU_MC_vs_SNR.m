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

% basic parameters
k = 64;
v = 8;
code_generator = [561, 753];
CRC_poly = '17';
poly = dec2bin(base2dec(CRC_poly, 8))-'0';
m = length(poly) - 1;
omega = size(code_generator, 2);
n = omega*(k + m);



% load file
path = './TCOM_sim_data/';
fileName = '030421_085810_sim_data_probs_and_exp_list_sizes_vs_SNR_TBCC_561_753_CRC_17_k_64';
load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs');

P_UE_TBCC_561_753_CRC_17 = P_UE_maxs;

fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');



% plot curves
figure;
semilogy(SNRs, P_UE_TBCC_561_753_CRC_17, '-+'); hold on
semilogy(gamma_s, rcu_bounds, '-'); hold on
semilogy(gamma_s, mc_bounds, '-'); hold on
grid on
ylim([10^(-8), 1]);
legend('$m=3, \nu=8$ CRC-TBCC',...
    'RCU bound',...
    'MC bound');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('k = 64, n = 134, R = 0.478');


