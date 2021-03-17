% This script is to generate plot of E[L] vs. SNR for CRC-TBCC codes.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/11/21
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


%% Case 1: k = 64, v = 3;

Exp_list_sizes_v_3 = cell(10, 1);
SNRs_v_3 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_181826_sim_data_vs_SNR_TBCC_13_17_CRC_17_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{1} = Exp_list_size_maxs;
SNRs_v_3{1} = SNRs;

fileName = '031521_182025_sim_data_vs_SNR_TBCC_13_17_CRC_37_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{2} = Exp_list_size_maxs;
SNRs_v_3{2} = SNRs;

fileName = '031521_182253_sim_data_vs_SNR_TBCC_13_17_CRC_55_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{3} = Exp_list_size_maxs;
SNRs_v_3{3} = SNRs;

fileName = '031521_182426_sim_data_vs_SNR_TBCC_13_17_CRC_143_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{4} = Exp_list_size_maxs;
SNRs_v_3{4} = SNRs;

fileName = '031521_182627_sim_data_vs_SNR_TBCC_13_17_CRC_355_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{5} = Exp_list_size_maxs;
SNRs_v_3{5} = SNRs;

fileName = '031521_182813_sim_data_vs_SNR_TBCC_13_17_CRC_407_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{6} = Exp_list_size_maxs;
SNRs_v_3{6} = SNRs;

fileName = '031521_183029_sim_data_vs_SNR_TBCC_13_17_CRC_1511_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{7} = Exp_list_size_maxs;
SNRs_v_3{7} = SNRs;

fileName = '031521_183317_sim_data_vs_SNR_TBCC_13_17_CRC_2235_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_3{8} = Exp_list_size_maxs;
SNRs_v_3{8} = SNRs;

figure;
idx = find(SNRs_v_3{1} == 1);
semilogy(SNRs_v_3{1}(idx:end), Exp_list_sizes_v_3{1}(idx:end), '-+');hold on
semilogy(SNRs_v_3{2}, Exp_list_sizes_v_3{2}, '-+');hold on
semilogy(SNRs_v_3{3}, Exp_list_sizes_v_3{3}, '-+');hold on
semilogy(SNRs_v_3{4}, Exp_list_sizes_v_3{4}, '-+');hold on
semilogy(SNRs_v_3{5}, Exp_list_sizes_v_3{5}, '-+');hold on
semilogy(SNRs_v_3{6}, Exp_list_sizes_v_3{6}, '-+');hold on
semilogy(SNRs_v_3{7}, Exp_list_sizes_v_3{7}, '-+');hold on
semilogy(SNRs_v_3{8}, Exp_list_sizes_v_3{8}, '-+');hold on

grid on
legend('$m=3, \nu=3$ CRC-TBCC',...
    '$m=4, \nu=3$ CRC-TBCC',...
    '$m=5, \nu=3$ CRC-TBCC',...
    '$m=6, \nu=3$ CRC-TBCC',...
    '$m=7, \nu=3$ CRC-TBCC',...
    '$m=8, \nu=3$ CRC-TBCC',...
    '$m=9, \nu=3$ CRC-TBCC',...
    '$m=10, \nu=3$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 3, TBCC (13, 17)');


%% Case 2: k = 64, v = 4;

Exp_list_sizes_v_4 = cell(10, 1);
SNRs_v_4 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_181855_sim_data_vs_SNR_TBCC_27_31_CRC_17_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{1} = Exp_list_size_maxs;
SNRs_v_4{1} = SNRs;

fileName = '031521_182036_sim_data_vs_SNR_TBCC_27_31_CRC_21_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{2} = Exp_list_size_maxs;
SNRs_v_4{2} = SNRs;

fileName = '031521_182303_sim_data_vs_SNR_TBCC_27_31_CRC_63_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{3} = Exp_list_size_maxs;
SNRs_v_4{3} = SNRs;

fileName = '031521_182438_sim_data_vs_SNR_TBCC_27_31_CRC_117_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{4} = Exp_list_size_maxs;
SNRs_v_4{4} = SNRs;

