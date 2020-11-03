% This script is to plot the theoretical upper bound on the expected list
% size for the discrete version of CRC-aided list decoding of conv. code.
%
% The upper bound can be found in October progress 10-30-20 slides.
%
% Input required to the script:
%   1) d_CRC and covering radius of high-rate conv. code \rho.
%   2) The full weight distance spectrum.
%
% Example of the script: k = 64, rate-1/2 ZTCC (13, 17), degree-6 CRC (103)
%   d_CRC = 12.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/02/20.
%

clear;
clc;

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',14,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',14,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% Input parameters
m = 6; % the CRC-degree added to the raw information sequence.
k = 64 + 6; % the information length for the equivalent high-rate code.
v = 3;
code_generator = [13, 17];
N = k + v; % the resulting trellis length
omega = size(code_generator, 2); 
n = omega*N; % the blocklength of ZTCC
d_CRC = 12; % the minimum distance of the low-rate conv. code.
rho = d_CRC; % the covering radius of the low-rate conv. code.
snr_dB = -10:0.5:5;  % E_s/(N_0/2) in dB

code_string = '';
for iter = 1:size(code_generator,2)
    code_string = [code_string, num2str(code_generator(iter)), '_'];
end

file_name = ['weight_node_ZTCC_',code_string,'N_',num2str(N),'.mat'];
if ~exist(file_name, 'file')
    disp(['Error: the file ',file_name, ' does not exist!']);
    return
end

load(file_name, 'weight_node');
weight_spectrum = weight_node.weight_spectrum;

path = './Simulation_results/';
load([path, '110320_023555_simulation_list_sizes_ZTCC_13_17_CRC_177_k_64.mat'],'Ave_list_sizes');



% Step 2: Compute the upper bound
snrs = 10.^(snr_dB./10);
alphas = qfunc(sqrt(snrs));

Upper_bound_list_size = zeros(1, size(snrs, 2));

% pre-compute each type
P = zeros(n+1, 2); % P(kk+1,:) = [1-kk/n, kk/n];
for kk = 0:n
    P(kk+1,1) = 1 - kk/n;
    P(kk+1,2) = kk/n;
end

        
%pre-compute the partial sum of distance spectrum
Partial_dist = zeros(size(weight_spectrum, 1), 1); % Partial_sum(ii) = \sum_{d=0}^{ii-1} A_d, ii>=1
Partial_dist(1) = weight_spectrum(1); % note that the i-th entry has distance (i-1), i>=1

for ii = 2:size(weight_spectrum, 1)
    Partial_dist(ii) = Partial_dist(ii-1)+weight_spectrum(ii);
end




dist_threshold = floor((d_CRC-1)/2);

for iter = 1:size(snrs ,2)
    alpha = alphas(iter);
    Q = [1-alpha, alpha];
    for kk = 0:n
        D = Relative_Entropy(P(kk+1,:), Q);
        H = Entropy(P(kk+1,:));
        if kk<=dist_threshold
            Upper_bound_list_size(iter) = Upper_bound_list_size(iter) + 2^(-n*(D+H))*nchoosek(n, kk)*Partial_dist(2*kk+1);
        else
            Upper_bound_list_size(iter) = Upper_bound_list_size(iter) + 2^(-n*(D+H))*nchoosek(n, kk)*Partial_dist(2*rho+1);
        end
    end
end




% Step 3: plot the upper bound
figure;
semilogy(snr_dB, Upper_bound_list_size); hold on
semilogy(snr_dB, Ave_list_sizes);
grid on;
legend('Upper bound');
xlabel('SNR','interpreter','latex');
ylabel('$\mathrm{E}[L]$','interpreter','latex');
title('k=64, degree-6 CRC: (177), ZTCC(13, 17)');





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




