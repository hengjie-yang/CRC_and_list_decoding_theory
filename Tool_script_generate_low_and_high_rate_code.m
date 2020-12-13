
clear all;
clc;

k = 4;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);

num_low_rate_code = 2^k;
num_high_rate_code = 2^(k+m);

code_generator = [13, 17];
trellis = poly2trellis(v+1, code_generator);

crc_gen_poly = '17';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high

Low_rate_code = [];
High_rate_code = [];

% generate low-rate code
for ii = 0:num_high_rate_code-1
    info_sequence = dec2bin(ii, k+m) - '0';
    [~, remd] = gfdeconv(fliplr(info_sequence), poly, 2); % degree from low to high
    info_sequence = [info_sequence, zeros(1, v)]; % append termination zeros.
    codeword = convenc(info_sequence, trellis);
    High_rate_code = [High_rate_code; codeword];
    if remd == 0
        Low_rate_code = [Low_rate_code; codeword];
    end
end
    