% This script is used to plot P_UE vs. Eb/N0 and E[L] vs. Eb/N0.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/04/21
%


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

EbN0s = [1.0:0.5:3.0];
P_UEs_wava1 = [0.104275287, 0.048579062, 0.010848340, 0.001666903, 0.000209140];
Ave_list_rank_wava1 = [26046.57, 12202.16, 2559.37, 362.41, 44.41];

P_UEs_wava2 = [0.130293160, 0.055975371, 0.013806434, 0.002638000, 0.000368598];
Ave_list_rank_wava2 = [6324.23, 2548.14, 742.69, 92.81, 12.99];

P_UEs_wava3 = [0.151400454, 0.057077626, 0.015217226, 0.003545785, 0.000429151];
Ave_list_rank_wava3 = [7604.64, 2553.94, 699.76, 143.83, 18.96];


figure;
semilogy(EbN0s, P_UEs_wava3, '-+'); hold on
semilogy(EbN0s, P_UEs_wava2, '-o'); hold on
semilogy(EbN0s, P_UEs_wava1, '-s'); hold on
semilogy([1:0.5:3],[1e-1,4e-2,8.5e-3,1.1e-3,1e-4],'--k');
grid on

legend('WAVA iter. = 3',...
    'WAVA iter. = 2',...
    'WAVA iter. = 1',...
    'RCU bound');
xlabel('$E_b/N_0$ (dB)','interpreter', 'latex');
ylabel('Probability of UE');
title('Ethan (128, 64) CRC-TBCC');



figure;
semilogy(EbN0s, Ave_list_rank_wava1, '-+'); hold on
semilogy(EbN0s, Ave_list_rank_wava2, '-+'); hold on
semilogy(EbN0s, Ave_list_rank_wava3, '-+'); hold on
grid on

legend('WAVA iter. = 1',...
    'WAVA iter. = 2',...
    'WAVA iter. = 3');
xlabel('$E_b/N_0$ (dB)','interpreter', 'latex');
ylabel('Average list rank');









