% This script is to plot parameters of interest for equivalence classes by
% weight.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   12/02/20.
%

path = './Simulation_results/';
load([path, '120220_164411_equivalence_class_by_weight_ZTCC_13_17_CRC_17_k_4.mat'],...
    'Direction_vectors','Equivalence_classes','Relative_dist_spectra_high_rate_code');


% Plot brute-force upper bound
k = 4;
m = 3;
v = 3;
omega = 2;
n = omega*(k+m+v);
rho = 9;
weights = 0:rho;

max_brute_force_upper_bound = zeros(1, rho+1);

for w = 0:rho
    temp = sum(Relative_dist_spectra_high_rate_code{w+1}(:,1:w+1),2)
    max_brute_force_upper_bound(w+1) = max(temp);
end

figure;
plot(weights, max_brute_force_upper_bound,'+-');
grid on
xlabel('noise weight');
ylabel('List size');
    










