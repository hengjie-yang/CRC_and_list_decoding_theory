% This script is to prepare Fig. 2 in current TIT manuscript.
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

%% Basic parameters

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
    disp(['Current CRC index: ', num2str(iter), ' out of ',num2str(num_crc)]);
    weight_node = Compute_relative_distance_spectrum_brute_force(v+1, code_generator, k+m, crc_polys(iter, :), zeros(1,n));
    low_rate_spectra(iter, :) = weight_node.distance_spectrum_low_rate';
end
disp('Step 1 Finished!');

%% Step 2: Compute the union bound
SNR_dBs = -0.5:0.01:2;
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
% semilogy(SNR_dBs, union_bounds(1,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(2,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(3,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(4,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(5,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(6,:), '-');hold on
% 
% semilogy(SNR_dBs, union_bounds(8,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(9,:), '-');hold on
% 
% semilogy(SNR_dBs, union_bounds(11,:), '-');hold on
% 
% semilogy(SNR_dBs, union_bounds(13,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(14,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(15,:), '-');hold on
% semilogy(SNR_dBs, union_bounds(16,:), '-');hold on


% --------------------------------------------------

semilogy(SNR_dBs, union_bounds(10,:), 'k-');hold on
semilogy(SNR_dBs, union_bounds(12,:), 'r-');hold on
semilogy(SNR_dBs, union_bounds(7,:), 'b-.');hold on

xline(threshold,'--k');
txt = '$\leftarrow$ threshold';
text(threshold,7*10^(-2),txt,'interpreter','latex','HorizontalAlignment','left');
legend('degree-$5$ CRC poly. 0x33',...
    'degree-$5$ CRC poly. 0x37',...
    'degree-$5$ CRC poly. 0x2D');
xlabel('$\gamma_s$ (dB)','interpreter','latex');
ylabel('Probability of UE','interpreter','latex');
grid on



% Specify the position and the size of the rectangle
x_r = -0.474; y_r = 0.086; w_r = 0.05; h_r = 0.006;
rectangle('Position', [x_r-w_r/2, y_r-h_r/2, w_r, h_r], ...
'EdgeColor', [0.4, 0.1, 0.4], 'LineWidth',2);


% Specify the position and the size of the second box and thus add a second axis for plotting
x_a = 0.22; y_a = 0.14; w_a = 0.35; h_a = 0.32;
ax = axes('Units', 'Normalized', ...
'Position', [x_a, y_a, w_a, h_a], ...
'XTick', [], ...
'YTick', [], ...
'Box', 'on', ...
'LineWidth', 1, ...
'Color', [1, 1, 1]);
hold on;

semilogy(SNR_dBs, union_bounds(12,:), 'r-');hold on
semilogy(SNR_dBs, union_bounds(7,:), 'b-.');hold on
grid on
txt = '$P_{e,\lambda}\in[0.083, 0.089]$';
text(-0.485,0.0885,txt,'interpreter','latex','HorizontalAlignment','left');
txt = '$\gamma_s\in[-0.5, -0.45]$';
text(-0.482,0.0877,txt,'interpreter','latex','HorizontalAlignment','left');
% xlabel('Detail at $-0.474$ (dB)','interpreter','latex');
axis([x_r-w_r/2, x_r+w_r/2, y_r-h_r/2, y_r+h_r/2]);












