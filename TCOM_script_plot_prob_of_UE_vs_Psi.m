% This script is to generate the plot of P_{e, \Psi} vs. \Psi 
% and P_{NACK,\Psi} vs. \Psi.
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


% Load data

path = './TCOM_sim_data/';
file_name = '030121_153630_T_13_17_CRC_103_SNR_3.00_TRIALS_100000_K_64_LIST_10000_ERRORS_1000_TBCC_0_PUNC_0.txt';
load([path, file_name, '.mat'],'pue','pnack','snr');


P_UE = pue;
P_NACK = pnack;
P_UE_and_NACK = P_UE + P_NACK;
Constrained_max_list_sizes = 1:length(P_UE);

% Plot result
figure;
Observed_max_list_size = 100;
semilogy(Constrained_max_list_sizes(1:Observed_max_list_size), P_UE_and_NACK(1:Observed_max_list_size), '-+','MarkerSize',5); hold on
semilogy(Constrained_max_list_sizes(1:Observed_max_list_size), P_NACK(1:Observed_max_list_size), '-+','MarkerSize',5); hold on
semilogy(Constrained_max_list_sizes(1:Observed_max_list_size), P_UE(1:Observed_max_list_size), '-+','MarkerSize',5); hold on
yline(P_UE(end),'--k','LineWidth',2);
% txt = '$\downarrow P_{e, \lambda}$';
% text(0.5*Observed_max_list_size, 1.5*P_UE(end),txt,'interpreter','latex','HorizontalAlignment','left');
legend('$1 - P_{c, \Psi}$',...
    '$P_{\mathit{NACK}, \Psi}$',...
    '$P_{e, \Psi}$');
grid on
xlabel('Constrained max. list size $\Psi$', 'interpreter', 'latex');
ylabel('Probability', 'interpreter', 'latex');


