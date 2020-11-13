function Compute_brute_force_bound(constraint_length, code_generator, crc_gen_poly, k)

% This function is to compute the brute-force upper bound on s^*(z), where
% the brute-force upper bound is equal to the partial sum of # conv.
% codewords up to the smallest undetected distance for error vector z.
%
% Inputs:
%   1) constraint_length: a scalar denoting the constraint length of conv.
%   encoder.
%   2) code_generator: a row vector denoting the conv. encoder.
%   3) crc_gen_poly: the CRC gen. poly. in octal in string format
%   4) k: the information length before CRC coding.
%
% Outputs:
%   1) Upper_bound_instances: a column vector of length (n+1) in which the i-th entrty
%   stores a vector of upper bounds on each s^*(z) where z has weight equal to i.
%   2) Relative_distance_spectra: a cell vector of length 2^n in which the i-th entry
%   stores the partial relative distance spectrum up to undetected
%   distance for the i-th error vector.
%
% Remarks:
%   1) This function only works for very small examples, i.e., blocklength
%   n <= 25.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/13/20.
%

% Basic parameters
omega = size(code_generator, 2);
v = constraint_length - 1;
trellis = poly2trellis(constraint_length, code_generator);

poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high
m = size(poly, 2) - 1; % the CRC gen. poly. degree

n = omega*(k+m+v); % the blocklength of a zero-terminated conv. codeword
num_noise = 2^n;

Upper_bound_instances = cell(n+1, 1);
Relative_distance_spectra = cell(num_noise, 1);




% Compute the brute-force upper bound
tic
disp('Step 1: Compute relative distance spectra for all noise vectors.');
for ii = 0:num_noise-1
    
    % generate the noise vector
    rxSig = dec2bin(ii, n) - '0';
    w = sum(rxSig);
    
    % compute the relative distance spectrum of ZTCC and CRC-ZTCC
%     weight_node_high_rate = Compute_relative_distance_spectrum(constraint_len, code_generator, k+m+(constraint_len-1), rxSig);
%     distance_spectrum_high_rate = weight_node_high_rate.weight_spectrum;
%     
%     weight_node_low_rate = Compute_relative_distance_spectrum(constraint_len_overall, code_generator_overall, k+(constraint_len_overall-1), rxSig);
%     distance_spectrum_low_rate = weight_node_low_rate.weight_spectrum;

    % use brute-force version to compute distance spectra
    weight_node = Compute_relative_distance_spectrum_brute_force(constraint_length, code_generator, k+m, poly, rxSig);
    distance_spectrum_high_rate = weight_node.distance_spectrum_high_rate;
    distance_spectrum_low_rate = weight_node.distance_spectrum_low_rate;
    
    % Find the partial sum of ZTCCs up to undetected distance
    undetected_dist = find(distance_spectrum_low_rate > 0);
    undetected_dist = undetected_dist(1); % take the smallest value
    
    
    % decode based on the noise vector
%     [check_flag, correct_flag, path_rank, dec] = ...
%             DBS_LVA_Hamming(trellis, rxSig, poly, crc_coded_sequence, Max_list_size);
    
    % Compute the upper bound on s^*(z)
    Relative_distance_spectra{ii+1} = distance_spectrum_high_rate(1:undetected_dist);
    val = sum(Relative_distance_spectra{ii+1});
    Upper_bound_instances{w+1} = [Upper_bound_instances{w+1}; val];

    
    if mod(ii, 1000) == 0
        timeVal = tic;
        disp(['Current instance: ',num2str(ii),'/ ',num2str(num_noise),...
            ' upper bound: ',num2str(val), ' Time spent: ', num2str(toc)]);
    end 
end
toc


% save the results
timestamp = datestr(now, 'mmddyy_HHMMSS');
path = './Simulation_results/';

code_string = '';
for iter = 1:size(code_generator, 2)
    code_string = [code_string, num2str(code_generator(iter)), '_'];
end

save([path, timestamp, '_brute_force_bound_ZTCC_', code_string,...
    'CRC_',crc_gen_poly,'_k_',num2str(k), '.mat'],...
    'Upper_bound_instances','Relative_distance_spectra');








