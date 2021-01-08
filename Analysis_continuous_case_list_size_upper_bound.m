%   This script computes the proposed upper bound on E[L] for the continuous
%   case. This script requires simulation data from the following file had it
%   not been generated earlier.
%       1) "Simulation_expected_list_size_soft_SLVD.m"
%
%   The proposed upper bounds so far:
%       1) Improved covering-sphere upper bound: see 12-18-20 slides.
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

SNR = [-3, 10, 30]; % The 2*E_s/N_0 in dB, this will affect the scalar A
Max_norm = 400;
delta = 0.05;
norms = 0:delta:Max_norm; % the norm range of interest



crc_gen_poly = '17';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high



constraint_len = v+1;
code_generator = [13, 17];
trellis = poly2trellis(constraint_len, code_generator);


% Compute the improved covering-sphere upper bound
weight_node = Compute_relative_distance_spectrum_brute_force(constraint_len, code_generator, k+m, poly, zeros(1,n));
weight_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
weight_spectrum_low_rate = weight_node.distance_spectrum_low_rate;

improved_covering_sphere_bound_cond_exp_list_size = zeros(size(SNR, 2), size(norms,2));

for idx = 1:size(SNR, 2)
    snr = 10^(SNR(idx)/10);
    A = sqrt(snr);
    for ii = 1:size(norms, 2)
        if mod(ii, 1000) == 0
            disp(['Current progress: ',num2str(ii), ' total: ',num2str(size(norms,2))]);
        end
        w = norms(ii);
        improved_covering_sphere_bound_cond_exp_list_size(idx, ii) = 1;
        threshold = min(floor(w^2/A), n);
        if w > 0
            for d = 0:threshold
                beta_d_w = acos(sqrt(A*d)/w);
                func = @(x) (sin(x)).^(n-2);
                coeff = integral(func, 0, beta_d_w);
                coeff = coeff*gamma(n/2)/(sqrt(pi)*gamma((n-1)/2));
                improved_covering_sphere_bound_cond_exp_list_size(idx, ii) = improved_covering_sphere_bound_cond_exp_list_size(idx, ii)...
                    + (weight_spectrum_high_rate(d+1) - weight_spectrum_low_rate(d+1))*coeff;
            end 
        end
    end
end



% plot the conditional upper bound
figure;
plot(norms, improved_covering_sphere_bound_cond_exp_list_size(1,:), '-'); hold on
plot(norms, improved_covering_sphere_bound_cond_exp_list_size(2,:), '-'); hold on
plot(norms, improved_covering_sphere_bound_cond_exp_list_size(3,:), '-'); hold on
grid on
legend('Improved covering-sphere upper bound, $-3$ dB',...
    'Improved covering-sphere upper bound, $10$ dB',...
    'Improved covering-sphere upper bound, $30$ dB');
xlabel('Norm $w$','interpreter', 'latex');
ylabel('List size', 'interpreter', 'latex');
title('k = 4, m = 3, \rho = 9, CRC:(17), ZTCC (13, 17)');











