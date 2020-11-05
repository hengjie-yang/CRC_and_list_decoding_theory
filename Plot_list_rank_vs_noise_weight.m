% This script is to plot the scatter plot of list_rank vs. noise_weight
%
% Purpose: to understand how list sizes vary with a given noise weight.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/03/20.
%


clear;
clc;

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');



k = 64;
m = 6;
v = 3;


path = './Simulation_results/';
% load([path, '110320_104420_list_sizes_ZTCC_13_17_CRC_103_k_64.mat'], 'List_size_instances', 'snr_dBs');
load([path, '110320_023555_list_sizes_ZTCC_13_17_CRC_177_k_64.mat'], 'List_size_instances', 'snr_dBs');

list_sizes = [];
noise_weights = [];
indicators = []; % to store whether the point corresponds to a correct decoding or not.

parfor iter = 1:size(snr_dBs, 2)
    disp(['Current iter: ', num2str(iter)]);
    tot = size(List_size_instances{iter}, 1);
    for ii = 1:tot
        noise_weights = [noise_weights; List_size_instances{iter}(ii).noise_weight];
        list_sizes = [list_sizes; List_size_instances{iter}(ii).list_rank];
        indicators = [indicators; List_size_instances{iter}(ii).correct_flag];
    end
end

figure;
sz = 20;
scatter(noise_weights(indicators == 0), list_sizes(indicators == 0), sz,...
    'MarkerEdgeColor',[1 1 1], 'MarkerFaceColor','r','LineWidth',1); hold on
scatter(noise_weights(indicators == 1), list_sizes(indicators == 1), sz,...
    'MarkerEdgeColor',[1 1 1], 'MarkerFaceColor',[0, .5 0],'LineWidth',1); hold on
grid on
xlabel('Noise Weight','interpreter', 'latex');
ylabel('List Rank $L$', 'interpreter', 'latex');
title('k=64, degree-6 CRC:(177), ZTCC:(13, 17), SNR:[-10:0.5:5]');



timestamp = datestr(now, 'mmddyy_HHMMSS');
saveas(gcf, [path, timestamp, '_plot_list_size_vs_noise_weight_ZTCC_13_17_CRC_177_k_64.fig']);



