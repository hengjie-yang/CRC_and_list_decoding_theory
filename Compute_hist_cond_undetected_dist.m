function [hist_udists, nontrivial_udist_instances] = Compute_hist_cond_undetected_dist(path, file_name, n)

% This function computes the histogram of undetected distances given W = w. 
% The function relies on the data set pre-computed from
% "Compute_brute_force_bound". The function also computes the nontrivial
% undetected instances as explained below.
%
% Inputs:
%   1) path: the brute-force upper bound file path.
%   2) file_name: the brute-force upper bound file name in string format.
%   3) noise_weight: the target noise weight.
%   3) n: blocklength.
%
% Outputs:
%   1) hist_udists: a size (n+1)*(n+1) with the (w+1)-th row denoting the
%       histogram of relative undected distance at noise weight W = w.
%
%   2) nontrivial_udist_instances: a (n+1)*1 cell, in which the (w+1)-th cell 
%       stores a vector of a variable length, the length denotes #
%       codewords with nontrivial undetected distance. The i-th entry of
%       the vector stores A_{w_H(z), z}.
%
%       We say a noise vector 'z' has a nontrivial undetected distance if
%       it satisfies that u(z) = w_H(z) and A_{u(z), z} > 1, where 
%       A_{d, z} denotes the # codewords that are distance d away from 'z'.
%
% Remark:
%   1) This function can only work with small blocklength n.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/16/20.
%



load([path, file_name],'Relative_distance_spectra');

num_noise = 2^n;


hist_udists = zeros(n+1, n+1);
nontrivial_udist_instances = cell(n+1, 1);

for ii = 0:(num_noise - 1)
    noise_sequence = dec2bin(ii, n) - '0';
    w = sum(noise_sequence);
    udist = size(Relative_distance_spectra{ii+1}, 1) - 1;
    hist_udists(w+1, udist+1) = hist_udists(w+1, udist+1) + 1;
    
    
    if udist == w && Relative_distance_spectra{ii+1}(udist+1) > 1
        nontrivial_udist_instances{w+1} = ...
            [nontrivial_udist_instances{w+1}; Relative_distance_spectra{ii+1}(udist+1)];
    end
        
end

    
    








