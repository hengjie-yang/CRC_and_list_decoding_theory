%   This script computes the proposed upper bound on E[L] for the continuous
%   case. This script requires simulation data from the following file had it
%   not been generated earlier.
%       1) "Simulation_expected_list_size_soft_SLVD.m"
%
%   The proposed upper bounds on E[L|W = w] so far:
%       1) Improved covering-sphere upper bound: see 12-18-20 slides.
%       2) Projection based approximation: see 01-29-21 slides.
%       3) The normalized hybrid upper bound: see 02-05-21 slides.
%
%   Remarks:
%       1) 01-29-21: The bound is in fact a function of w/A, and is
%       independent of SNR (i.e., A)
%
%   Written by Hengjie Yang (hengjie.yang@ucla.edu) 12/13/20.
%

clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');




%% Input parameters

k = 64; % the information length
m = 3; % the CRC degree
v = 3; % the # memory elements
omega = 2;
n = omega*(k+m+v); % the blocklength
%%

% SNR = [-3, 10, 30]; % The 2*E_s/N_0 in dB, this will affect the scalar A
Max_norm = 400;
delta = 0.5;
etas = delta:delta:Max_norm; % the norm range of interest
% etas = 4.5;



crc_gen_poly = '17';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high



constraint_len = v+1;
code_generator = [13, 17];
trellis = poly2trellis(constraint_len, code_generator);


% Compute the improved covering-sphere upper bound for \eta = w/A
weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
weight_spectrum_low_rate = weight_node.distance_spectrum_low_rate;

hybrid_bound_cond_exp_list_size = zeros(1, size(etas,2));

new_bound_cond_exp_list_size = zeros(1, size(etas,2));
dmin = 6;

convergence = (2^m)*ones(1, size(etas, 2));


for ii = 1:size(etas, 2)
    if mod(ii, 1000) == 0
        disp(['Current progress: ',num2str(ii), ' total: ',num2str(size(etas,2))]);
    end
    eta = etas(ii);
    hybrid_bound_cond_exp_list_size(1, ii) = 1;
    new_bound_cond_exp_list_size(1, ii) = 1;
    threshold = min(floor(eta^2), n);

    for d = 0:threshold
        beta_d_w = acos(sqrt(d)/eta);
        func = @(x) (sin(x)).^(n-2);
        coeff = integral(func, 0, beta_d_w);
        coeff = coeff*gamma(n/2)/(sqrt(pi)*gamma((n-1)/2));
        hybrid_bound_cond_exp_list_size(1, ii) = hybrid_bound_cond_exp_list_size(1, ii)...
            + (weight_spectrum_high_rate(d+1) - weight_spectrum_low_rate(d+1))*coeff;
        new_bound_cond_exp_list_size(1, ii) = new_bound_cond_exp_list_size(1, ii)...
            + (weight_spectrum_high_rate(d+1) - weight_spectrum_low_rate(d+1))*coeff;
    end       

    if eta >= sqrt(n)   % added the projection based approximation
        temp = (1+sqrt(n)/eta)^(n-1)*2^m;
        hybrid_bound_cond_exp_list_size(1, ii) = min(hybrid_bound_cond_exp_list_size(1, ii), temp);
        a1 = sqrt(4*dmin^2-4*d+eta^2)+sqrt(n)-2*dmin/sqrt(n);
        a2 = (a1/eta)^(n-2);
        a3 = 1+(sqrt(n)-2*d/sqrt(n))/sqrt(4*d^2/n-4*d+eta^2);
        temp = a2*a3*(2^m);
        new_bound_cond_exp_list_size(1, ii) = min(new_bound_cond_exp_list_size(1, ii), temp);
    end
end




% plot the conditional upper bound
figure;
plot(etas, hybrid_bound_cond_exp_list_size(1,:), '-'); hold on
plot(etas, new_bound_cond_exp_list_size(1,:), '-'); hold on
plot(etas, convergence(1,:), '-.');
grid on
legend('Hybrid upper bound','New bound', 'Convergence');
xlabel('Normalized factor $\eta$','interpreter', 'latex');
ylabel('List rank', 'interpreter', 'latex');
title('k = 4, m = 3, \rho = 9, CRC:(17), ZTCC (13, 17)');




