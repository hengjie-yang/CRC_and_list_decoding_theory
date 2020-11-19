% This script is to plot the new upper bound on the expected list
% size for the discrete version of CRC-aided list decoding of conv. code.
% The new bound is based on upper bounding E[L|W = w].
%
% The upper bound can be found in October progress 11-13-20 slides.
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

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',14,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% Input parameters
k = 64;
m = 6;
v = 3;
code_generator = [13, 17];
N = k + m + v; % the resulting trellis length
omega = size(code_generator, 2); 
n = omega*N; % the blocklength of ZTCC
d_CRC = 10; % the minimum distance of the low-rate conv. code.
rho = 21; % the covering radius of the low-rate conv. code.


path = './Simulation_results/';
load([path, '110320_104420_sim_list_sizes_ZTCC_13_17_CRC_103_k_64.mat'], 'Ave_list_sizes', 'snr_dBs');

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



% Step 2: Compute the upper bound
snrs = 10.^(snr_dBs./10);
alphas = qfunc(sqrt(snrs));


% pre-compute each type
P = zeros(n+1, 2); % P(kk+1,:) = [1-kk/n, kk/n];
for kk = 0:n
    P(kk+1,1) = 1 - kk/n;
    P(kk+1,2) = kk/n;
end



% pre-compute the new upper bound on E[L|W = w]
theoretical_bound_cond_exp_list_size = zeros(n+1, 1);

for w = 0:n
    threshold = min(w, rho);
%     threshold = w;
    for d = 0:threshold
        for t = w-d: min([w+d, 2*n-(w+d), size(weight_spectrum,1)-1])
            if (mod(d+t-w, 2) == 0)
                a = floor((d+t-w)/2);
%               disp(['a: ',num2str(a),' t: ', num2str(t), ' d: ',num2str(d)]);
                temp = weight_spectrum(t+1)*nchoosek(t, a)*nchoosek(n-t, d-a);
                theoretical_bound_cond_exp_list_size(w+1) =...
                    theoretical_bound_cond_exp_list_size(w+1)+temp;
            end
        end
    end
    theoretical_bound_cond_exp_list_size(w+1) = theoretical_bound_cond_exp_list_size(w+1);
end



% compute the upper bound on E[L]
Theoretical_bound_exp_list_sizes = zeros(1, size(snrs, 2)); % true upper bound on E[L]

for iter = 1:size(snrs, 2)
    alpha = alphas(iter);
    Q = [1-alpha, alpha];
    for w = 0:n
        D = Relative_Entropy(P(w+1, :), Q);
        H = Entropy(P(w+1, :));
        Theoretical_bound_exp_list_sizes(iter) = Theoretical_bound_exp_list_sizes(iter)+...
            1*2^(-n*(D+H))*theoretical_bound_cond_exp_list_size(w+1);
    end
end




% Step 3: plot the upper bound
figure;
semilogy(snr_dBs, Theoretical_bound_exp_list_sizes, '--'); hold on
semilogy(snr_dBs, Ave_list_sizes,'+-');
grid on;
legend('Upper bound', 'Simulation');
xlabel('$E_s/N_0$ (dB)','interpreter','latex');
ylabel('Expected list size $\mathrm{E}[L]$','interpreter','latex');
title('k = 64, m = 6, CRC: (103), ZTCC: (13, 17)');





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




