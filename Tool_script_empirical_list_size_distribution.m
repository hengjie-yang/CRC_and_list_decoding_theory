set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% Load files
% path = './Simulation_results/';
% load([path, '012021_170854_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_17_k_4.mat'], 'List_size_instances', 'snr_dBs');

% path = './Simulation_results/';
% load([path, '012221_152243_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_17_k_10.mat'], 'List_size_instances', 'snr_dBs');

% path = './Simulation_results/';
% load([path, '012221_160132_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_11_k_10.mat'], 'List_size_instances', 'snr_dBs');

% path = './Simulation_results/';
% load([path, '012221_220728_sim_list_sizes_soft_origin_noise_ZTCC_27_31_CRC_25_k_60.mat'], 'List_size_instances', 'snr_dBs');


% path = './Simulation_results/';
% temp(1)=load([path, '012221_181325_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_11_k_60.mat'], 'List_size_instances', 'snr_dBs');

% path = './Simulation_results/';
% temp(2)=load([path, '012221_170555_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_17_k_60.mat'], 'List_size_instances', 'snr_dBs');

% path = './Simulation_results/';
% temp(3)=load([path, '012421_004058_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_13_k_60.mat'], 'List_size_instances', 'snr_dBs');

path = './Simulation_results/';
load([path, '012421_135656_sim_list_sizes_soft_origin_noise_ZTCC_13_17_CRC_15_k_60.mat'], 'List_size_instances', 'snr_dBs');





% % Compute the empirical correct decoding probability
Num = size(snr_dBs,2);

% correct_decoding_rate = zeros(size(snr_dBs));
% 
% for ii = 1:Num
%     num_instances = size(List_size_instances{ii}, 1);
%     num_correct = 0;
%     for jj = 1:num_instances
%         if List_size_instances{ii}(jj).correct_flag == 1
%             num_correct = num_correct + 1;
%         end
%     end
%     correct_decoding_rate(ii) = num_correct/num_instances;
% end


% Compute the empirical distribution of list ranks
k = 60;
m = 3;
Max_list_size = min(2^(k+m) - 2^k+1, 10000*2^m);


List_rank_distribution = zeros(Max_list_size, Num);

for ii = 1:Num
    num_instances = size(List_size_instances{ii}, 1);
    for jj = 1:num_instances
        list_rank = List_size_instances{ii}(jj).list_rank;
        List_rank_distribution(list_rank, ii) =  List_rank_distribution(list_rank, ii)+1;
    end
    tot = sum(List_rank_distribution(:, ii));
    List_rank_distribution(:, ii) = List_rank_distribution(:, ii)/tot;
end



% Compute the empirical distribution of list ranks conditioned on correct
% decoding
% Conditional_list_rank_distribution = zeros(Max_list_size, Num);
% 
% for ii = 1:Num
%     num_instances = size(List_size_instances{ii}, 1);
%     for jj = 1:num_instances
%         if List_size_instances{ii}(jj).correct_flag == 1
%             list_rank = List_size_instances{ii}(jj).list_rank;
%             Conditional_list_rank_distribution(list_rank, ii) =  Conditional_list_rank_distribution(list_rank, ii)+1;
%         end
%     end
%     tot = sum(Conditional_list_rank_distribution(:, ii));
%     Conditional_list_rank_distribution(:, ii) = Conditional_list_rank_distribution(:, ii)/tot;
% end


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
empirical_exp_list_size = sum(List_rank_distribution(:, 1)'.*list_sizes);


%%
figure;
Observable_max_list_size = 120;
semilogy(1:Observable_max_list_size, List_rank_distribution(1:Observable_max_list_size, 1)', '-+'); hold on
% semilogy(1:Observable_max_list_size, Conditional_list_rank_distribution(1:Observable_max_list_size, 1)', '-o'); hold on
semilogy(1:Observable_max_list_size, Approximated_distribution(1:Observable_max_list_size), '-.', 'LineWidth', 2); hold on
legend('Overall','Approximation');
grid on
xlabel('List rank');
ylabel('Probability');
title('k = 60, m = 3, CRC (15), ZTCC (13, 17)');



