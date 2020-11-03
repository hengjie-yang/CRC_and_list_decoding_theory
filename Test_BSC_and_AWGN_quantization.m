% This script is to test whether adding a quantization will transform the
% AWGN channel into a BSC.


clear all;
clc;

snr_dBs = -1:0.5:4;

NumBits = 2000;

info_sequence = randi([0, 1], 1, NumBits);

BitErrorRate_AWGN = zeros(1, size(snr_dBs, 2));
BitErrorRate_BSC = zeros(1, size(snr_dBs, 2));

for iter = 1:size(snr_dBs, 2)
    snr = 10^(snr_dBs(iter)/10); 
    alpha = qfunc(sqrt(snr));
    rxSig = bsc(info_sequence, alpha);
    BitErrorRate_BSC(iter) = sum(rxSig~=info_sequence)/NumBits;
end


for iter = 1:size(snr_dBs, 2)
    txSig = info_sequence;
    txSig(txSig == 0) = -10;
    txSig(txSig == 1) = 10;
    
    rxSig = awgn(txSig, snr_dBs(iter), 'measured');
    rxSig = double(rxSig > 0);

    BitErrorRate_AWGN(iter) = sum(rxSig~=info_sequence)/NumBits;
end

[BitErrorRate_AWGN', BitErrorRate_BSC']

