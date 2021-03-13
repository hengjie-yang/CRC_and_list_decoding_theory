% This script is to study the relationship between E[L|W = \eta] and 
% P_{e,\lambda}(\eta). 
%
% Case study: k = 4, ZTCC (13, 11), degree-3 CRC poly. (17)
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/13/21
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% load file
path = './Simulation_results/';
fileName = '012921_164416_sim_cond_list_sizes_soft_ZTCC_13_17_CRC_17_k_4';
load([path, fileName, '.mat'],'etas', 'Cond_list_size_instances', 'Ave_cond_list_sizes');


figure;
plot(etas, Ave_cond_list_sizes,'-+');
grid on
