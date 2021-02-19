function low_rate_spectrum = Compute_low_rate_spectrum_TBCC(constraint_length, code_generator, k_high, crc_poly)

% This script computes the low-rate distance spectrum of a given TBCC.
%
%   Inputs:
%       1) constraint_length: a scalar denoting the constraint length.
%       2) code_generator: a matrix describing the TBCC generator.
%       3) k_high: a scalar denoting the information blocklength to conv.
%           encoder.
%       5) crc_poly: the CRC generator polynomial in binary, degree from
%           high to low.
%       6) error_vector: a binary row vector with length equal to
%           blocklength.
%
%   Outputs:
%       1) low_rate_spectrum: an (n+1)*1 column vector indicating the
%       low-rate distance spectrum by using crc_poly
%
%   Algorithm: the idea is to enumerate each codeword and check if they can
%   pass the CRC check
%
%   Caution: the function only works for rate-1/2 conv. encoder.
%   
%   Written by Hengjie Yang (hengjie.yang@ucla.edu) 02/18/21.
%

omega = size(code_generator, 2);
n = omega*k_high;
v = constraint_length-1;
low_rate_spectrum = zeros(n+1, 1);

trellis = poly2trellis(constraint_length, code_generator);

num_info_sequence = 2^(k_high);

for ii = 0:num_info_sequence-1
    info_sequence = dec2bin(ii, k_high) - '0'; % degree from low to high
    [~, remd] = gfdeconv(fliplr(info_sequence), fliplr(crc_poly), 2); % degree from low to high
    
    if remd == 0
        extended_info_sequence = [info_sequence(end-v+1: end), info_sequence];
        extended_codeword = convenc(extended_info_sequence, trellis);
        codeword = extended_codeword(2*v+1:end);
        
        weight = sum(codeword);
        low_rate_spectrum(weight+1) = low_rate_spectrum(weight+1) + 1;
    end
end
    









