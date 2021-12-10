% This script is to plot P_{e, 1} and P_{e, \lambda} and their
% approximations. The v2 version incorporates the tangential sphere bound
% as a good approximation for these probabilities. 
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


% Step 1: set up basic parameters
k = 64;
v = 3;
omega = 2;
mode = 'ZTCC';
CRC_poly = '103';
poly = dec2bin(base2dec(CRC_poly, 8))-'0';
m = length(poly) - 1;
code_generator = [13, 17];
d_tilde = 24;

if strcmp(mode, 'ZTCC')
    n = omega * (k + m + v);
else                            % assuming TBCC case
    n = omega * (k + m);
end

path = './TCOM_sim_data/';
fileName = '030321_143622_sim_data_probs_and_exp_list_sizes_vs_SNR_ZTCC_13_17_CRC_103_k_64';
load([path, fileName, '.mat'],'P_UE_mins', 'P_UE_maxs','P_NACK_mins', 'SNRs');

path = './TCOM_truncated_union_bound/';
fileName = ['Partial_low_rate_spectrum_ZTCC_',num2str(code_generator(1)),...
    '_',num2str(code_generator(2)),'_','CRC_',CRC_poly,'_k_',num2str(k),...
    '_d_tilde_',num2str(d_tilde),'.mat'];
load([path, fileName], 'weight_node');
low_rate_spec = weight_node.weight_spectrum; % the all-zero codeword is excluded
low_rate_spec = [1; low_rate_spec]; % add back all-zero codeword so that the form is consistent

fileName = ['weight_node_ZTCC_',num2str(code_generator(1)),'_',num2str(code_generator(2)),'_N_',num2str(k+m+v),'.mat'];
load([path, fileName], 'weight_node');
high_rate_spec = weight_node.weight_spectrum; % the all-zero codeword is included


% Compute the tangential sphere bound for P_{NACK, 1}
TS_bound_on_P_NACK_min = zeros(size(SNRs));
high_rate_d_min = find(high_rate_spec > 0);
high_rate_d_min = high_rate_d_min(2) - 1;
high_rate_d_max = length(high_rate_spec) - 1;

r0 = find_opt_noise_radius(n, high_rate_spec, high_rate_d_min, high_rate_d_max);
if r0 == -1
   error('High-rate code: Failed to identify r0 for the tangential sphere bound!');
end
disp(['High-rate code: Optimal r: ', num2str(r0), ', ratio = ', num2str(r0/sqrt(n))]);

z1_gap = 0.5;
z1s = -100:z1_gap:100;

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    noise_var = 1 / snr;
    temp = 0;
    parfor ii = 1:length(z1s)
        z1 = z1s(ii);
        temp = temp + inner_func(n, high_rate_spec, high_rate_d_min, r0, z1, noise_var) * z1_gap;
    end
    TS_bound_on_P_NACK_min(iter) = temp;
    TS_bound_on_P_NACK_min(iter) = TS_bound_on_P_NACK_min(iter) + ...
        integral(@(x) exp(-x.^2./(2*noise_var))./sqrt(2*pi*noise_var).*chi2cdf(r0^2*(sqrt(n) - x).^2./(n*noise_var), n-1, "upper"), -Inf, Inf);
    TS_bound_on_P_NACK_min(iter) = min(1 - 2^(-m), TS_bound_on_P_NACK_min(iter));
end



% Compute the truncated union bound for P_{e, \lambda}
TU_bound_on_P_UE_max = zeros(size(SNRs));
low_rate_d_min = find(low_rate_spec > 0);
low_rate_d_min = low_rate_d_min(2) - 1;
low_rate_d_max = length(low_rate_spec) - 1;

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    A = sqrt(snr);
    for w = low_rate_d_min:low_rate_d_max
        S_w = low_rate_spec(w+1);
        TU_bound_on_P_UE_max(iter) = TU_bound_on_P_UE_max(iter) + S_w * qfunc(A*sqrt(w));
    end
    TU_bound_on_P_UE_max(iter) = min(1, TU_bound_on_P_UE_max(iter));
end



% Compute the nearest neighbor approximation for P_{e, 1}
NNA_on_P_UE_min = zeros(size(SNRs));

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    A = sqrt(snr);
    NNA_on_P_UE_min(iter) = low_rate_spec(low_rate_d_min+1)*qfunc(A*sqrt(low_rate_d_min));
    NNA_on_P_UE_min(iter) = min(2^(-m), NNA_on_P_UE_min(iter));
end





% Plot curves
figure;
semilogy(SNRs, TS_bound_on_P_NACK_min, '-.','LineWidth', 1.5, 'Color', '#0072BD', 'DisplayName','Approx. in Eq. (59)');hold on
semilogy(SNRs, P_NACK_mins, '-+','MarkerSize',5, 'Color', '#0072BD','DisplayName','$P_{\mathit{NACK}, 1}$');hold on
semilogy(SNRs, TU_bound_on_P_UE_max, '-.','LineWidth', 1.5, 'Color', '#D95319','DisplayName','Approx. in Eq. (58)');hold on
semilogy(SNRs, P_UE_maxs, '-+','MarkerSize',5, 'Color', '#D95319','DisplayName','$P_{e, \lambda}$');hold on
semilogy(SNRs, NNA_on_P_UE_min, '-.','LineWidth', 1.5, 'Color', '#77AC30','DisplayName','Approx. in Eq. $(56)$');hold on
semilogy(SNRs, P_UE_mins, '-+','MarkerSize',5, 'Color', '#77AC30','DisplayName','$P_{e, 1}$');hold on
grid on
ylim([10^(-7), 1]);
xlim([-4, 5]);

legend('Location','southwest');
xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');





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






