function rho = Compute_covering_radius(constraint_len, code_generator, crc_gen_poly, k)

% This script is meant to find the covering radius of the low-rate code.
%
% Inputs:
%       1) constraint_len: the constraint length of the conv. encoder.
%       2) code_generator: the generator matrix of conv. code.
%       3) crc_gen_poly: the CRC gen. poly in octal in string format.
%       4) k: the information length before the CRC coding.
%
% Outputs:
%       1) rho: a scalar denoting the covering radius of the low-rate code.
%
% Algorithm: use bi-section search to find the covering radius.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/13/20.
%

omega = size(code_generator, 2);
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly);
m = size(poly, 2)-1; % CRC gen. poly. degree
v = constraint_len - 1;
n = omega*(k+m+v);
trellis = poly2trellis(constraint_len, code_generator);


% Step 1: pre-compute all low-rate conv. codewords
Low_rate_code = [];
num_info_sequence = 2^k;
for ii = 0:num_info_sequence-1
    info_sequence = dec2bin(ii, k) - '0';
    
    % add CRC behind the message
    msg_temp = fliplr(info_sequence); % degree from low to high
    [~, remd] = gfdeconv([zeros(1, m), msg_temp], poly, 2); 
    msg_temp = gfadd(remd, [zeros(1, m), msg_temp]);
    crc_coded_sequence = [zeros(1, v), msg_temp]; % append termination bits
    crc_coded_sequence = fliplr(crc_coded_sequence); %degree from high to low
    
    
    % convolutionally encode the crc-coded sequence
    codeword = convenc(crc_coded_sequence, trellis);
    Low_rate_code = [Low_rate_code; codeword];
end


% Step 2: pre-compute all sense words
num_sensewords = 2^n;
Sensewords = dec2bin(0:num_sensewords-1, n) - '0';

    
    

% Step 3: bi-section search
low = 0;
high = n;
rho = -1;
iter = 0;
while(low < high)
    iter = iter + 1;
    mid = low + floor((high - low) / 2);
    disp(['iter: ', num2str(iter), ' low: ',num2str(low), ' high: ',num2str(high)]);
    % check if this 'mid' point meets the definition of covering radius
    ok = 1;
    for ii = 1:num_sensewords
        temp = n;
        for jj = 1:num_info_sequence
            temp = min(temp, sum(Sensewords(ii, :)~=Low_rate_code(jj,:))); % check the closest dist.
        end
        if temp > mid 
            ok = 0;
            break
        end
    end
    
    if ok == 1 % mid is indeed a possible radius
        high = mid;
    else
        low = mid + 1;
    end
end

rho = low;

        
    
        