fileName = '031521_182639_sim_data_vs_SNR_TBCC_27_31_CRC_265_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{5} = Exp_list_size_maxs;
SNRs_v_4{5} = SNRs;

fileName = '031521_182827_sim_data_vs_SNR_TBCC_27_31_CRC_653_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{6} = Exp_list_size_maxs;
SNRs_v_4{6} = SNRs;

fileName = '031521_183045_sim_data_vs_SNR_TBCC_27_31_CRC_1145_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{7} = Exp_list_size_maxs;
SNRs_v_4{7} = SNRs;

fileName = '031521_183330_sim_data_vs_SNR_TBCC_27_31_CRC_2321_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_4{8} = Exp_list_size_maxs;
SNRs_v_4{8} = SNRs;

figure;
semilogy(SNRs_v_4{1}, Exp_list_sizes_v_4{1}, '-+');hold on
semilogy(SNRs_v_4{2}, Exp_list_sizes_v_4{2}, '-+');hold on
semilogy(SNRs_v_4{3}, Exp_list_sizes_v_4{3}, '-+');hold on
semilogy(SNRs_v_4{4}, Exp_list_sizes_v_4{4}, '-+');hold on
semilogy(SNRs_v_4{5}, Exp_list_sizes_v_4{5}, '-+');hold on
semilogy(SNRs_v_4{6}, Exp_list_sizes_v_4{6}, '-+');hold on
semilogy(SNRs_v_4{7}, Exp_list_sizes_v_4{7}, '-+');hold on
semilogy(SNRs_v_4{8}, Exp_list_sizes_v_4{8}, '-+');hold on

grid on
legend('$m=3, \nu=4$ CRC-TBCC',...
    '$m=4, \nu=4$ CRC-TBCC',...
    '$m=5, \nu=4$ CRC-TBCC',...
    '$m=6, \nu=4$ CRC-TBCC',...
    '$m=7, \nu=4$ CRC-TBCC',...
    '$m=8, \nu=4$ CRC-TBCC',...
    '$m=9, \nu=4$ CRC-TBCC',...
    '$m=10, \nu=4$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 4, TBCC (27, 31)');



%% Case 3: k = 64, v = 5;

Exp_list_sizes_v_5 = cell(10, 1);
SNRs_v_5 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_181907_sim_data_vs_SNR_TBCC_53_75_CRC_11_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{1} = Exp_list_size_maxs;
SNRs_v_5{1} = SNRs;

fileName = '031521_182048_sim_data_vs_SNR_TBCC_53_75_CRC_21_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{2} = Exp_list_size_maxs;
SNRs_v_5{2} = SNRs;

fileName = '031521_182316_sim_data_vs_SNR_TBCC_53_75_CRC_77_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{3} = Exp_list_size_maxs;
SNRs_v_5{3} = SNRs;

fileName = '031521_182449_sim_data_vs_SNR_TBCC_53_75_CRC_143_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{4} = Exp_list_size_maxs;
SNRs_v_5{4} = SNRs;

fileName = '031521_182651_sim_data_vs_SNR_TBCC_53_75_CRC_275_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{5} = Exp_list_size_maxs;
SNRs_v_5{5} = SNRs;

fileName = '031521_182841_sim_data_vs_SNR_TBCC_53_75_CRC_555_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{6} = Exp_list_size_maxs;
SNRs_v_5{6} = SNRs;

fileName = '031521_183058_sim_data_vs_SNR_TBCC_53_75_CRC_1511_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{7} = Exp_list_size_maxs;
SNRs_v_5{7} = SNRs;

fileName = '031521_183348_sim_data_vs_SNR_TBCC_53_75_CRC_2033_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_5{8} = Exp_list_size_maxs;
SNRs_v_5{8} = SNRs;