%% Plot the simulated E[L|W = w] for k = 64, ZTCC (13, 17), CRC (17)

path = './Simulation_results/';
load([path, '020321_113451_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_17_k_64.mat'],'etas','Ave_cond_list_sizes');

Ave_cond_list_sizes_CRC_17_k_64 = Ave_cond_list_sizes;

load([path, '020621_090538_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_64.mat'],'etas','Ave_cond_list_sizes');

Ave_cond_list_sizes_CRC_11_k_64 = Ave_cond_list_sizes;



% Compute the critical values of normalized factor \eta

eta_middle = sqrt(n);

min_gap = 1;
target_prob = 1/2^(k+m);
opt_theta = -1;

delta = 0.01;
thetas = 0:delta:pi/2;

for s = 1:size(thetas, 2)  % compute \eta_low
    theta = thetas(s);
    val = integral(@(x) sin(x).^(n-2), 0, theta);
    ratio = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
    cur_gap = abs(ratio - target_prob);
    if cur_gap < min_gap
        min_gap = cur_gap;
        opt_theta = theta;
    end
end

eta_low = sqrt(n)*sin(opt_theta);
eta_high = sqrt(n)*2 - eta_low;


% Compute the approximation curve
convergence_val = 2^m;
alpha = opt_theta;
Approx_cond_list_sizes = zeros(size(etas));

for s = 1: size(etas, 2)
    eta = etas(s);
    if eta < sqrt(n)*sin(alpha)
        Approx_cond_list_sizes(s) = 1;
    elseif eta >= sqrt(n)*sin(alpha) && eta < sqrt(n)
        beta_1 = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
        beta_2 = beta_1 - 2*alpha;
        val = integral(@(x) sin(x).^(n-2), 0, beta_1);
        prob_1 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
        val = integral(@(x) sin(x).^(n-2), 0, beta_2);
        prob_2 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
        Approx_cond_list_sizes(s) = convergence_val - (convergence_val - 1)*(prob_1 + prob_2);
    else
        beta = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
        val = integral(@(x) sin(x).^(n-2), 0, beta);
        prob = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
        Approx_cond_list_sizes(s) = convergence_val - (convergence_val - 1)*prob;
    end
end


figure;
plot(etas, Ave_cond_list_sizes_CRC_17_k_64,'-+'); hold on
plot(etas, Ave_cond_list_sizes_CRC_11_k_64,'-+'); hold on
plot(etas, Approx_cond_list_sizes, '-.'); hold on
% xline(eta_low,'--r');
% txt = '$\leftarrow \eta_l$';
% text(eta_low,1.5,txt,'interpreter','latex','HorizontalAlignment','left');
% xline(eta_middle,'--r');
% txt = '$\leftarrow \eta_m$';
% text(eta_middle,(1+2^m)/2,txt,'interpreter','latex','HorizontalAlignment','left');
% xline(eta_high,'--r');
% txt = '$\leftarrow \eta_h$';
% text(eta_high,2^m-1,txt,'interpreter','latex','HorizontalAlignment','left');
grid on
legend('CRC: (17)',...
    'CRC: (11)',...
    'Approximation',...
    'Location','southeast');
xlabel('Normalized factor $\eta$','interpreter', 'latex');
ylabel('Average list rank', 'interpreter', 'latex');
title('k = 64, m = 3, ZTCC (13, 17)');






%% E[L|W = \eta] vs. eta, critical values and first-order approximation for different values of k, 


path = './Simulation_results/';

load([path, '020621_090538_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_64.mat'],'etas','Ave_cond_list_sizes');
Ave_cond_list_sizes_CRC_11_k_64 = Ave_cond_list_sizes;


