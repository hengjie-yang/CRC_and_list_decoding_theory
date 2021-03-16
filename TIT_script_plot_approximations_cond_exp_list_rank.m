% This script is to generate the approximation plot for a given CRC-ZTCC code.
% Current approximations include
%   1) higher-order approximations: only accurate for good CC-ZTCC codes.
%   2) Genie approximation: universally accurate for any CC-CRC codes.
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
% mus = [3, 6];

% simulation data for ZTCC (13, 17), CRC (11)
path = './Simulation_results/';


load([path, '031521_111148_cond_exp_list_sizes_soft_ZTCC_561_753_CRC_2317_k_64.mat'],'etas',...
    'Ave_cond_list_sizes','P_UE_mins', 'P_UE_maxs', 'P_NACK_mins', 'P_NACK_maxs');
Ave_cond_list_sizes_CRC_2317_k_64 = Ave_cond_list_sizes;
convergence_val = mean(Ave_cond_list_sizes(end-10:end));
% convergence_val = 2^m;

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
Genie_approximations = 1 - P_UE_maxs + P_UE_maxs*convergence_val;



figure;
Max_points = 70; % maximum number: 160
semilogy(etas, Approx_cond_list_sizes(1,:),'-.', 'Color', '#0072BD'); hold on
semilogy(etas, Genie_approximations, '-.', 'Color', '#7E2F8E');
semilogy(etas, Ave_cond_list_sizes_CRC_2317_k_64, 'o','MarkerSize',6);hold on
semilogy(etas, Approx_cond_list_sizes(2,:),'-.', 'Color', '#D95319'); hold on

yline(1,'--k','LineWidth',1); hold on
yline(2^(m+1),'--k','LineWidth',1); hold on

grid on
ylim([0, 1100]);
legend('$3$rd order Approx.',...
    'Genie Approx.',...
    'Simulated',...
    '$90$th order Approx.',...
    'Location','southeast');


% legend('Simulated',...
%     'Approximation $1-\epsilon(\eta)+\epsilon(\eta)\bar{L}$');

yticks([1, 2^1,2^2,2^3,2^4, 2^5,2^6,2^7,2^8,2^9, 2^10]);
yticklabels({'$1$','$2^1$','$2^2$','$2^3$','$2^4$','$2^5$','$2^6$','$2^7$','$2^8$','$2^9$','$2^{10}$'});

xlabel('Normalized norm $\eta$','interpreter', 'latex');
ylabel('$\mathrm{E}[L|W = \eta, \mathbf{X}=\bar{\mathbf{x}}_e]$', 'interpreter', 'latex');
% title('k = 64, m = 10, ZTCC (561, 753), CRC (2317), t = 100');



%% Transform the approximations into overall E[L] vs. SNR


SNR_dBs = -4:0.1:4;

overall_exp_list_sizes = cell(4,1);

for ii = 1:size(overall_exp_list_sizes)
    overall_exp_list_sizes{ii} = zeros(1, length(SNR_dBs));
end

density_fun = @(w, dim) w.^(dim-1).*exp(-w.^2./2)./(2^(dim/2-1)*gamma(dim/2));

for jj = 1:size(overall_exp_list_sizes, 1)
    if jj == 1
        temp = Approx_cond_list_sizes(1,:);
    elseif jj == 2
        temp = Genie_approximations;
    elseif jj == 3
        temp = Ave_cond_list_sizes_CRC_2317_k_64;
    elseif jj == 4
        temp = Approx_cond_list_sizes(2,:);
    end 
    for iter = 1:length(SNR_dBs)
        snr = 10^(SNR_dBs(iter)/10);
        A  = sqrt(snr);
        Delta = A*(etas(2) - etas(1));
        for ii = 1:length(etas)
            norm_w = A*etas(ii);
            if ii == 1
                prior_prob = integral(@(w) density_fun(w, n), 0, norm_w+Delta/2);
            else
                prior_prob = integral(@(w) density_fun(w, n), norm_w - Delta/2, norm_w+Delta/2);
            end
            overall_exp_list_sizes{jj}(iter) = overall_exp_list_sizes{jj}(iter) + prior_prob*temp(ii);
        end
    end
end


figure;
semilogy(SNR_dBs, overall_exp_list_sizes{1}, '-.', 'Color', '#0072BD'); hold on
semilogy(SNR_dBs, overall_exp_list_sizes{2}, '-.', 'Color', '#7E2F8E'); hold on
semilogy(SNR_dBs, overall_exp_list_sizes{3}, 'o','MarkerSize',6); hold on
semilogy(SNR_dBs, overall_exp_list_sizes{4}, '-.', 'Color', '#D95319'); hold on
grid on

yline(1,'--k','LineWidth',1); hold on
yline(2^(m),'--k','LineWidth',1); hold on

legend('$3$rd order Approx.',...
    'Genie Approx.',...
    'Simulated',...
    '$90$th order Approx.',...
    'Location','southwest');

ylim([0, 2^10+200]);
yticks([1, 2^1,2^2,2^3,2^4, 2^5,2^6,2^7,2^8,2^9, 2^10]);
yticklabels({'$1$','$2^1$','$2^2$','$2^3$','$2^4$','$2^5$','$2^6$','$2^7$','$2^8$','$2^9$','$2^{10}$'});

xlabel('SNR $\gamma_s$ (dB)','interpreter', 'latex');
ylabel('$\mathrm{E}[L]$', 'interpreter', 'latex');
