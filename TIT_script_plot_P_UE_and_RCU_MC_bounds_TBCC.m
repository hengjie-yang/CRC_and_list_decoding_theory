% This script is to generate the plot of P_UE vs RCU bound and MC bound
% for CRC-TBCC codes with v = 9 (m=3, 10) and v = 10 (m=3, 10) at k = 64
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/16/21
%

clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


fileNames = cell(2, 1);
P_UEs = cell(4, 1);
SNR_vecs = cell(4, 1);

RCU_bounds = cell(2, 1);
MC_bounds = cell(2, 1);
gammas = cell(2, 1);
vs = [9, 10];
ms = [3, 9];

k = 64;

path = './TCOM_sim_data/';

% v = 9
fileNames{1} = {'031521_181959_sim_data_vs_SNR_TBCC_1131_1537_CRC_15_k_64';...
    '031521_183224_sim_data_vs_SNR_TBCC_1131_1537_CRC_1511_k_64'};

% v = 10
fileNames{2} = {'031521_182013_sim_data_vs_SNR_TBCC_2473_3217_CRC_17_k_64';...
    '031521_183259_sim_data_vs_SNR_TBCC_2473_3217_CRC_1027_k_64'};

cnt = 1;
for iter = 1:length(vs)
    v = vs(iter);
    for ii = 1:size(fileNames{iter}, 1)
        fileName = fileNames{iter}{ii};
        load([path, fileName, '.mat'], 'SNRs', 'P_UE_maxs');
        P_UEs{cnt} = P_UE_maxs;
        SNR_vecs{cnt} = SNRs;
        cnt = cnt + 1;
    end
end



for iter = 1:length(ms)
    m = ms(iter);
    n = 2*(k+m);
    fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
    load([path, fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');
    gammas{iter} = gamma_s;
    RCU_bounds{iter} = rcu_bounds;
    MC_bounds{iter} = mc_bounds;
end


figure;

semilogy(SNR_vecs{1}, P_UEs{1}, '-x','Color','#77AC30'); hold on
semilogy(SNR_vecs{3}, P_UEs{3}, '-s','Color','#77AC30'); hold on
semilogy(gammas{1}, RCU_bounds{1}, '-.k', 'HandleVisibility','off'); hold on
semilogy(gammas{1}, MC_bounds{1}, '-','Color','#A2142F', 'HandleVisibility','off'); hold on

semilogy(SNR_vecs{2}, P_UEs{2}, '-d','Color','#EDB120'); hold on
semilogy(SNR_vecs{4}, P_UEs{4}, '-v','Color','#EDB120'); hold on
semilogy(gammas{2}, RCU_bounds{2}, '-.k'); hold on
semilogy(gammas{2}, MC_bounds{2}, '-','Color','#A2142F'); hold on

grid on
legend('$(m=3, \nu=9)$ CRC-TBCC',...
    '$(m=3, \nu=10)$ CRC-TBCC',...
    '$(m=9, \nu=9)$ CRC-TBCC',...
    '$(m=9, \nu=10)$ CRC-TBCC',...
    'RCU bound',...
    'MC bound');

ylim([10^(-6), 1]);
xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of UE $P_{e,\lambda}$', 'interpreter', 'latex');











