% This script is to generate the plot of E[L|W = \eta] vs. \eta for various
% information lengths k for ZTCC (13, 17).
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/16/21
%




path = './Simulation_results/';

load([path, '031521_123709_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_128.mat'],'etas','Ave_cond_list_sizes','P_UE_maxs');
Ave_cond_list_sizes_CRC_11_k_128 = Ave_cond_list_sizes;
P_UE_maxs_CRC_11_k_128 = P_UE_maxs;

load([path, '031521_121912_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_64.mat'],'etas','Ave_cond_list_sizes','P_UE_maxs');
Ave_cond_list_sizes_CRC_11_k_64 = Ave_cond_list_sizes;
P_UE_maxs_CRC_11_k_64 = P_UE_maxs;
convergent_val = Ave_cond_list_sizes(end);

load([path, '031521_121901_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_32.mat'],'etas','Ave_cond_list_sizes','P_UE_maxs');
Ave_cond_list_sizes_CRC_11_k_32 = Ave_cond_list_sizes;
P_UE_maxs_CRC_11_k_32 = P_UE_maxs;


load([path, '031521_121705_cond_exp_list_sizes_soft_ZTCC_13_17_CRC_11_k_16.mat'],'etas','Ave_cond_list_sizes','P_UE_maxs');
Ave_cond_list_sizes_CRC_11_k_16 = Ave_cond_list_sizes;
P_UE_maxs_CRC_11_k_16 = P_UE_maxs;



% Compute genie approximations

Approx_cond_list_sizes = cell(4, 1);
convergent_vals = zeros(4, 1);
num_points = 10;

convergent_vals(1) = mean(Ave_cond_list_sizes_CRC_11_k_128(end-num_points:end));
Approx_cond_list_sizes{1} = 1 - P_UE_maxs_CRC_11_k_128 + P_UE_maxs_CRC_11_k_128*convergent_vals(1);

convergent_vals(2) = mean(Ave_cond_list_sizes_CRC_11_k_64(end-num_points:end));
Approx_cond_list_sizes{2} = 1 - P_UE_maxs_CRC_11_k_64 + P_UE_maxs_CRC_11_k_64*convergent_vals(2);

convergent_vals(3) = mean(Ave_cond_list_sizes_CRC_11_k_32(end-num_points:end));
Approx_cond_list_sizes{3} = 1 - P_UE_maxs_CRC_11_k_32 + P_UE_maxs_CRC_11_k_32*convergent_vals(3);

convergent_vals(4) = mean(Ave_cond_list_sizes_CRC_11_k_16(end-num_points:end));
Approx_cond_list_sizes{4} = 1 - P_UE_maxs_CRC_11_k_16 + P_UE_maxs_CRC_11_k_16*convergent_vals(4);




figure;
Max_points = 60; % maximum number: 160
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_128(1:Max_points),'-o', 'Color', '#77AC30','MarkerSize',5); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes{1}(1:Max_points),'-.', 'Color', '#77AC30'); hold on
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_64(1:Max_points),'-v', 'Color', '#0072BD','MarkerSize',5); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes{2}(1:Max_points),'-.', 'Color', '#0072BD'); hold on
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_32(1:Max_points),'-s', 'Color', '#D95319','MarkerSize',5); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes{3}(1:Max_points),'-.', 'Color', '#D95319'); hold on
plot(etas(1:Max_points), Ave_cond_list_sizes_CRC_11_k_16(1:Max_points),'-d', 'Color', '#EDB120','MarkerSize',5); hold on
plot(etas(1:Max_points), Approx_cond_list_sizes{4}(1:Max_points),'-.', 'Color', '#EDB120'); hold on
grid on

legend('$k = 128$, Simulated',...
    '$k = 128$, Genie Approx.',...
    '$k = 64$, Simulated',...
    '$k = 64$, Genie Approx.',...
    '$k = 32$, Simulated',...
    '$k = 32$, Genie Approx.',...
    '$k = 16$, Simulated',...
    '$k = 16$, Genie Approx.',...
    'Location','southeast');
xlabel('Normalized norm $\eta$','interpreter', 'latex');
ylabel('$\mathrm{E}[L|W = \eta, \mathbf{X}=\bar{\mathbf{x}}_e]$', 'interpreter', 'latex');
% title('m = 3, ZTCC (13, 17), CRC (11)');