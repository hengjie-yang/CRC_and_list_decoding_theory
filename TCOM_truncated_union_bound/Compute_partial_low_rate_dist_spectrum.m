function weight_node = Compute_partial_low_rate_dist_spectrum(constraint_length, code_generator, CRC_poly, k, d_tilde)

% This function is to compute the partial low-rate code spectrum up to d_tilde
% of the given CRC polynomial for the ZTCC.
%
% Input parameters:
%   1) constraint_length: a scalar denoting the constraint length of CC
%   2) code_generator: a row vector in octal denoting the CC generator polynomial
%   3) CRC polynomial: a char type string, e.g., '103'
%   4) k: a scalar denoting the information length before CRC coding
%   5) d_tilde: a scalar denoting the maximum distance of interest (d_tilde > d_free)
%
% Output parameters: weight_node consisted of following members
%   1) weight_spectrum: a d_tilde by 1 column vector
%
% Remarks:
%   1) The function relies on the pre-generated error events
% 
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/02/21.
%

% clear all;
% clc;

% Step 1: Load file
weight_node = [];
poly = dec2bin(base2dec(CRC_poly, 8))-'0';
m = length(poly) - 1;
v = constraint_length - 1;


fileName = ['error_event_',num2str(constraint_length),'_',num2str(code_generator),'_',num2str(d_tilde),'.mat'];

if ~exist(fileName, 'file')
    disp(['Error: the file ',fileName, ' does not exist!']);
    return
end

load(fileName, 'error_event','error_event_length');


% Step 2: Identify the free distance and determine the type of error events
trellis = poly2trellis(constraint_length, code_generator);
spec = distspec(trellis);
d_free = spec.dfree;

Undetected_spectrum = zeros(d_tilde, 1); % the d-th entry means # codewords at distance d, d = 1,2,...

u = floor(d_tilde/d_free); % the number of types to be considered


if u >= 1 % we need to consider single error events
    disp(['Step 1: Compute the single error events']);
    for d = d_free:d_tilde
        if ~isempty(error_event{d})
            Undetected_spectrum(d) = Undetected_spectrum(d) + ...
                check_divisible_by_distance(error_event, error_event_length, CRC_poly, d, k+m+v);
        end
    end
end

if u >= 2 % we also need to consider double error events
    disp(['Step 2: Compute the double error events']);
    for d = 2*d_free:d_tilde
        Undetected_spectrum(d) = Undetected_spectrum(d) + ...
            check_double_error_divisible_by_distance(error_event, error_event_length, CRC_poly, d, d_free, d_tilde, k+m+v);
    end
end


% Step 3: Save results
disp('Save results');
weight_node.weight_spectrum = Undetected_spectrum;

fileName = ['Partial_low_rate_spectrum_ZTCC_',num2str(code_generator(1)),'_',num2str(code_generator(2)),'_','CRC_',CRC_poly,'_k_',num2str(k),'_d_tilde_',num2str(d_tilde),'.mat'];
save(fileName, 'weight_node');
    




end