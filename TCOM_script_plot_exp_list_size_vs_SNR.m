% This script is to generate E[L] vs. SNR curve for a family of CRC-ZTCC
% codes.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/03/21.
%



clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',18,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% basic parameters
k = 64;
v = 3;
code_generator = [13, 17];
CRC_poly = '103';
poly = dec2bin(base2dec(CRC_poly, 8))-'0';
m = length(poly) - 1;
omega = size(code_generator, 2);
n = omega*(k + m + v);
trellis = poly2trellis(v+1, code_generator);


% load file, degree m = 3, 4, 5, 6
path = './TCOM_sim_data/';

fileName = '030321_145727_sim_data_probs_and_exp_list_sizes_vs_SNR_ZTCC_13_17_CRC_11_k_64';
load([path, fileName, '.mat'],'Exp_list_size_maxs', 'SNRs');
Exp_list_size_ZTCC_13_17_CRC_11 = Exp_list_size_maxs;

fileName = '030321_170954_sim_data_probs_and_exp_list_sizes_vs_SNR_ZTCC_13_17_CRC_33_k_64';
load([path, fileName, '.mat'],'Exp_list_size_maxs', 'SNRs');
Exp_list_size_ZTCC_13_17_CRC_33 = Exp_list_size_maxs;

fileName = '030321_181227_sim_data_probs_and_exp_list_sizes_vs_SNR_ZTCC_13_17_CRC_55_k_64';
load([path, fileName, '.mat'],'Exp_list_size_maxs', 'SNRs');
Exp_list_size_ZTCC_13_17_CRC_55 = Exp_list_size_maxs;

fileName = '030321_143622_sim_data_probs_and_exp_list_sizes_vs_SNR_ZTCC_13_17_CRC_103_k_64';
load([path, fileName, '.mat'],'Exp_list_size_maxs', 'SNRs');
Exp_list_size_ZTCC_13_17_CRC_103 = Exp_list_size_maxs;



% Plot curves
figure;


plot(SNRs, Exp_list_size_ZTCC_13_17_CRC_103, '-+','LineWidth', 1.5);hold on
plot(SNRs, Exp_list_size_ZTCC_13_17_CRC_55, '-+','LineWidth', 1.5);hold on
plot(SNRs, Exp_list_size_ZTCC_13_17_CRC_33, '-+','LineWidth', 1.5);hold on
plot(SNRs, Exp_list_size_ZTCC_13_17_CRC_11, '-+','LineWidth', 1.5);hold on

yline(2^6,'--k','LineWidth',1); hold on
yline(2^5,'--k','LineWidth',1); hold on
yline(2^4,'--k','LineWidth',1); hold on
yline(2^3,'--k','LineWidth',1); hold on
grid on

legend('$m=6$, CRC poly. 0x43',...
    '$m=5$, CRC poly. 0x2D',...
    '$m=4$, CRC poly. 0x1B',...
    '$m=3$, CRC poly. 0x9');


yticks([1, 2^3, 2^4, 2^5, 2^6]);
yticklabels({'$1$', '$2^3$', '$2^4$', '$2^5$', '$2^6$'});

xlim([-4, 4]);

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list size $\mathrm{E}[L]$', 'interpreter', 'latex');



