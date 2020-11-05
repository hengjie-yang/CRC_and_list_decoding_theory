% This script is to compute the conditional expected list size E[L|W=w].
%
% The script will only work for very small blocklength n, i.e., n<= 24.
%
% The approach is to enumerate all possible error vectors of a given weight
% w. Then for each one, use DBS_LVA_Hamming to find its list size.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/04/20.

clear all;
clc;
set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% Input parameters
k = 4; % the information length
m = 3; % the CRC generator poly. degree
v = 3; % the # memeory elements
omega = 2;
n = omega*(k + m + v); % the blocklength, remember to make n small

crc_gen_poly = '17'; % make sure this is indeed a degree-m CRC gen. poly.
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly);
crc_coded_sequence = zeros(1, k+m+v);


code_generator = [13, 17];
trellis = poly2trellis(v+1, code_generator);
Max_list_size = 2^(k+m) - 2^k + 1;


Error_instances = cell(n+1, 1); % we have n+1 different error weights
Conditional_expected_list_sizes = zeros(n+1, 1); 

num_noise = 2^n;

tic
for ii = 0:num_noise-1

    % generator the noise vector
    rxSig = dec2bin(ii, n) - '0';
    w = sum(rxSig); % w ranges from 0 to n.
    
    % decode based on the noise vector
    [check_flag, correct_flag, path_rank, dec] = ...
            DBS_LVA_Hamming(trellis, rxSig, poly, crc_coded_sequence, Max_list_size);
    
    if mod(ii, 10000) == 0
        timeVal = tic;
        disp(['Current instance: ',num2str(ii),'/ ',num2str(num_noise),...
            ' list_rank: ',num2str(path_rank), ' Time spent: ', num2str(toc)]);
    end 
        
    % record the result
    Error_instances{w+1} = [Error_instances{w+1}; path_rank]; 
end
toc


%% compute the conditional list sizes

for w = 0:n
    correct_num = nchoosek(n, w);
    if correct_num == size(Error_instances{w+1}, 1) 
        Conditional_expected_list_sizes(w+1) = mean(Error_instances{w+1});
    end
end


figure;
plot(0:n, Conditional_expected_list_sizes','Marker','o');
grid on
xlabel('Noise Weight','interpreter', 'latex');
ylabel('Conditional expected list size', 'interpreter', 'latex');
title('k = 4, m = 3, CRC:(17), ZTCC (13, 17)');

path = './Simulation_results/';

timestamp = datestr(now, 'mmddyy_HHMMSS');
saveas(gcf, [path, timestamp, '_plot_conditional_exp_list_sizes_ZTCC_13_17_CRC_17_k_4.fig']);






    