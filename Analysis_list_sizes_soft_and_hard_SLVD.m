%   This script is to compare the simulated average list sizes for soft S-LVD
%   and hard S-LVD.
%
%
%   Written by Hengjie Yang (hengjie.yang@ucla.edu) 11/20/20.
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

path = './Simulation_results/';
load([path, '110420_180539_sim_list_sizes_ZTCC_13_17_CRC_17_k_4.mat'], 'Ave_list_sizes', 'snr_dBs');
Hard_ave_list_sizes = Ave_list_sizes;
Hard_ave_list_sizes = Hard_ave_list_sizes(1:end-4);

load([path, '112020_143108_sim_list_sizes_soft_ZTCC_13_17_CRC_17_k_4.mat'], 'Ave_list_sizes', 'snr_dBs');
Soft_ave_list_sizes = Ave_list_sizes;
Soft_ave_list_sizes = Soft_ave_list_sizes(1:end-4);

snr_dBs = snr_dBs(1:end-4);


figure;
plot(snr_dBs, Hard_ave_list_sizes, '+-'); hold on
plot(snr_dBs, Soft_ave_list_sizes, 'o-'); hold on
grid on
legend('Discrete case', 'Continuous case');
xlabel('SNR (dB)','interpreter', 'latex');
ylabel('List size', 'interpreter', 'latex');
title('k = 4, m = 3, \rho = 9, CRC:(17), ZTCC (13, 17)');




