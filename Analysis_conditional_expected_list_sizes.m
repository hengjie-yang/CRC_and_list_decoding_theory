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

crc_gen_poly = '11'; % make sure this is indeed a degree-m CRC gen. poly.
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


% compute the conditional list sizes

for w = 0:n
    correct_num = nchoosek(n, w);
    if correct_num == size(Error_instances{w+1}, 1) 
        Conditional_expected_list_sizes(w+1) = mean(Error_instances{w+1});
    end
end



figure;
plot(0:n, Conditional_expected_list_sizes','Marker','o');
grid on
xlabel('Noise weight $w$','interpreter', 'latex');
ylabel('Conditional expected list size', 'interpreter', 'latex');
title('k = 4, m = 3, CRC:(17), ZTCC (13, 17)');



path = './Simulation_results/';

timestamp = datestr(now, 'mmddyy_HHMMSS');
save([path, timestamp, '_cond_exp_list_sizes_ZTCC_13_17_CRC_11_k_4.mat'],'Error_instances', 'Conditional_expected_list_sizes');
% saveas(gcf, [path, timestamp, '_plot_conditional_exp_list_sizes_ZTCC_13_17_CRC_17_k_4.fig']);


%% Plot the simulated expected list sizes and the theoretical list sizes

path = './Simulation_results/';
% load([path, '110420_180539_list_sizes_ZTCC_13_17_CRC_17_k_4.mat'], 'Ave_list_sizes', 'snr_dBs');


snrs = 10.^(snr_dBs./10);
alphas = qfunc(sqrt(snrs));

Theoretical_exp_list_sizes = zeros(1, size(snrs, 2));

% pre-compute each type
P = zeros(n+1, 2); % P(kk+1,:) = [1-kk/n, kk/n];
for kk = 0:n
    P(kk+1,1) = 1 - kk/n;
    P(kk+1,2) = kk/n;
end


% compute the theoretical expected list size
for iter = 1:size(snrs, 2)
    alpha = alphas(iter);
    Q = [1-alpha, alpha];
    for w = 0:n
        D = Relative_Entropy(P(w+1, :), Q);
        H = Entropy(P(w+1, :));
        Theoretical_exp_list_sizes(iter) = Theoretical_exp_list_sizes(iter)+...
            nchoosek(n, w)*2^(-n*(D+H))*Conditional_expected_list_sizes(w+1);
    end
end


% Plot both curves
figure;
plot(snr_dBs, Theoretical_exp_list_sizes, '--'); hold on
plot(snr_dBs, Ave_list_sizes, '+-'); hold on
legend('Theoretical', 'Simulation');
grid on
xlabel('$E_s/N_0$ (dB)', 'interpreter', 'latex');
ylabel('Expected list size');

title('k = 4, m = 3, CRC: (11), ZTCC: (13, 17)');





function D = Relative_Entropy(P, Q)

% make sure P, Q are of the same dimension
if P(1)<1 && P(1)>0
    D = sum(P.*log2(P./Q));
elseif P(1) == 1
    D = P(1)*log2(P(1)/Q(1));
else
    D = P(2)*log2(P(2)/Q(2));
end   

end


function H = Entropy(P)

if P(1) == 1 || P(2) == 1
    H = 0;
else
    H = -sum(P.*log2(P));
end

end









    