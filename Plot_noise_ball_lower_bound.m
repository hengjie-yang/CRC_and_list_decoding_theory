% 
% This script is to plot the lower bound of P(L=1, correct | 0 is sent)
%
% The lower bound depends on SNR, d_min of ZTCC, and blocklength n.
%
% Let us consider the example in 2018 Globalcom paper, where n = 262;
% ZTCC (13,17), d_min = 6.


clear all; clc;
set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',14,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

d_min = 6;
n = 2*(64+6);
snr_dB = 1:0.2:14;

loose_lower_bound  = zeros(1,size(snr_dB, 2));

for iter = 1:size(snr_dB, 2)
    snr = 10^(snr_dB(iter)/10);
    loose_lower_bound(iter) = (1 - qfunc(sqrt(1*snr)))^n;
end
    

lower_bound = zeros(1,size(snr_dB, 2));

if mod(n,2)==1
    t = (n-1)/2;
    for iter = 1:size(snr_dB, 2)
        snr = 10^(snr_dB(iter)/10);
        kernel = d_min*snr;
        res = sqrt(d_min*snr);
        temp = 0;
        for ii = 1:t
            temp = temp + res;
            res = res * kernel/(2*ii + 1);
        end
        temp = sqrt(2/pi)*temp;
        lower_bound(iter) = 1 - (1 + temp)*exp(-d_min*snr/2);
    end
else
    t = n/2;
    for iter = 1:size(snr_dB, 2)
        snr = 10^(snr_dB(iter)/10);
        kernel = d_min*snr;
        res = 1/2*kernel;
        temp = 0;
        for ii = 1:t-1
            temp = temp + res;
            res = res * kernel/(2*ii + 2);
        end
        lower_bound(iter) = 1 - (1+temp)*exp(-d_min*snr/2);
    end
end

semilogy(snr_dB, loose_lower_bound,'--'); grid on, hold on
semilogy(snr_dB, lower_bound,'-.'); 
legend('Semi-infinite hypercube','Noise ball');
xlabel("SNR (dB)");
ylabel("Probability");
title("Lower bound of P(L=1,correct | 0 was sent)");

