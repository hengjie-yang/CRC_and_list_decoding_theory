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

Fabian_m_11_snr = [1,1.5,2,2.5,3,3.5,4];
Fabian_m_11 = [0.0998004,0.0398565,0.0101513,0.00137722,1.38E-04,1.27E-05,9.51E-07];

Fabian_m_14_snr = [1,1.5,2,2.5,3,3.5];
Fabian_m_14 = [0.119332,0.0340599,0.00840015,0.000986405,9.01E-05,5.17E-06];

n = 128;
k = 64;
fileName = ['RCU_and_MC_bound_n_',num2str(n),'_k_',num2str(k)];
load([fileName, '.mat'],'gamma_s', 'rcu_bounds','mc_bounds');





figure;
semilogy(EbN0_BCH_128_64_t3, FER_BCH_128_64_t3, '-o','Color','#7E2F8E','LineWidth',1.0, 'DisplayName','Extended BCH code, order-$3$ OSD'); hold on
semilogy(EbN0_LDPC_128_64_t4, FER_LDPC_128_64_t4, 'r-^','LineWidth',1.0 ,'DisplayName','LDPC code over GF($2^8$), order-$4$ OSD'); hold on
semilogy(Fabian_m_11_snr, Fabian_m_11, '-x','LineWidth',1.0,'DisplayName','TBCC with $\nu=11$, WAVA'); hold on
semilogy(EbN0_BCH_128_64_t4, FER_BCH_128_64_t4, 'b-s','LineWidth',1.0 ,'DisplayName','Extended BCH code, order-$4$ OSD'); hold on
semilogy(v_8_m_10_punctured_snr, v_8_m_10_punctured, '-d','Color','#A2142F','LineWidth',1.0,'DisplayName','$\nu=8, m=10$ punc. CRC-TBCC, SLVD'); hold on
semilogy(Fabian_m_14_snr, Fabian_m_14, '-v','LineWidth',1.0,'DisplayName','TBCC with $\nu=14$, WAVA'); hold on
semilogy(gamma_s(1:31), rcu_bounds(1:31), 'k-.','LineWidth',1.5,'DisplayName','RCU bound')
legend('Location','southwest');

grid on
xlabel('SNR $\gamma_s$ (dB)', 'interpreter', 'latex');
ylabel('Frame error rate','Interpreter','latex');
% title('(128, 64) Short Blocklength Code Comparison');