figure;
semilogy(SNRs_v_5{1}, Exp_list_sizes_v_5{1}, '-+');hold on
semilogy(SNRs_v_5{2}, Exp_list_sizes_v_5{2}, '-+');hold on
semilogy(SNRs_v_5{3}, Exp_list_sizes_v_5{3}, '-+');hold on
semilogy(SNRs_v_5{4}, Exp_list_sizes_v_5{4}, '-+');hold on
semilogy(SNRs_v_5{5}, Exp_list_sizes_v_5{5}, '-+');hold on
semilogy(SNRs_v_5{6}, Exp_list_sizes_v_5{6}, '-+');hold on
semilogy(SNRs_v_5{7}, Exp_list_sizes_v_5{7}, '-+');hold on
semilogy(SNRs_v_5{8}, Exp_list_sizes_v_5{8}, '-+');hold on

grid on
legend('$m=3, \nu=5$ CRC-TBCC',...
    '$m=4, \nu=5$ CRC-TBCC',...
    '$m=5, \nu=5$ CRC-TBCC',...
    '$m=6, \nu=5$ CRC-TBCC',...
    '$m=7, \nu=5$ CRC-TBCC',...
    '$m=8, \nu=5$ CRC-TBCC',...
    '$m=9, \nu=5$ CRC-TBCC',...
    '$m=10, \nu=5$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 5, TBCC (53, 75)');



%% Case 4: k = 64, v = 6;

Exp_list_sizes_v_6 = cell(10, 1);
SNRs_v_6 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_181918_sim_data_vs_SNR_TBCC_133_171_CRC_17_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{1} = Exp_list_size_maxs;
SNRs_v_6{1} = SNRs;

fileName = '031521_182059_sim_data_vs_SNR_TBCC_133_171_CRC_33_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{2} = Exp_list_size_maxs;
SNRs_v_6{2} = SNRs;

fileName = '031521_182328_sim_data_vs_SNR_TBCC_133_171_CRC_75_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{3} = Exp_list_size_maxs;
SNRs_v_6{3} = SNRs;

fileName = '031521_182501_sim_data_vs_SNR_TBCC_133_171_CRC_177_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{4} = Exp_list_size_maxs;
SNRs_v_6{4} = SNRs;

fileName = '031521_182702_sim_data_vs_SNR_TBCC_133_171_CRC_377_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{5} = Exp_list_size_maxs;
SNRs_v_6{5} = SNRs;

fileName = '031521_182854_sim_data_vs_SNR_TBCC_133_171_CRC_505_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{6} = Exp_list_size_maxs;
SNRs_v_6{6} = SNRs;

fileName = '031521_183113_sim_data_vs_SNR_TBCC_133_171_CRC_1275_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{7} = Exp_list_size_maxs;
SNRs_v_6{7} = SNRs;

fileName = '031521_183401_sim_data_vs_SNR_TBCC_133_171_CRC_2561_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_6{8} = Exp_list_size_maxs;
SNRs_v_6{8} = SNRs;

figure;
semilogy(SNRs_v_6{1}, Exp_list_sizes_v_6{1}, '-+');hold on
semilogy(SNRs_v_6{2}, Exp_list_sizes_v_6{2}, '-+');hold on
semilogy(SNRs_v_6{3}, Exp_list_sizes_v_6{3}, '-+');hold on
semilogy(SNRs_v_6{4}, Exp_list_sizes_v_6{4}, '-+');hold on
semilogy(SNRs_v_6{5}, Exp_list_sizes_v_6{5}, '-+');hold on
semilogy(SNRs_v_6{6}, Exp_list_sizes_v_6{6}, '-+');hold on
semilogy(SNRs_v_6{7}, Exp_list_sizes_v_6{7}, '-+');hold on
semilogy(SNRs_v_6{8}, Exp_list_sizes_v_6{8}, '-+');hold on

grid on
legend('$m=3, \nu=6$ CRC-TBCC',...
    '$m=4, \nu=6$ CRC-TBCC',...
    '$m=5, \nu=6$ CRC-TBCC',...
    '$m=6, \nu=6$ CRC-TBCC',...
    '$m=7, \nu=6$ CRC-TBCC',...
    '$m=8, \nu=6$ CRC-TBCC',...
    '$m=9, \nu=6$ CRC-TBCC',...
    '$m=10, \nu=6$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 6, TBCC (133, 171)');




%% Case 5: k = 64, v = 7;