load([path, '020721_034345_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_32.mat'],'etas','Ave_cond_list_sizes');
Ave_cond_list_sizes_CRC_11_k_32 = Ave_cond_list_sizes;


load([path, '020721_190558_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_16.mat'],'etas','Ave_cond_list_sizes');
Ave_cond_list_sizes_CRC_11_k_16 = Ave_cond_list_sizes;


load([path, '021121_152838_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_128.mat'],'etas','Ave_cond_list_sizes');
Ave_cond_list_sizes_CRC_11_k_128 = Ave_cond_list_sizes;


% Compute the critical values of normalized factor \eta
% 
% k = 16; % the information length
% m = 3; % the CRC degree
% v = 3; % the # memory elements
% omega = 2;
% n = omega*(k+m+v); % the blocklength
% 
% eta_middle = sqrt(n);
% 
% min_gap = 1;
% target_prob = 1/2^(k+m);
% opt_theta = -1;
% 
% delta = 0.01;
% thetas = 0:delta:pi/2;
% 
% for iter = 1:size(thetas, 2)  % compute \eta_low
%     theta = thetas(iter);
%     val = integral(@(x) sin(x).^(n-2), 0, theta);
%     ratio = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
%     cur_gap = abs(ratio - target_prob);
%     if cur_gap < min_gap
%         min_gap = cur_gap;
%         opt_theta = theta;
%     end
% end
% 
% eta_low = sqrt(n)*sin(opt_theta);




% Compute the critical values and the approximation curve
ks = [128; 64; 32; 16];
ms = [3; 3; 3; 3];
vs = [3; 3; 3; 3];
convergence_vals = [7.7; 7.5; 7.3; 7];
omega = 2;
Approx_cond_list_sizes = zeros(length(ks), length(etas));
eta_lows = zeros(length(ks), 1);
eta_middles = zeros(length(ks), 1);
eta_highs = zeros(length(ks), 1);


delta = 0.01;
thetas = 0:delta:pi/2;


for ii = 1:size(ks, 1)
    n = omega*(ks(ii)+ms(ii)+vs(ii));
    target_value = convergence_vals(ii) - 1;
    min_gap = 100;
    alpha = -1;
    target_prob = 1/2^(ks(ii)+ms(ii));
    
    
    % Compute alpha 
    constant = gamma(n/2)/sqrt(pi)/gamma((n-1)/2);
    int_fun = @(x) constant*integral(@(t) sin(t).^(n-2), 0, x) - target_prob;
    alpha = fzero(int_fun, [0, pi/2]);
%     for s = 1:size(thetas, 2)  % compute \eta_low
%         theta = thetas(s);
%         val = integral(@(x) sin(x).^(n-2), 0, theta);
%         ratio = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
%         cur_gap = abs(ratio - target_prob);
%         if cur_gap < min_gap
%             min_gap = cur_gap;
%             alpha = theta;
%         end
%     end
    eta_lows(ii) = sqrt(n)*sin(alpha);
    min_gap = 100;  % reset min_gap to compute \eta_high
    
    for s = 1: size(etas, 2)
        eta = etas(s);
        if eta < sqrt(n)*sin(alpha)
            Approx_cond_list_sizes(ii, s) = 1;
        elseif eta >= sqrt(n)*sin(alpha) && eta < sqrt(n)
            beta_1 = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
            beta_2 = beta_1 - 2*alpha;
            val = integral(@(x) sin(x).^(n-2), 0, beta_1);
            prob_1 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
            val = integral(@(x) sin(x).^(n-2), 0, beta_2);
            prob_2 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
            Approx_cond_list_sizes(ii, s) = convergence_vals(ii) - (convergence_vals(ii) - 1)*(prob_1 + prob_2);
        else
            beta = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
            val = integral(@(x) sin(x).^(n-2), 0, beta);
            prob = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
            Approx_cond_list_sizes(ii, s) = convergence_vals(ii) - (convergence_vals(ii) - 1)*prob;
        end
        
        cur_gap = abs(Approx_cond_list_sizes(ii, s) - target_value);
        if cur_gap < min_gap
            min_gap = cur_gap;
            eta_highs(ii) = eta;
        end
    end
    eta_middles(ii) = (eta_lows(ii) + eta_highs(ii))/2;
