% This script is to test the numerical integral of MATLAB.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   12/13/20.
%

% test density function f(w) in 12-18-20 slides.


% n = 20;
% 
% func = @(w) 2.*pi.^(n/2).*w.^(n-1)./gamma(n/2).*(1/(2.*pi).^(n/2)).*exp(-w.^2/2);
% % func = @(w) (1/(2.*pi).^(n/2)).*exp(-w.^2/2);
% 
% q = integral(func, 0, Inf)


[rhop, Pe] = fminbnd(@fun, 0, 10^6);
rhop
Pe = -Pe

function y = fun(x)
    y = (x-0.2)^2+1;
end