Exp_list_sizes_v_7 = cell(10, 1);
SNRs_v_7 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_181930_sim_data_vs_SNR_TBCC_247_371_CRC_17_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{1} = Exp_list_size_maxs;
SNRs_v_7{1} = SNRs;

fileName = '031521_182111_sim_data_vs_SNR_TBCC_247_371_CRC_21_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{2} = Exp_list_size_maxs;
SNRs_v_7{2} = SNRs;

fileName = '031521_182339_sim_data_vs_SNR_TBCC_247_371_CRC_63_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{3} = Exp_list_size_maxs;
SNRs_v_7{3} = SNRs;

fileName = '031521_182515_sim_data_vs_SNR_TBCC_247_371_CRC_143_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{4} = Exp_list_size_maxs;
SNRs_v_7{4} = SNRs;

fileName = '031521_182714_sim_data_vs_SNR_TBCC_247_371_CRC_357_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{5} = Exp_list_size_maxs;
SNRs_v_7{5} = SNRs;

fileName = '031521_182907_sim_data_vs_SNR_TBCC_247_371_CRC_505_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{6} = Exp_list_size_maxs;
SNRs_v_7{6} = SNRs;

fileName = '031521_183126_sim_data_vs_SNR_TBCC_247_371_CRC_1641_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{7} = Exp_list_size_maxs;
SNRs_v_7{7} = SNRs;

fileName = '031521_183524_sim_data_vs_SNR_TBCC_247_371_CRC_2727_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_7{8} = Exp_list_size_maxs;
SNRs_v_7{8} = SNRs;

figure;
semilogy(SNRs_v_7{1}, Exp_list_sizes_v_7{1}, '-+');hold on
semilogy(SNRs_v_7{2}, Exp_list_sizes_v_7{2}, '-+');hold on
semilogy(SNRs_v_7{3}, Exp_list_sizes_v_7{3}, '-+');hold on
semilogy(SNRs_v_7{4}, Exp_list_sizes_v_7{4}, '-+');hold on
semilogy(SNRs_v_7{5}, Exp_list_sizes_v_7{5}, '-+');hold on
semilogy(SNRs_v_7{6}, Exp_list_sizes_v_7{6}, '-+');hold on
semilogy(SNRs_v_7{7}, Exp_list_sizes_v_7{7}, '-+');hold on
semilogy(SNRs_v_7{8}, Exp_list_sizes_v_7{8}, '-+');hold on

grid on
legend('$m=3, \nu=7$ CRC-TBCC',...
    '$m=4, \nu=7$ CRC-TBCC',...
    '$m=5, \nu=7$ CRC-TBCC',...
    '$m=6, \nu=7$ CRC-TBCC',...
    '$m=7, \nu=7$ CRC-TBCC',...
    '$m=8, \nu=7$ CRC-TBCC',...
    '$m=9, \nu=7$ CRC-TBCC',...
    '$m=10, \nu=7$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 7, TBCC (247, 371)');




%% Case 6: k = 64, v = 8;

Exp_list_sizes_v_8 = cell(10, 1);
SNRs_v_8 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_181942_sim_data_vs_SNR_TBCC_561_753_CRC_17_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{1} = Exp_list_size_maxs;
SNRs_v_8{1} = SNRs;

fileName = '031521_182124_sim_data_vs_SNR_TBCC_561_753_CRC_21_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{2} = Exp_list_size_maxs;
SNRs_v_8{2} = SNRs;

fileName = '031521_182350_sim_data_vs_SNR_TBCC_561_753_CRC_63_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{3} = Exp_list_size_maxs;
SNRs_v_8{3} = SNRs;

fileName = '031521_182544_sim_data_vs_SNR_TBCC_561_753_CRC_177_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{4} = Exp_list_size_maxs;
SNRs_v_8{4} = SNRs;

fileName = '031521_182727_sim_data_vs_SNR_TBCC_561_753_CRC_377_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{5} = Exp_list_size_maxs;
SNRs_v_8{5} = SNRs;

fileName = '031521_182924_sim_data_vs_SNR_TBCC_561_753_CRC_653_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{6} = Exp_list_size_maxs;
SNRs_v_8{6} = SNRs;

