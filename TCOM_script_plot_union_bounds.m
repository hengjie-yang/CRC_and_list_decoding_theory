% This script is to prepare Fig. 2 in current TCOM manuscript.
% 
% Plot the union bound of all degree-3 CRC polynomials for k = 4, ZTCC (13,
% 17).
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   02/17/21.
%

clear all; clc;
set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% Basic parameters

k = 10;
m = 5;
v = 3;
omega = 2;
code_generator = [13, 17];
n = omega*(k+m+v);


num_crc = 2^(m-1);
temp = 0:num_crc-1;
temp = dec2bin(temp, m-1) - '0';
crc_polys = [ones(num_crc, 1), temp, ones(num_crc, 1)]; % degree from low to high

low_rate_spectra = zeros(num_crc, n+1);



% Step 1: Find the low-rate code distance spectra for each CRC poly.
for iter = 1:num_crc
    weight_node = Compute_relative_distance_spectrum_brute_force(v+1, code_generator, k+m, crc_polys(iter, :), zeros(1,n));
    low_rate_spectra(iter, :) = weight_node.distance_spectrum_low_rate';
end
disp('Step 1 Finished!');

%% Step 2: Compute the union bound
SNR_dBs = -0.5:0.01:4;
union_bounds = zeros(num_crc, length(SNR_dBs));

dists = 1:n;
for iter = 1:num_crc
    for ii = 1:size(SNR_dBs, 2)
        snr = 10^(SNR_dBs(ii)/10);
        coefficients = low_rate_spectra(iter, :);
        union_bounds(iter, ii) = sum(coefficients(2:end).*qfunc(sqrt(snr*dists)));
    end
end


% Find the threshold that differentiate two CRCs
idx1 = 12;
idx2 = 7;
dists = 1:n;
fun = @(x) sum(low_rate_spectra(idx1, 2:end).*qfunc(sqrt(x.*dists))) - ...
    sum(low_rate_spectra(idx2, 2:end).*qfunc(sqrt(x.*dists)));
threshold = fzero(fun, [0.001, 6]);
threshold = 10*log10(threshold);


% Step 3: Plot the union bound

figure;
% semilogy(SNR_dBs, union_bounds(1,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(2,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(3,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(4,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(5,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(6,:), '-o');hold on
semilogy(SNR_dBs, union_bounds(12,:), '-');hold on
semilogy(SNR_dBs, union_bounds(7,:), '-.');hold on
% semilogy(SNR_dBs, union_bounds(8,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(9,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(10,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(11,:), '-o');hold on

% semilogy(SNR_dBs, union_bounds(13,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(14,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(15,:), '-o');hold on
% semilogy(SNR_dBs, union_bounds(16,:), '-o');hold on
xline(threshold,'--r');
txt = '$\leftarrow threshold$';
text(threshold,5*10^(-3),txt,'interpreter','latex','HorizontalAlignment','left');
legend('degree-$5$ CRC poly. 0x3B', 'degree-$5$ CRC poly. 0x2D');
xlabel('$\gamma_s$ (dB)','interpreter','latex');
ylabel('Probability of UE','interpreter','latex');
grid on




