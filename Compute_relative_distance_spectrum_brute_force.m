function weight_node = Compute_relative_distance_spectrum_brute_force(constraint_length, code_generator, k_high, crc_poly, error_vector)

%   This function computes the distance spectrum relative to "error_vector".
%
%   Inputs:
%       1) constraint_length: a scalar denoting the constraint length.
%       2) code_generator: a matrix describing the CC generator.
%       3) k_high: a scalar denoting the information blocklength to conv. generator
%       5) crc_poly: the CRC generator polynomial in binary, degree from
%       low to high.
%       6) error_vector: a binary row vector with length equal to
%       blocklength.
%
%   Outputs:
%       1) weight_node: cosisted of the weight_spectrum_high_rate and
%       weight_spectrum_low_rate. High rates correspond to weight spectrum
%       of dimension k_high whereas low rates correspond to dimension
%       k_high - m, where m is the CRC gen. poly. degree.
%
%   Algorithm: the idea is to enumerate each codeword and check if they can
%   pass the CRC check
%
%   Caution: the function only works for rate-1/2 conv. encoder.
%   
%   Written by Hengjie Yang (hengjie.yang@ucla.edu) 11/06/20.
%

omega =size(code_generator, 2);
n = omega*(k_high + constraint_length - 1);

distance_spectrum_high_rate = zeros(n+1, 1);
distance_spectrum_low_rate = zeros(n+1, 1);


trellis = poly2trellis(constraint_length, code_generator);

num_info_sequence = 2^(k_high);

for ii = 0: num_info_sequence-1
    info_sequence = dec2bin(ii, k_high) - '0'; % This is the info_sequence to the conv. encoder!
    [~, remd] = gfdeconv(fliplr(info_sequence), crc_poly, 2); % degree from low to high
    info_sequence = [info_sequence, zeros(1, constraint_length-1)]; % append termination zeros.
   
    codeword = convenc(info_sequence, trellis);
    distance = sum(codeword ~= error_vector); 
    distance_spectrum_high_rate(distance+1) = distance_spectrum_high_rate(distance+1) + 1;
    
    if remd == 0
        distance_spectrum_low_rate(distance+1) = distance_spectrum_low_rate(distance+1) + 1;
    end
end



weight_node.distance_spectrum_low_rate = distance_spectrum_low_rate;
weight_node.distance_spectrum_high_rate = distance_spectrum_high_rate;


    
    
    


