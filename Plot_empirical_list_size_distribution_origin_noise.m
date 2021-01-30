% This script is to aggregate the plots of empirical list size distribution
% for all degree-m CRCs and a fixed ZTCC.
%
%   Written by Hengjie Yang (hengjie.yang@ucla.edu) 01/24/21.
%


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');



temp =cell (4,1);
% Load data
path = './Simulation_results/';
load([path, '012221_181325_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_11_k_60.mat'], 'List_size_instances', 'snr_dBs');
temp{1} = List_size_instances;

path = './Simulation_results/';
load([path, '012221_170555_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_17_k_60.mat'], 'List_size_instances', 'snr_dBs');
temp{2} = List_size_instances;

path = './Simulation_results/';
load([path, '012421_004058_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_13_k_60.mat'], 'List_size_instances', 'snr_dBs');
temp{3} = List_size_instances;


path = './Simulation_results/';
load([path, '012421_135656_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_15_k_60.mat'], 'List_size_instances', 'snr_dBs');
temp{4} = List_size_instances;

Num = length(temp);


% Compute the empirical distribution of list ranks
k = 60;
m = 3;
Max_list_size = min(2^(k+m) - 2^k+1, 10000*2^m);


List_rank_distribution = zeros(Max_list_size, Num);

for ii = 1:Num
    num_instances = size(temp{ii}{1}, 1);
    for jj = 1:num_instances
        list_rank = temp{ii}{1}(jj).list_rank;
        List_rank_distribution(list_rank, ii) =  List_rank_distribution(list_rank, ii)+1;
    end
    tot = sum(List_rank_distribution(:, ii));
    List_rank_distribution(:, ii) = List_rank_distribution(:, ii)/tot;
end



%% Compute the theoretical approximated distribution

Approximated_distribution = zeros(1, Max_list_size);

for ii = 1:Max_list_size
    temp = 1;
    for jj = 0:ii-2
        scalar = 1 - 2^k/(2^(k+m)-jj);
        temp = temp*scalar;
    end
    scalar = 2^k/(2^(k+m)-ii+1);
    temp = temp*scalar;
    Approximated_distribution(ii) = temp;
end


% Compute expected list sizes

list_sizes = 1:Max_list_size;
approximated_exp_list_size = sum(Approximated_distribution.*list_sizes);
empirical_exp_list_size = zeros(Num, 1);

for ii = 1:Num
    empirical_exp_list_size(ii) = sum(List_rank_distribution(:, ii)'.*list_sizes);
end



%%
figure;
Observable_max_list_size = 100;
semilogy(1:Observable_max_list_size, List_rank_distribution(1:Observable_max_list_size, 1)', '-'); hold on
semilogy(1:Observable_max_list_size, List_rank_distribution(1:Observable_max_list_size, 2)', '-'); hold on
semilogy(1:Observable_max_list_size, List_rank_distribution(1:Observable_max_list_size, 3)', '-'); hold on
semilogy(1:Observable_max_list_size, List_rank_distribution(1:Observable_max_list_size, 4)', '-'); hold on
semilogy(1:Observable_max_list_size, Approximated_distribution(1:Observable_max_list_size), '-.', 'LineWidth', 2); hold on
legend('CRC (11), ZTCC (13, 17)',...
    'CRC (17), ZTCC (13, 17)',...
    'CRC (13), ZTCC (13, 17)',...
    'CRC (15), ZTCC (13, 17)',...
    'Approximation');
grid on
xlabel('List rank');
ylabel('Probability');
title('k = 60, m = 3, ZTCC (13, 17)');












