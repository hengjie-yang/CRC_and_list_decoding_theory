% This script is to test the numerical integral of MATLAB.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   12/13/20.
%

fun = @(x)  exp(-x.^2).*log(x).^2;

q = integral(fun, 0, Inf);