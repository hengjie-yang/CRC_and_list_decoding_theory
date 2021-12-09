

% This script is to plot the RCU bound and the MC bound using saddlepoint
% approximation.

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',14,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


gamma_s = 1:0.1:7;  % the definition aligns with the journal manuscript

% % CRC-ZTCC setup
% k = 64;
% m = 3;
% v = 3;
% omega = 2;
% n = omega*(k + m + v);
% R = k / n;


% CRC-TBCC setup
% k = 64;
% m = 9;
% v = 3; % a useless variable
% omega = 2;
% n = omega*(k + m);
% R = k / n;

k = 64;
n = 128;
R = k/n;

pX = [.5; .5];
X = [-1; 1];
EbN0 = 1:0.5:3;
gamma_s = EbN0*2*R;
% gamma_s = EbN0;


% sim_CER = [0.064716864, 0.015585194, 0.001682548, 0.000138283, 0.000012555];
% EbN0 = gamma_s/(2*R); % E_b/N_0 = gamma_s/(2*R)


rcu_bounds = zeros(1, size(gamma_s, 2));
mc_bounds = zeros(1, size(gamma_s, 2));


for ii = 1:size(gamma_s, 2)
    SNR = gamma_s(ii);
    sigma2 = 10^(-SNR/10);
    rcu_bounds(ii) = rcu(n, R, pX, X, sigma2);
    mc_bounds(ii) = mc(n, R, pX, X, sigma2);
end


% path = './TCOM_sim_data/';
% timestamp = datestr(now, 'mmddyy_HHMMSS');

% fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k),'.mat'];
% save([path, fileName], 'gamma_s','rcu_bounds','mc_bounds');

%%
figure;
% semilogy(EbN0, sim_CER, '-+'); hold on
semilogy(EbN0, rcu_bounds, '-'); hold on
semilogy(EbN0, mc_bounds, '-');hold on
% xline(2.5, '--k');
grid on
ylim([10^-5, 1]);
legend('RCU bound','MC bound');
xlabel('SNR $\gamma_s$ (dB)', 'interpreter','latex');
ylabel('Probability of error');
title('K = 64, N = 128, BI-AWGN channel');