end


figure;
Max_points = 80; % maximum number: 160
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_128(1:Max_points),'-+', 'Color', '#77AC30'); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes(1, 1:Max_points),'-.', 'Color', '#77AC30'); hold on
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_64(1:Max_points),'-+', 'Color', '#0072BD'); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes(2, 1:Max_points),'-.', 'Color', '#0072BD'); hold on
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_32(1:Max_points),'-+', 'Color', '#D95319'); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes(3, 1:Max_points),'-.', 'Color', '#D95319'); hold on
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_16(1:Max_points),'-+', 'Color', '#EDB120'); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes(4, 1:Max_points),'-.', 'Color', '#EDB120'); hold on
% plot(etas, Approx_cond_list_sizes, '-.'); hold on
% xline(eta_low,'--r');
% txt = '$\leftarrow \eta_l$';
% text(eta_low,1.5,txt,'interpreter','latex','HorizontalAlignment','left');
% xline(eta_middle,'--r');
% txt = '$\leftarrow \eta_m$';
% text(eta_middle,(1+2^m)/2,txt,'interpreter','latex','HorizontalAlignment','left');
% xline(eta_high,'--r');
% txt = '$\leftarrow \eta_h$';
% text(eta_high,2^m-1,txt,'interpreter','latex','HorizontalAlignment','left');
grid on
legend('$k = 128$, Simulated',...
    '$k = 128$, 1st-order Approx.',...
    '$k = 64$, Simulated',...
    '$k = 64$, 1st-order Approx.',...
    '$k = 32$, Simulated',...
    '$k = 32$, 1st-order Approx.',...
    '$k = 16$, Simulated',...
    '$k = 16$, 1st-order Approx.',...
    'Location','southeast');
xlabel('Normalized factor $\eta$','interpreter', 'latex');
ylabel('Average list rank', 'interpreter', 'latex');
title('m = 3, ZTCC (13, 17), CRC (11)');



%% Compute the overall E[L] for k = 64, ZTCC (13, 17), CRC (17)
% size vs. normalized factor \eta.

path = './Simulation_results/';
load([path, '020421_113711_exp_list_sizes_soft_ZTCC_13_17_CRC_17_k_64.mat'],'snr_dBs','Ave_list_sizes');


SNR_dBs = -3:0.5:8;
overall_exp_list_size = zeros(1, length(SNR_dBs));
approx_overall_exp_list_size = zeros(1, length(SNR_dBs));


k = 64;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);

density_fun = @(w, dim) w.^(dim-1).*exp(-w.^2./2)./(2^(dim/2-1)*gamma(dim/2));

% figure;
% ws = 0:0.01:50;
% plot(ws, density_fun(ws, n)); hold on
% xline(sqrt(n-1),'--r');
% txt = '$\leftarrow w^*=\sqrt{n-1}$';
% text(sqrt(n-1),0.35,txt,'interpreter','latex','HorizontalAlignment','left');
% grid on
% xlabel('$w$','interpreter','latex');
% ylabel('$f(w)$','interpreter','latex');


Ave_cond_list_sizes = Ave_cond_list_sizes_CRC_11_k_64;

for s = 1:size(SNR_dBs,2)
    snr = 10^(SNR_dBs(s)/10);
    A = sqrt(snr);
    Delta = A*(etas(2) - etas(1)); % the gap between two consecutive discrete norms
    for ii = 1:size(etas, 2)
        norm_w = A*etas(ii);
        prior_prob = integral(@(w) density_fun(w, n), norm_w-Delta/2, norm_w+Delta/2);
        overall_exp_list_size(s) = overall_exp_list_size(s) + prior_prob*Ave_cond_list_sizes(ii);
