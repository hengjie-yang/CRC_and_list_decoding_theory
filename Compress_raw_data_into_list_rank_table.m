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
path = './Big_sim_data/';
fileName = '021521_185836_sim_cond_list_sizes_soft_ZTCC_13_17_CRC_103_k_64';
load([path, fileName, '.mat'],'etas', 'Cond_list_size_instances', 'Ave_cond_list_sizes');

%%
figure;
plot(etas, Ave_cond_list_sizes,'-+');
grid on

%% compress data into a table by list ranks
code_generator = [13, 17];
CRCpoly = '103';
k = 64;
DistTable = cell(length(etas), 1);
Psi = 10^4; % large enough to ensure no NACK occurrence
for iter = 1:size(DistTable, 1)
    DistTable{iter} = zeros(Psi+1, 3); 
    % (i, 1):# Total, (i, 2): # Cor. Dec., (i, 3) # UE, i<=Psi
    % (Psi+1, 1): # NACKs (should be zero all the time)
    for ii = 1:size(Cond_list_size_instances{iter}, 1)
        L = Cond_list_size_instances{iter}(ii).list_rank;
        check_flag = Cond_list_size_instances{iter}(ii).check_flag;
        correct_flag = Cond_list_size_instances{iter}(ii).correct_flag;
        if check_flag == 1 
            if correct_flag == 1
                DistTable{iter}(L, 2) = DistTable{iter}(L, 2) + 1;
            else
                DistTable{iter}(L, 3) = DistTable{iter}(L, 3) + 1;
            end
            DistTable{iter}(L, 1) = DistTable{iter}(L, 1) + 1;
        else
            DistTable{iter}(Psi+1, 1) = DistTable{iter}(Psi+1, 1) + 1;
        end
    end
end
disp('Processing completed!');

path = './Simulation_results/';
timestamp = datestr(now, 'mmddyy_HHMMSS');
fileName = ['_list_rank_table_cond_exp_list_rank_vs_eta_',...
    'ZTCC_',num2str(code_generator(1)),'_',num2str(code_generator(2)),'_CRC_',...
    CRCpoly, '_k_',num2str(k)];
save([path, timestamp, fileName, '.mat'],'etas','DistTable');
    


    