fileName = '031521_183150_sim_data_vs_SNR_TBCC_561_753_CRC_1401_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{7} = Exp_list_size_maxs;
SNRs_v_8{7} = SNRs;

fileName = '031521_183540_sim_data_vs_SNR_TBCC_561_753_CRC_2365_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_8{8} = Exp_list_size_maxs;
SNRs_v_8{8} = SNRs;

figure;
semilogy(SNRs_v_8{1}, Exp_list_sizes_v_8{1}, '-+');hold on
semilogy(SNRs_v_8{2}, Exp_list_sizes_v_8{2}, '-+');hold on
semilogy(SNRs_v_8{3}, Exp_list_sizes_v_8{3}, '-+');hold on
semilogy(SNRs_v_8{4}, Exp_list_sizes_v_8{4}, '-+');hold on
semilogy(SNRs_v_8{5}, Exp_list_sizes_v_8{5}, '-+');hold on
semilogy(SNRs_v_8{6}, Exp_list_sizes_v_8{6}, '-+');hold on
semilogy(SNRs_v_8{7}, Exp_list_sizes_v_8{7}, '-+');hold on
semilogy(SNRs_v_8{8}, Exp_list_sizes_v_8{8}, '-+');hold on

grid on
legend('$m=3, \nu=8$ CRC-TBCC',...
    '$m=4, \nu=8$ CRC-TBCC',...
    '$m=5, \nu=8$ CRC-TBCC',...
    '$m=6, \nu=8$ CRC-TBCC',...
    '$m=7, \nu=8$ CRC-TBCC',...
    '$m=8, \nu=8$ CRC-TBCC',...
    '$m=9, \nu=8$ CRC-TBCC',...
    '$m=10, \nu=8$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 8, TBCC (561, 753)');





%% Case 7: k = 64, v = 9;

Exp_list_sizes_v_9 = cell(10, 1);
SNRs_v_9 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_181959_sim_data_vs_SNR_TBCC_1131_1537_CRC_15_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{1} = Exp_list_size_maxs;
SNRs_v_9{1} = SNRs;

fileName = '031521_182135_sim_data_vs_SNR_TBCC_1131_1537_CRC_25_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{2} = Exp_list_size_maxs;
SNRs_v_9{2} = SNRs;

fileName = '031521_182403_sim_data_vs_SNR_TBCC_1131_1537_CRC_63_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{3} = Exp_list_size_maxs;
SNRs_v_9{3} = SNRs;

fileName = '031521_182604_sim_data_vs_SNR_TBCC_1131_1537_CRC_121_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{4} = Exp_list_size_maxs;
SNRs_v_9{4} = SNRs;

fileName = '031521_182742_sim_data_vs_SNR_TBCC_1131_1537_CRC_305_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{5} = Exp_list_size_maxs;
SNRs_v_9{5} = SNRs;

fileName = '031521_182939_sim_data_vs_SNR_TBCC_1131_1537_CRC_777_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{6} = Exp_list_size_maxs;
SNRs_v_9{6} = SNRs;

fileName = '031521_183224_sim_data_vs_SNR_TBCC_1131_1537_CRC_1511_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{7} = Exp_list_size_maxs;
SNRs_v_9{7} = SNRs;

fileName = '031521_183642_sim_data_vs_SNR_TBCC_1131_1537_CRC_2603_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_9{8} = Exp_list_size_maxs;
SNRs_v_9{8} = SNRs;

figure;
semilogy(SNRs_v_9{1}, Exp_list_sizes_v_9{1}, '-+');hold on
semilogy(SNRs_v_9{2}, Exp_list_sizes_v_9{2}, '-+');hold on
semilogy(SNRs_v_9{3}, Exp_list_sizes_v_9{3}, '-+');hold on
semilogy(SNRs_v_9{4}, Exp_list_sizes_v_9{4}, '-+');hold on
semilogy(SNRs_v_9{5}, Exp_list_sizes_v_9{5}, '-+');hold on
semilogy(SNRs_v_9{6}, Exp_list_sizes_v_9{6}, '-+');hold on
semilogy(SNRs_v_9{7}, Exp_list_sizes_v_9{7}, '-+');hold on
semilogy(SNRs_v_9{8}, Exp_list_sizes_v_9{8}, '-+');hold on

