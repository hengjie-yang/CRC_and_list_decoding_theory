% This script is to generate the SNR gap to the RCU bound vs. SLVD
% complexity plot for all CRC-TBCCs with m = 10 at error probability 1e-4
% and 1e-5.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   05/18/22
%


clear;
clc;

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

path = './TCOM_sim_data/';


% m = 10 CRC-TBCC datasets
fileNames = {'041221_104348_sim_data_vs_SNR_TBCC_53_75_CRC_2033_k_64';...
    '041221_104204_sim_data_vs_SNR_TBCC_133_171_CRC_2561_k_64';...
    '041221_104533_sim_data_vs_SNR_TBCC_247_371_CRC_2727_k_64';...
    '041221_104654_sim_data_vs_SNR_TBCC_561_753_CRC_2365_k_64';...
    '031521_183642_sim_data_vs_SNR_TBCC_1131_1537_CRC_2603_k_64';...
    '051621_104531_sim_data_vs_SNR_TBCC_2473_3217_CRC_2335_k_64'};


target_UE_probs = [1e-4, 1e-5];
vs = 5:10;

c1 = 1.5;
c2 = 2.2;

m = 10;
omega = 2;
k = 64;
n = omega*(k + m);
R = k / n;

SNR_gaps = zeros(2, length(vs)); % the i-th row corresponds to the i-th target UE prob
Complexities = zeros(2, length(vs));

for iter = 1:length(target_UE_probs)
    epsilon = target_UE_probs(iter);
    for ii = 1:length(vs)
        v = vs(ii);
        opt_snr = fzero(@(x) rcu(n, R, [0.5;0.5], [-1;1], 10^(-x/10))-epsilon, [1 5]);

        fileName = fileNames{ii};
        load([path, fileName, '.mat'], 'P_UE_maxs', 'SNRs', 'Exp_list_size_maxs','Exp_insertions');

        log_probs = log10(P_UE_maxs);
        snr_val = interp1(log_probs, SNRs, log10(epsilon));
        SNR_gaps(iter, ii) = snr_val - opt_snr;
        exp_list_rank = interp1(SNRs, Exp_list_size_maxs, snr_val);
        exp_insertion = (k + m)*exp_list_rank + 2^v - 1;
        Complexities(iter, ii) = (3*k+3*m+1)*2^v + 3.5*c1*(k+m)*exp_list_rank + ...
            c2*exp_insertion*log2(exp_insertion);
    end
end




figure;
semilogx(Complexities(2, :), SNR_gaps(2, :), 'bo-', 'DisplayName','$P_{e,\lambda} = 10^{-5}$'); hold on
semilogx(Complexities(1, :), SNR_gaps(1, :), 'r*-.', 'DisplayName','$P_{e,\lambda} = 10^{-4}$'); hold on
% yline(0, 'k-', 'LineWidth', 1.0); hold on
grid on
legend('Location','northeast');
ylim([-0.1, 0.6]);
set(gca, 'box', 'off')
xlabel('Complexity $C_{\mathrm{SLVD}}$', 'interpreter', 'latex');
ylabel('Gap to the RCU bound (dB)', 'interpreter', 'latex');




















    










