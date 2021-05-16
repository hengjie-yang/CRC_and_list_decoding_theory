% This script is to generate the plot of P_{e, 1} and P_{e, \lambda} as a
% function of SNR. We will also compute the full distance spectra of the
% low-rate code and high-rate code 
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/01/21.
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% basic parameters
k = 64;
v = 3;
code_generator = [13, 17];
CRC_poly = '103';
poly = dec2bin(base2dec(CRC_poly, 8))-'0';
m = length(poly) - 1;
omega = size(code_generator, 2);
n = omega*(k + m + v);
trellis = poly2trellis(v+1, code_generator);


% load file
path = './TCOM_sim_data/';
fileName = '030321_143622_sim_data_probs_and_exp_list_sizes_vs_SNR_ZTCC_13_17_CRC_103_k_64';
load([path, fileName, '.mat'],'P_UE_mins', 'P_UE_maxs','P_NACK_mins', 'SNRs');


% Compute the union bound for P_{e, 1} and P_{e, \lambda}
% Union_bound_mins = zeros(1, length(SNRs));
% Union_bound_maxs = zeros(1, length(SNRs));
% 
% overall_code_generator = [1653, 1057];
% 
% fileName = ['weight_node_ZTCC_',num2str(overall_code_generator(1)),'_',num2str(overall_code_generator(2)),'_N_',num2str(k+m+v),'.mat'];
% if ~exist(fileName, 'file')
%     disp(['ERROR: ', fileName, 'does not exist!']);
%     return
% else
%     load(fileName, 'weight_node');
% end
% low_rate_weight_spectrum = weight_node.weight_spectrum;
% 
% d_max = length(low_rate_weight_spectrum) - 1;
% index = find(low_rate_weight_spectrum>0);
% d_min = index(2) - 1;
% 
% for iter = 1:length(SNRs)
%     snr = 10^(SNRs(iter)/10);
%     A = sqrt(snr);
%     for d = d_min:d_max
%         C_d = low_rate_weight_spectrum(d+1);
%         Union_bound_maxs(iter) = Union_bound_maxs(iter) + C_d*qfunc(A*sqrt(d));
%     end
% end


% Compute the truncated union bound for P_{e, \lambda}
d_tilde = 24;
Truncated_union_bound = zeros(1, length(SNRs));
Hybrid_approximation_on_P_UE_max = zeros(1, length(SNRs));

path = './TCOM_truncated_union_bound/';
fileName = ['Partial_low_rate_spectrum_ZTCC_',num2str(code_generator(1)),...
    '_',num2str(code_generator(2)),'_','CRC_',CRC_poly,'_k_',num2str(k),...
    '_d_tilde_',num2str(d_tilde),'.mat'];

if ~exist([path, fileName], 'file')
    disp(['ERROR: ',fileName, ' does not exist!']);
    return
end

load([path, fileName], 'weight_node');
Partial_low_rate_weight_spectrum = weight_node.weight_spectrum;
index = find(Partial_low_rate_weight_spectrum > 0);
d_crc = index(1);


for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    A = sqrt(snr);
    for d = d_crc:d_tilde
        C_d = Partial_low_rate_weight_spectrum(d);
        Truncated_union_bound(iter) = Truncated_union_bound(iter) + C_d*qfunc(A*sqrt(d));
    end
    Hybrid_approximation_on_P_UE_max(iter) = min(1, Truncated_union_bound(iter));
end
    

% Compute the hybrid upper bound on P_{e, 1}
NNA_on_P_UE_min = zeros(1, length(SNRs));
Hybrid_approximation_on_P_UE_min = zeros(1, length(SNRs));

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    A = sqrt(snr);
    NNA_on_P_UE_min(iter) = Partial_low_rate_weight_spectrum(d_crc)*qfunc(A*sqrt(d_crc));
    Hybrid_approximation_on_P_UE_min(iter) = min(2^(-m), NNA_on_P_UE_min(iter));
end



% Compute the approximation for P_{NACK, 1}
Hybrid_approximation_on_P_NACK_min = zeros(1, length(SNRs));

path = './TCOM_truncated_union_bound/';
fileName = [path, 'weight_node_ZTCC_',num2str(code_generator(1)),'_',num2str(code_generator(2)),'_N_',num2str(k+m+v),'.mat'];
if ~exist(fileName, 'file')
    disp(['ERROR: ', fileName, ' does not exist!']);
    return
else
    load(fileName, 'weight_node');
end

high_rate_weight_spectrum = weight_node.weight_spectrum;
index = find(high_rate_weight_spectrum > 0);
d_min = index(2) - 1;
d_max = index(end) - 1;

for iter = 1:length(SNRs)
    snr = 10^(SNRs(iter)/10);
    A = sqrt(snr);
    temp = 0;
    for d = d_min:d_tilde  % enumerate true distance
        B_d = high_rate_weight_spectrum(d+1); % there is +1 offset between index and true distance
        temp = temp + B_d*qfunc(A*sqrt(d));
    end
    C_d_crc = Partial_low_rate_weight_spectrum(d_crc);
    temp = temp - C_d_crc*qfunc(A*sqrt(d_crc));
    Hybrid_approximation_on_P_NACK_min(iter) = min(1 - 2^(-m), temp);
end




% Plot curves
figure;
semilogy(SNRs, Hybrid_approximation_on_P_NACK_min, '-.','LineWidth', 1.5, 'Color', '#0072BD');hold on
semilogy(SNRs, P_NACK_mins, '-+','MarkerSize',5, 'Color', '#0072BD');hold on
semilogy(SNRs, Hybrid_approximation_on_P_UE_max, '-.','LineWidth', 1.5, 'Color', '#D95319');hold on
semilogy(SNRs, P_UE_maxs, '-+','MarkerSize',5, 'Color', '#D95319');hold on
semilogy(SNRs, Hybrid_approximation_on_P_UE_min, '-.','LineWidth', 1.5, 'Color', '#77AC30');hold on
semilogy(SNRs, P_UE_mins, '-+','MarkerSize',5, 'Color', '#77AC30');hold on
grid on
ylim([10^(-7), 1]);
xlim([-4, 5]);
legend('Approx. in Eq. (58)',...
    '$P_{\mathit{NACK}, 1}$',...
    'Approx. in Eq. (57)',...
    '$P_{e, \lambda}$',...
    'Approx. in Eq. $(55)$',...
    '$P_{e, 1}$', 'Location','southwest');
xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Probability of error', 'interpreter', 'latex');
% title('k = 64, degree-6 CRC (103), ZTCC (13, 17)');

