% This script is to observe the pattern of undetected distance spectra of
% all noise vectors with the same noise weight W = w.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/25/20.
%



clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


path = './Simulation_results/';
load([path, '111320_200955_brute_force_bound_ZTCC_13_17_CRC_17_k_4.mat'],...
    'Upper_bound_instances', 'Relative_distance_spectra');


k = 4;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);
num_noise = 2^n;

Relative_dist_spectra_by_weights = cell(n+1, 1);

disp('Start processing');
for ii = 0:num_noise-1
    if mod(ii, 10000) == 0
        disp(['Current progress: ',num2str(ii)]);
    end
    noise_sequence = dec2bin(ii, n) - '0';
    w = sum(noise_sequence);
    [rows, cols] = size(Relative_dist_spectra_by_weights{w+1});
    spectra_len = size(Relative_distance_spectra{ii+1}, 1);
    if cols < spectra_len
        Relative_dist_spectra_by_weights{w+1} = ...
            [Relative_dist_spectra_by_weights{w+1}, zeros(rows, spectra_len-cols)];
        Relative_dist_spectra_by_weights{w+1} = ...
            [Relative_dist_spectra_by_weights{w+1}; Relative_distance_spectra{ii+1}'];
    else
        temp = Relative_distance_spectra{ii+1}';
        temp = [temp, zeros(1, cols - spectra_len)];
        Relative_dist_spectra_by_weights{w+1} = ...
            [Relative_dist_spectra_by_weights{w+1}; temp];
    end
end
disp('End processing');



