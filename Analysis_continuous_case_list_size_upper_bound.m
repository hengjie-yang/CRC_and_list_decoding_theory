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


% Input parameters

k = 4; % the information length
m = 3; % the CRC degree
v = 3; % the # memory elements
omega = 2;
n = omega*(k+m+v); % the blocklength

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




%% Plot the simulated E[L|W = w]

path = './Simulation_results/';
load([path, '020321_113451_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_17_k_64.mat'],'etas','Ave_cond_list_sizes');



figure;
plot(etas, Ave_cond_list_sizes,'-+'); hold on
grid on
xlabel('Normalized factor $\eta$','interpreter', 'latex');
ylabel('Average list rank', 'interpreter', 'latex');
title('k = 64, m = 3, CRC:(17), ZTCC (13, 17)');



% Compute the overall E[L] from the simulated conditional expected list
% size vs. normalized factor \eta.

SNR_dBs = -5:0.2:5;
overall_exp_list_size = zeros(size(SNR_dBs));



k = 64;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);

density_fun = @(w, dim) w.^(dim-1).*exp(-w.^2./2)./(2^(dim/2-1)*gamma(dim/2));

% figure;
% ws = 0:0.01:50;
% plot(ws, density_fun(ws, n));
% grid on


for iter = 1:size(SNR_dBs,2)
    snr = 10^(SNR_dBs(iter)/10);
    A = sqrt(snr);
    Delta = A*(etas(2) - etas(1)); % the gap between two consecutive discrete norms
    for ii = 1:size(etas, 2)
        norm_w = A*etas(ii);
        prior_prob = integral(@(w) density_fun(w, n), norm_w-Delta/2, norm_w+Delta/2);
        overall_exp_list_size(iter) = overall_exp_list_size(iter) + prior_prob*Ave_cond_list_sizes(ii);
%         overall_exp_list_size(iter) = overall_exp_list_size(iter) + prior_prob*1;
    end
end


figure;
plot(SNR_dBs, overall_exp_list_size, '-+');
grid on
xlabel('$\gamma_s$ (dB)','interpreter', 'latex');
ylabel('Average list rank', 'interpreter', 'latex');
title('k = 64, m = 3, CRC:(17), ZTCC (13, 17)');