grid on
legend('$m=3, \nu=9$ CRC-TBCC',...
    '$m=4, \nu=9$ CRC-TBCC',...
    '$m=5, \nu=9$ CRC-TBCC',...
    '$m=6, \nu=9$ CRC-TBCC',...
    '$m=7, \nu=9$ CRC-TBCC',...
    '$m=8, \nu=9$ CRC-TBCC',...
    '$m=9, \nu=9$ CRC-TBCC',...
    '$m=10, \nu=9$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 9, TBCC (1131, 1537)');



%% Case 8: k = 64, v = 10;

Exp_list_sizes_v_10 = cell(10, 1);
SNRs_v_10 = cell(10, 1);

% load file
path = './TCOM_sim_data/';
fileName = '031521_182013_sim_data_vs_SNR_TBCC_2473_3217_CRC_17_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{1} = Exp_list_size_maxs;
SNRs_v_10{1} = SNRs;

fileName = '031521_182147_sim_data_vs_SNR_TBCC_2473_3217_CRC_33_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{2} = Exp_list_size_maxs;
SNRs_v_10{2} = SNRs;

fileName = '031621_134659_sim_data_vs_SNR_TBCC_2473_3217_CRC_63_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{3} = Exp_list_size_maxs;
SNRs_v_10{3} = SNRs;

fileName = '031521_182616_sim_data_vs_SNR_TBCC_2473_3217_CRC_171_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{4} = Exp_list_size_maxs;
SNRs_v_10{4} = SNRs;

fileName = '031521_182800_sim_data_vs_SNR_TBCC_2473_3217_CRC_273_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{5} = Exp_list_size_maxs;
SNRs_v_10{5} = SNRs;

fileName = '031521_183003_sim_data_vs_SNR_TBCC_2473_3217_CRC_631_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{6} = Exp_list_size_maxs;
SNRs_v_10{6} = SNRs;

fileName = '031521_183259_sim_data_vs_SNR_TBCC_2473_3217_CRC_1027_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{7} = Exp_list_size_maxs;
SNRs_v_10{7} = SNRs;

fileName = '031521_183807_sim_data_vs_SNR_TBCC_2473_3217_CRC_2335_k_64';
load([path, fileName, '.mat'], 'Exp_list_size_maxs', 'SNRs');
Exp_list_sizes_v_10{8} = Exp_list_size_maxs;
SNRs_v_10{8} = SNRs;

figure;
semilogy(SNRs_v_10{1}, Exp_list_sizes_v_10{1}, '-+');hold on
semilogy(SNRs_v_10{2}, Exp_list_sizes_v_10{2}, '-+');hold on
semilogy(SNRs_v_10{3}, Exp_list_sizes_v_10{3}, '-+');hold on
semilogy(SNRs_v_10{4}, Exp_list_sizes_v_10{4}, '-+');hold on
semilogy(SNRs_v_10{5}, Exp_list_sizes_v_10{5}, '-+');hold on
semilogy(SNRs_v_10{6}, Exp_list_sizes_v_10{6}, '-+');hold on
semilogy(SNRs_v_10{7}, Exp_list_sizes_v_10{7}, '-+');hold on
semilogy(SNRs_v_10{8}, Exp_list_sizes_v_10{8}, '-+');hold on

grid on
legend('$m=3, \nu=10$ CRC-TBCC',...
    '$m=4, \nu=10$ CRC-TBCC',...
    '$m=5, \nu=10$ CRC-TBCC',...
    '$m=6, \nu=10$ CRC-TBCC',...
    '$m=7, \nu=10$ CRC-TBCC',...
    '$m=8, \nu=10$ CRC-TBCC',...
    '$m=9, \nu=10$ CRC-TBCC',...
    '$m=10, \nu=10$ CRC-TBCC',...
    'Location','northeast');

xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Expected list rank $\mathrm{E}[L]$', 'interpreter', 'latex');
title('k = 64, \nu = 10, TBCC (2473, 3217)');


