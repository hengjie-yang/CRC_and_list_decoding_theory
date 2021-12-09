% This script is to plot the tangential and tangential sphere (TS) bounds 
% on P_{e,\lambda} as a function of SNR. 
% TSB is developed in [1] and is tighter than the union bound.
%
% The TSB developed in this script follows paper reading slides of [1] and [2].
% Explicit expressions of the tangential bound and TS bound can be found in [3].
%
% Challenges: 
%   1) For codes of interest, we were only able to obtain distance
%       spectrum up to d_tilde.
%   2) Current script requires the knowledge of full weight spectrum.
%
% References:
%   [1]. G. Poltyrev, "Bounds on the decoding error probability of binary
%           linear block codes via their spectra", IEEE Trans. Inf. Theory,
%           1994.
%   [2]. S. Yousefi et al., "Generalized tangential sphere bound on the ML 
%           decoding error probability of linear block codes in AWGN 
%           interference", IEEE Trans. Inf. Theory, 2004.
%   [3]. H. Yang, Literature reading seminar slides, 12/12/21
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   12/09/21
%


clear all;
clc;

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

tic


% Step 1: set up basic parameters
k = 64; % information length
m = 0; % CRC degree
v = 3; % # memory elements in conv. encoder
omega = 2;
mode = 'ZTCC';
if strcmp(mode, 'ZTCC') == 1
    n = omega*(k + m + v);
else
    n = omega*(k + m);
end

% Step 2: load weight spectrum for the code of interest

path = './TCOM_truncated_union_bound/';
fileName = ['weight_node_ZTCC_13_17_N_67.mat']; % CAUTION: make sure n = omega*N !!!
if ~exist([path, fileName], 'file')
    disp(['ERROR: ',fileName, ' does not exist!']);
    return
end
load([path, fileName], 'weight_node');
weight_spectrum = weight_node.weight_spectrum;
d_min = find(weight_spectrum > 0);
d_min = d_min(2) - 1; % true d_min
d_max = length(weight_spectrum) - 1; % true d_max

SNRs = -1:0.5:6; 


% Step 3: Compute the union bound
Union_bound = zeros(size(SNRs));

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    A = sqrt(snr);
    for w = d_min:d_max
        S_w = weight_spectrum(w+1);
        Union_bound(iter) = Union_bound(iter) + S_w*qfunc(A*sqrt(w));
    end
    Union_bound(iter) = min(1, Union_bound(iter)); % truncate the diverging part
end



% Step 4: Compute the tangential bound
T_bound = zeros(size(SNRs));
weights = d_min:d_max;

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    noise_var = 1 / snr;
    z_r = find_opt_param(n, weight_spectrum, d_min, d_max, noise_var);
    if z_r == -1
        error('Failed to identify z_r for the tangential bound!')
    end
    for w = d_min:d_max
        S_w = weight_spectrum(w+1);
        T_bound(iter) = T_bound(iter) + S_w *...
            integral(@(x) exp(-x.^2./(2*noise_var))./sqrt(2*pi*noise_var).*qfunc(sqrt(w)*(sqrt(n)-x)./sqrt((n-w)*noise_var)), -Inf, z_r);
    end
    T_bound(iter) = T_bound(iter) + qfunc(z_r / sqrt(noise_var));
    T_bound(iter) = min(T_bound(iter), 1);
end


% Step 5: Compute the tangential sphere (TS) bound
TS_bound = zeros(size(SNRs));

r0 = find_opt_noise_radius(n, weight_spectrum, d_min, d_max);
if r0 == -1
   error('Failed to identify r0 for the tangential sphere bound!')
end
disp(['Optimal r: ', num2str(r0), ', ratio = ', num2str(r0/sqrt(n))]);

