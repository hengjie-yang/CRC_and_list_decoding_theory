% This script is to verify whether the hypothetical model will yield the
% critical \eta and whether the value coincides with reality.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   02/05/21.
%



% The maximum \eta at which E[L|W = \eta] = 1.
% Model, we think \eta = \sqrt{n}*sin(\theta), where \theta is the
% half-angle of the list rank 1 Voronoi region of the low-rate codeword. We
% model this region as a perfect circular cone.

delta = 0.01;
thetas = 0:delta:pi/2;

k = 32;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);

min_gap = 1;
target_prob = 1/2^(k+m);
opt_theta = -1;

for iter = 1:size(thetas, 2)
    theta = thetas(iter);
    val = integral(@(x) sin(x).^(n-2), 0, theta);
    ratio = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
    cur_gap = abs(ratio - target_prob);
    if cur_gap < min_gap
        min_gap = cur_gap;
        opt_theta = theta;
    end
end

opt_eta = sqrt(n)*sin(opt_theta)


%% Other computations


k = 4;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);

opt_eta = 3.1;
opt_theta = asin(opt_eta/sqrt(n));
val = integral(@(x) sin(x).^(n-2), 0, opt_theta);
ratio = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);

log2(ratio);


%% Solve for \eta_h from approximation


k = 32;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);

delta = 0.01;
etas = 0:delta:40;




% Compute the approximation curve
alpha = opt_theta;
convergence_val = 8;
Approx_cond_list_sizes = zeros(size(etas));

target_val = convergence_val - 1;

min_gap = 100;

for iter = 1: size(etas, 2)
    eta = etas(iter);
    if eta < sqrt(n)*sin(alpha)
        Approx_cond_list_sizes(iter) = 1;
    elseif eta >= sqrt(n)*sin(alpha) && eta < sqrt(n)
        beta_1 = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
        beta_2 = beta_1 - 2*alpha;
        val = integral(@(x) sin(x).^(n-2), 0, beta_1);
        prob_1 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
        val = integral(@(x) sin(x).^(n-2), 0, beta_2);
        prob_2 = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
        Approx_cond_list_sizes(iter) = convergence_val - (convergence_val - 1)*(prob_1 + prob_2);
    else
        beta = pi/2 + alpha - asin(sqrt(eta^2 - n*sin(alpha)^2)/eta);
        val = integral(@(x) sin(x).^(n-2), 0, beta);
        prob = gamma(n/2)*val/sqrt(pi)/gamma((n-1)/2);
        Approx_cond_list_sizes(iter) = convergence_val - (convergence_val - 1)*prob;
    end
    
    cur_gap = abs(Approx_cond_list_sizes(iter) - target_val);
    if cur_gap < min_gap
        min_gap = cur_gap;
        eta_h = eta;
    end
end

eta_h




        