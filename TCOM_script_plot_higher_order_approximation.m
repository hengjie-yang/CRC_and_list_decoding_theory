% This script is to generate the higher-order approximation plot for good
% enough CRC-ZTCC codes.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/10/21.
%



clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


k = 64;
m = 10;
v = 8;
omega = 2;
n = omega*(k+m+v);

mus = [3, 80];
convergence_val = 1020;

% simulation data for ZTCC (13, 17), CRC (11)
path = './Simulation_results/';


load([path, '030321_120230_cond_exp_list_sizes_soft_ZTCC_561_753_CRC_2317_k_64.mat'],'etas','Cond_exp_list_sizes');
Ave_cond_list_sizes_CRC_2317_k_64 = Cond_exp_list_sizes;


% simulation data for ZTCC (561, 751), CRC (1317)
% discrete_etas = [11.5, 12.5, 14, 17, 80];
% Ave_cond_list_sizes_CRC_1317_k_64 = [1.869, 15.176, 138.81, 456.746, 536.853];


% Pre-compute all half angles \alpha
constant = gamma(n/2)/sqrt(pi)/gamma((n-1)/2);
alphas = cell(length(mus), 1);
thresholds = cell(length(mus), 1);

for iter = 1:length(mus)
    mu = mus(iter);
    alphas{iter} = zeros(mu, 1);
    thresholds{iter} = zeros(mu, 1);
    thresholds{iter} = [thresholds{iter}; sqrt(n); Inf];
    for s = 1:mu
        target_prob = s/2^(k+m);
        int_fun = @(x) constant*integral(@(t) sin(t).^(n-2), 0, x) - target_prob;
        alphas{iter}(s) = fzero(int_fun, [0, pi/2]);
        thresholds{iter}(s) = sqrt(n)*sin(alphas{iter}(s));
    end  
end


% thresholds = sqrt(n)*sin(alphas);
% thresholds = [thresholds, sqrt(n), Inf];




% Compute the higher-order approximation
Approx_cond_list_sizes = zeros(length(mus), length(etas));

for ii = 1:length(mus)
    mu = mus(ii);
    for iter = 1:length(etas)
        eta = etas(iter);

        idx = find(thresholds{ii} > eta);
        idx = idx(1);

        if idx == 1
            Approx_cond_list_sizes(ii, iter) = 1;
        elseif idx > 1 && idx <= mu
            Approx_cond_list_sizes(ii, iter) = s;
            for s = 1:idx-1
                beta1 = pi/2 + alphas{ii}(s) - asin(sqrt(eta^2 - n*sin(alphas{ii}(s))^2)/eta);
                beta2 = pi/2 - alphas{ii}(s) - asin(sqrt(eta^2 - n*sin(alphas{ii}(s))^2)/eta);
                int_val1 = integral(@(t) sin(t).^(n-2), 0, beta1);
                int_val2 = integral(@(t) sin(t).^(n-2), 0, beta2);
                F_s = constant*(int_val1 + int_val2);
                Approx_cond_list_sizes(ii, iter) = Approx_cond_list_sizes(ii, iter) - F_s;
            end
        elseif idx == mu + 1
            Approx_cond_list_sizes(ii, iter) = convergence_val;
            for s = 1:mu
                beta1 = pi/2 + alphas{ii}(s) - asin(sqrt(eta^2 - n*sin(alphas{ii}(s))^2)/eta);
                beta2 = pi/2 - alphas{ii}(s) - asin(sqrt(eta^2 - n*sin(alphas{ii}(s))^2)/eta);
                int_val1 = integral(@(t) sin(t).^(n-2), 0, beta1);
                int_val2 = integral(@(t) sin(t).^(n-2), 0, beta2);
                F_s = constant*(int_val1 + int_val2);
                if s < mu
                    Approx_cond_list_sizes(ii, iter) = Approx_cond_list_sizes(ii, iter) - F_s;
                else
                    Approx_cond_list_sizes(ii, iter) = Approx_cond_list_sizes(ii, iter) - (convergence_val - mu)*F_s;
                end
            end
        else
            Approx_cond_list_sizes(ii, iter) = convergence_val;
            for s = 1:mu
                beta1 = pi/2 + alphas{ii}(s) - asin(sqrt(eta^2 - n*sin(alphas{ii}(s))^2)/eta);
                int_val1 = integral(@(t) sin(t).^(n-2), 0, beta1);
                F_s = constant*int_val1;
                if s < mu
                    Approx_cond_list_sizes(ii, iter) = Approx_cond_list_sizes(ii, iter) - F_s;
                else
                    Approx_cond_list_sizes(ii, iter) = Approx_cond_list_sizes(ii, iter) - (convergence_val - mu)*F_s;
                end
            end
        end
    end
end


% figure;
% Max_points = 70; % maximum number: 160
semilogy(etas, Approx_cond_list_sizes(1,:),'-.', 'Color', '#0072BD'); hold on
semilogy(etas, Approx_cond_list_sizes(2,:),'-.', 'Color', '#D95319'); hold on
semilogy(etas, Ave_cond_list_sizes_CRC_2317_k_64, 'o','MarkerSize',6);

yline(1,'--k','LineWidth',1); hold on
yline(2^10,'--k','LineWidth',1); hold on

grid on
ylim([0, 1100]);
legend('$3$rd order Approx.',...
    '$90$th order Approx.',...
    'Simulated',...
    'Location','southeast');

yticks([1, 2^1,2^2,2^3,2^4, 2^5,2^6,2^7,2^8,2^9, 2^10]);
yticklabels({'$1$','$2^1$','$2^2$','$2^3$','$2^4$','$2^5$','$2^6$','$2^7$','$2^8$','$2^9$','$2^{10}$'});

xlabel('Normalized norm $\eta$','interpreter', 'latex');
ylabel('$\mathrm{E}[L|W = \eta, \mathbf{X}=\bar{\mathbf{x}}_e]$', 'interpreter', 'latex');
% title('k = 64, m = 10, ZTCC (561, 753), CRC (2317), t = 100');

