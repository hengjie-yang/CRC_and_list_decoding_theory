

% This script is to plot the RCU bound and the MC bound using saddlepoint
% approximation.

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',14,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


EbN0 = 1:0.1:5;
R = 0.5;
n = 128;
pX = [.5; .5];
X = [-1; 1];


rcu_bounds = zeros(1, size(EbN0, 2));
mc_bounds = zeros(1, size(EbN0, 2));


for ii = 1:size(EbN0, 2)
    SNR = EbN0(ii);
    sigma2 = 10^(-SNR/10);
    rcu_bounds(ii) = rcu(n, R, pX, X, sigma2);
    mc_bounds(ii) = mc(n, R, pX, X, sigma2);
end


figure;
semilogy(EbN0, rcu_bounds, '-'); hold on
semilogy(EbN0, mc_bounds, '-');
grid on
ylim([10^-8, 1]);
legend('RCU bound','MC bound');
xlabel('$E_b/N_0$ dB', 'interpreter','latex');
ylabel('Error probability');