z1_gap = 0.5;
z1s = -100:z1_gap:100;

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    noise_var = 1 / snr;
    temp = 0;
    parfor ii = 1:length(z1s)
        z1 = z1s(ii);
        temp = temp + inner_func(n, weight_spectrum, d_min, r0, z1, noise_var) * z1_gap;
    end
    TS_bound(iter) = temp;
    TS_bound(iter) = TS_bound(iter) + ...
        integral(@(x) exp(-x.^2./(2*noise_var))./sqrt(2*pi*noise_var).*chi2cdf(r0^2*(sqrt(n) - x).^2./(n*noise_var), n-1, "upper"), -Inf, Inf);
end



% Step 6: plot curves

semilogy(SNRs, Union_bound, '-', 'LineWidth', 1.5, 'DisplayName','Union bound'); hold on
semilogy(SNRs, T_bound, '-.', 'LineWidth', 1.5, 'DisplayName','Tangential bound'); hold on
semilogy(SNRs, TS_bound, '-.', 'LineWidth', 1.5, 'DisplayName','TS bound');
grid on
legend;
xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
title('(134, 64) ZTCC under ML decoding');


toc


function [z_r] = find_opt_param(n, Spec, d_min, d_max, noise_var)

% This function is to identify the optimal parameter 'z_r' for the
% tangential bound.

z_r = -1;

z_min = 0;
z_max = sqrt(n);
threshold = 1e-5;

while z_max - z_min > threshold
    z_mid = (z_min + z_max) / 2;
    y = 0;
    for w = d_min:d_max
        S_w = Spec(w+1);
        y = y + S_w * qfunc((sqrt(n) - z_mid)*sqrt(w)/sqrt((n-w)*noise_var));
    end

    if y < 1
        z_min = z_mid;
    else
        z_max = z_mid;
    end
end

z_r = z_max;


end




function [y] = inner_func(n, Spec, d_min, r, z, noise_var)

y = 0;
z1_density = exp(-z^2/(2*noise_var)) / sqrt(2*pi*noise_var);
ulim = floor(n*r^2/(n + r^2));

for w = d_min:ulim
    S_w = Spec(w+1);
    beta_w = sqrt(w/(n-w))*(sqrt(n) - z);
    r_abs = r/sqrt(n)*abs(sqrt(n) - z);
    y = y + z1_density * S_w * ...
        integral(@(x) exp(-x.^2./(2*noise_var))./sqrt(2*pi*noise_var).*chi2cdf((r^2*(sqrt(n)-z)^2 - n.*x.^2)./(n*noise_var), n-2), beta_w, r_abs);
end

end






function [r_opt] = find_opt_noise_radius(n, Spec, d_min, d_max)

% This function is to identify the optimal noise radius 'r_opt' for the TS bound.
% The function uses bi-section search to identify 'r_opt'.
% Input parameters:
%   1) n: the blocklength
%   2) Spec: the full weight spectrum
%

r_opt = -1;
r_min = sqrt(n*d_min/(n - d_min));
r_max = sqrt(n*d_max/(n - d_max));
threshold = 1e-5;

f_min = obj_func(n, Spec, d_min, r_min);
f_max = obj_func(n, Spec, d_min, r_max);


if (f_min > 1) || (f_max < 1) % insufficient to identify 'r_opt'
    return
end

while r_max - r_min > threshold
    r_mid = (r_min + r_max) / 2;
    f_mid = obj_func(n, Spec, d_min, r_mid);
    if f_mid < 1
        r_min = r_mid;
    else
        r_max = r_mid;
    end
end

r_opt = r_max;

end






function [y] = obj_func(n, Spec, d_min, r)

y = 0;
coeff = gamma((n-1)/2) / (sqrt(pi)*gamma(n/2 - 1));

ulim = floor(n*r^2/(n + r^2));
for w = d_min:ulim
    S_w = Spec(w+1);
    theta_w = acos(sqrt(n*w/(r^2*(n - w))));
    y = y + coeff * S_w * integral(@(x) (sin(x)).^(n-3), 0, theta_w);
end


end





