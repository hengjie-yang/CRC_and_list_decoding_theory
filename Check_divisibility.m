function res = Check_divisibility(k, m, poly)

% This script is to check whether the identified polynomial is divisible
% by X^(k+m)+1. This is a key requirement of generating cyclic codes.
%
% Input parameters:
%   1) k: the information length
%   2) m: the CRC polynomial degree
%   3)poly: the identified polynoial in char format in hex.
%
% Output parameters:
%   1) res: 1 if 'poly' is divisible by X^(k+m) + 1
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/26/21.
%


poly_binary = dec2bin(base2dec(poly, 16)) - '0'; % degree from highest to lowest
poly_binary = fliplr(poly_binary); % degree from lowest to highesgt
b = [1, zeros(1, k+m-1), 1];

[~, remd] = gfdeconv(b, poly_binary);
if all(remd == 0)
    res = 1;
    disp(['Yes! ', poly, ' is a proper cyclic generator polynomial.']);
else
    res = 0;
    disp(['No! ', poly, ' is NOT a cyclic generator polynomial.']);
end


