% This script is to generate the FER vs. SNR plot using data from
% Gianluigi. He provided the data on 10/18/21.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   10/18/21
%

clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


EbN0_BCH_128_64_t3 = 1:0.5:3.5;
FER_BCH_128_64_t3 = [1.7e-1, 6e-2, 1.8e-2, 3.3e-3, 5e-4, 7e-5];

EbN0_LDPC_128_64_t4 = 1:0.5:4;
FER_LDPC_128_64_t4 = [1.6e-1, 5e-2, 1e-2, 1.4e-3, 1.8e-4, 1.3e-5, 1e-6];

EbN0_BCH_128_64_t4 = 1:0.5:4;
FER_BCH_128_64_t4 = [1.6e-1, 5e-2, 1e-2, 1.1e-3, 1.3e-4, 8e-6, 4e-7];


% for rate-1/2 code, Eb/N0 = Es/\sigma^2
% data location: Box Sync\Communication Systems Laboratory\2020 LD for TBCC with CRC...
% \ethan_source_code\data_file\tbcc_data_newer\Plots_2019_04_19_different_rates

v_8_m_10_punctured_snr = [1,1.25000000000000,1.50000000000000,...
    1.75000000000000,2,2.25000000000000,2.50000000000000,...
    2.75000000000000,3,3.25000000000000, 3.5];
v_8_m_10_punctured = [0.105500000000000,0.0577000000000000,...
    0.0337000000000000,0.0166000000000000,0.00659804697809448,...
    0.00265287173365168,0.00112078724095805,0.000356266187844910,...
    0.000106820830489229,3.13851621624251e-05, 7.28188231997567e-06];



figure;
semilogy(EbN0_BCH_128_64_t3, FER_BCH_128_64_t3, 'k-o'); hold on
semilogy(EbN0_LDPC_128_64_t4, FER_LDPC_128_64_t4, 'r-^'); hold on
semilogy(EbN0_BCH_128_64_t4, FER_BCH_128_64_t4, 'b-s'); hold on
semilogy(v_8_m_10_punctured_snr, v_8_m_10_punctured, '-d'); hold on
legend('Extended BCH code, OSD $t = 3$',...
    'LDPC code $\mathcal{F}_{256}$, OSD $t=4$',...
    'Extended BCH code, OSD $t = 4$',...
    'Punctured CRC-TBCC, SLVD');

grid on
xlabel('$E_b/N_0$ (dB)', 'interpreter', 'latex');
ylabel('FER');