%         overall_exp_list_size(iter) = overall_exp_list_size(iter) + prior_prob*1;
        approx_overall_exp_list_size(s) = approx_overall_exp_list_size(s) + prior_prob*Approx_cond_list_sizes(1, ii);
    end
end



% Compute E[L] using dominant value of E[L|W = \eta^*].
As = 10.^(SNR_dBs./10);
opt_etas = sqrt(n-1)./As;

Dominant_exp_list_sizes = interp1(etas, Ave_cond_list_sizes', opt_etas);

% Delta = etas(2) - etas(1); 
% for iter = 1:size(SNR_dBs, 2)
%     A = As(iter);
%     opt_eta = opt_etas(iter);
%     prob = integral(@(w) density_fun(w, n), A*(opt_eta - Delta/2), A*(opt_eta + Delta/2));
%     Dominant_exp_list_sizes(iter) = Dominant_exp_list_sizes(iter)*prob;
% end




figure;
plot(snr_dBs, Ave_list_sizes', '-+'); hold on
plot(SNR_dBs, overall_exp_list_size, '-o'); hold on
% plot(SNR_dBs, approx_overall_exp_list_size, '-.'); hold on
% plot(SNR_dBs, Dominant_exp_list_sizes', '-+'); hold on


grid on
legend('Corollary from sim. $\mathrm{E}[L|W = w]$',...
    'Corollary from approx. $\mathrm{E}[L|W = w]$');
xlabel('$\gamma_s$ (dB)','interpreter', 'latex');
ylabel('Average list rank', 'interpreter', 'latex');
title('k = 64, m = 3, CRC:(11), ZTCC (13, 17)');



%% First-order pproximation for k = 64, ZTCC (561, 753), degree-10 CRC (2317)


% Compute the critical values and the approximation curve
ks = [64];
ms = [10];
vs = [8];
convergence_vals = [1020];
omega = 2;
% etas = 0.5:0.5:80;

% simulation data for ZTCC (561, 751), CRC (2317)
% discrete_etas = [11.5, 12.5, 14, 17, 80];
% Ave_cond_list_sizes_CRC_1317_k_64 = [1.869, 15.176, 138.81, 456.746, 536.853];
path = './Simulation_results/';
load([path, '030321_120230_cond_exp_list_sizes_soft_ZTCC_561_753_CRC_2317_k_64.mat'],'etas','Cond_exp_list_sizes');
Ave_cond_list_sizes_CRC_2317_k_64 = Cond_exp_list_sizes;


Approx_cond_list_sizes = zeros(length(ks), length(etas));
eta_lows = zeros(length(ks), 1);
eta_middles = zeros(length(ks), 1);
eta_highs = zeros(length(ks), 1);


delta = 0.005;
thetas = 0:delta:pi/2;

dfree = 6;




for ii = 1:size(ks, 1)
    n = omega*(ks(ii)+ms(ii)+vs(ii));
    target_value = convergence_vals(ii) - 1;
    min_gap = 100;
    alpha = -1;
    target_prob = 1/2^(ks(ii)+ms(ii));
    
    
    % Compute alpha 
    constant = gamma(n/2)/sqrt(pi)/gamma((n-1)/2);
    int_fun = @(x) constant*integral(@(t) sin(t).^(n-2), 0, x) - target_prob;
    alpha = fzero(int_fun, [0, pi/2]);
%     for s = 1:size(thetas, 2)  % compute \eta_low
%         theta = thetas(s);
%         val = integral(@(x) sin(x).^(n-2), 0, theta);
%         ratio = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
%         cur_gap = abs(ratio - target_prob);
%         if cur_gap < min_gap
%             min_gap = cur_gap;
%             alpha = theta;
%         end
%     end
    eta_lows(ii) = sqrt(n)*sin(alpha);

%     eta_lows(ii) = sqrt(dfree);
%     alpha = asin(eta_lows(ii)/sqrt(n));
    min_gap_v2 = 100;  % reset min_gap to compute \eta_high
    
    for s = 1: size(etas, 2)
        eta = etas(s);
        if eta < sqrt(n)*sin(alpha)
            Approx_cond_list_sizes(ii, s) = 1;
        elseif eta >= sqrt(n)*sin(alpha) && eta < sqrt(n)
            beta_1 = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
            beta_2 = beta_1 - 2*alpha;
            val = integral(@(x) sin(x).^(n-2), 0, beta_1);
            prob_1 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
            val = integral(@(x) sin(x).^(n-2), 0, beta_2);
            prob_2 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
            Approx_cond_list_sizes(ii, s) = convergence_vals(ii) - (convergence_vals(ii) - 1)*(prob_1 + prob_2);
        else
            beta = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
            val = integral(@(x) sin(x).^(n-2), 0, beta);
            prob = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
            Approx_cond_list_sizes(ii, s) = convergence_vals(ii) - (convergence_vals(ii) - 1)*prob;
        end
        
        cur_gap = abs(Approx_cond_list_sizes(ii, s) - target_value);
        if cur_gap < min_gap_v2
            min_gap_v2 = cur_gap;
            eta_highs(ii) = eta;
        end
    end
    eta_middles(ii) = (eta_lows(ii) + eta_highs(ii))/2;
end


figure;
Max_points = 29; % maximum number: 160
plot(etas, Approx_cond_list_sizes,'-.', 'Color', '#0072BD'); hold on
plot(etas, Ave_cond_list_sizes_CRC_2317_k_64, '-+');
% plot(etas, Approx_cond_list_sizes, '-.'); hold on
% xline(eta_low,'--r');
% txt = '$\leftarrow \eta_l$';
% text(eta_low,1.5,txt,'interpreter','latex','HorizontalAlignment','left');
% xline(eta_middle,'--r');
% txt = '$\leftarrow \eta_m$';
% text(eta_middle,(1+2^m)/2,txt,'interpreter','latex','HorizontalAlignment','left');
% xline(eta_high,'--r');
% txt = '$\leftarrow \eta_h$';
% text(eta_high,2^m-1,txt,'interpreter','latex','HorizontalAlignment','left');
grid on
legend('1st-order Approx.',...
    'Simulated',...
    'Location','southeast');
xlabel('Normalized factor $\eta$','interpreter', 'latex');
ylabel('Average list rank', 'interpreter', 'latex');
title('k = 64, m = 10, ZTCC (561, 753), CRC (2317)');



%% Higher-order approximation of E[L|W = \eta]


k = 64;
m = 10;
v = 8;
omega = 2;
n = omega*(k+m+v);

t = 100;
alphas = zeros(1, t);
convergence_val = 1020;

% simulation data for ZTCC (13, 17), CRC (11)
path = './Simulation_results/';


% load([path, '021121_152838_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_128.mat'],'etas','Ave_cond_list_sizes');
% Ave_cond_list_sizes_CRC_11_k_128 = Ave_cond_list_sizes;
% 
% load([path, '020621_090538_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_64.mat'],'etas','Ave_cond_list_sizes');
% Ave_cond_list_sizes_CRC_11_k_64 = Ave_cond_list_sizes;
% 
% load([path, '020721_034345_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_32.mat'],'etas','Ave_cond_list_sizes');
% Ave_cond_list_sizes_CRC_11_k_32 = Ave_cond_list_sizes;
% 
% load([path, '020721_190558_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_16.mat'],'etas','Ave_cond_list_sizes');
% Ave_cond_list_sizes_CRC_11_k_16 = Ave_cond_list_sizes;

load([path, '030321_120230_cond_exp_list_sizes_soft_ZTCC_561_753_CRC_2317_k_64.mat'],'etas','Cond_exp_list_sizes');
Ave_cond_list_sizes_CRC_2317_k_64 = Cond_exp_list_sizes;


% simulation data for ZTCC (561, 751), CRC (1317)
% discrete_etas = [11.5, 12.5, 14, 17, 80];
% Ave_cond_list_sizes_CRC_1317_k_64 = [1.869, 15.176, 138.81, 456.746, 536.853];


% Pre-compute all half angles \alpha
constant = gamma(n/2)/sqrt(pi)/gamma((n-1)/2);

for s = 1:t
    target_prob = s/2^(k+m);
    int_fun = @(x) constant*integral(@(t) sin(t).^(n-2), 0, x) - target_prob;
    alphas(s) = fzero(int_fun, [0, pi/2]);
end
thresholds = sqrt(n)*sin(alphas);
thresholds = [thresholds, sqrt(n), Inf];




% Compute the higher-order approximation
Approx_cond_list_sizes = zeros(1, length(etas));

for iter = 1:length(etas)
    eta = etas(iter);
    
    idx = find(thresholds > eta);
    idx = idx(1);
    
    if idx == 1
        Approx_cond_list_sizes(iter) = 1;
    elseif idx > 1 && idx <= t
        Approx_cond_list_sizes(iter) = s;
        for s = 1:idx-1
            beta1 = pi/2 + alphas(s) - asin(sqrt(eta^2 - n*sin(alphas(s))^2)/eta);
            beta2 = pi/2 - alphas(s) - asin(sqrt(eta^2 - n*sin(alphas(s))^2)/eta);
            int_val1 = integral(@(t) sin(t).^(n-2), 0, beta1);
            int_val2 = integral(@(t) sin(t).^(n-2), 0, beta2);
            F_s = constant*(int_val1 + int_val2);
            Approx_cond_list_sizes(iter) = Approx_cond_list_sizes(iter) - F_s;
        end
    elseif idx == t + 1
        Approx_cond_list_sizes(iter) = convergence_val;
        for s = 1:t
            beta1 = pi/2 + alphas(s) - asin(sqrt(eta^2 - n*sin(alphas(s))^2)/eta);
            beta2 = pi/2 - alphas(s) - asin(sqrt(eta^2 - n*sin(alphas(s))^2)/eta);
            int_val1 = integral(@(t) sin(t).^(n-2), 0, beta1);
            int_val2 = integral(@(t) sin(t).^(n-2), 0, beta2);
            F_s = constant*(int_val1 + int_val2);
            if s < t
                Approx_cond_list_sizes(iter) = Approx_cond_list_sizes(iter) - F_s;
            else
                Approx_cond_list_sizes(iter) = Approx_cond_list_sizes(iter) - (convergence_val - t)*F_s;
            end
        end
    else
        Approx_cond_list_sizes(iter) = convergence_val;
        for s = 1:t
            beta1 = pi/2 + alphas(s) - asin(sqrt(eta^2 - n*sin(alphas(s))^2)/eta);
            int_val1 = integral(@(t) sin(t).^(n-2), 0, beta1);
            F_s = constant*int_val1;
            if s < t
                Approx_cond_list_sizes(iter) = Approx_cond_list_sizes(iter) - F_s;
            else
                Approx_cond_list_sizes(iter) = Approx_cond_list_sizes(iter) - (convergence_val - t)*F_s;
            end
        end
    end
end


% figure;
% Max_points = 70; % maximum number: 160
plot(etas, Approx_cond_list_sizes,'-.', 'Color', '#0072BD'); hold on
% plot(etas, Ave_cond_list_sizes_CRC_2317_k_64, 'o');
% plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_64(1:Max_points),'-+', 'Color', '#0072BD'); hold on
% plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_32(1:Max_points),'-+', 'Color', '#D95319'); hold on
% plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_16(1:Max_points),'-+', 'Color', '#EDB120'); hold on
grid on
legend('$t$-th order Approx.',...
    'Simulated',...
    'Location','southeast');
xlabel('Normalized factor $\eta$','interpreter', 'latex');
ylabel('Average list rank', 'interpreter', 'latex');
title('k = 64, m = 10, ZTCC (561, 753), CRC (2317), t = 100');

        
    
    
    



