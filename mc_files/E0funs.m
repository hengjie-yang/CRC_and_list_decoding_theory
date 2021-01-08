function [E0, E0p, E0pp] = E0funs(pX, X, sigma2, rho)

% The function is to compute the 0th, 1st and 2nd order derivatives of
% Gallarger's E0 function.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   01/05/21.
%


E0 = E0_integral(pX, X, sigma2, rho);

%%

E0pnum = integral(@(y) inner_funcE0p(y), -30, 30);

    function val1 = inner_funcE0p(yvals)
        val1 = 0;
        yvals_s = size(yvals);
        yvals = yvals(:);
        for ii = 1:length(X)
            val1 = val1 + 1/sqrt(2*pi*sigma2) * exp(-(yvals-X(ii)).^2/(2*sigma2)) * pX(ii) .* ...
                exp(-rho * inf_density(X(ii), yvals, pX, X, sigma2, 1/(1+rho))) .* ...
                inf_density(X(ii), yvals, pX, X, sigma2, 1/(1+rho));
        end 
        val1 = reshape(val1, yvals_s);
        val1(isnan(val1)) = 0;
    end

E0pdenom = exp(-E0_integral(pX, X, sigma2, rho));

E0p = E0pnum / E0pdenom;


%%

E0ppnum = -E0pdenom * (integral(@(y) inner_funcE0pp(y), -30, 30)) + E0pnum^2;

    function val1 = inner_funcE0pp(yvals)
        val1 = 0;
        yvals_s = size(yvals);
        yvals = yvals(:);
        for ii=1:length(X)
            val1 = val1 + 1/sqrt(2*pi*sigma2) * exp(-(yvals-X(ii)).^2/(2*sigma2)) * pX(ii) .* ...
                exp(-rho * inf_density(X(ii), yvals, pX, X, sigma2, 1/(1+rho))) .* ...
                inf_density(X(ii), yvals, pX, X, sigma2, 1/(1+rho)).^2; % .* ...
        end
        val1 = reshape(val1, yvals_s);
        val1(isnan(val1)) = 0;
    end

E0ppdenom = E0pdenom.^2;
E0pp = E0ppnum / E0ppdenom;



end