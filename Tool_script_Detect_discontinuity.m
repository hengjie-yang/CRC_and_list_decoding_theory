% This script is to identify the continuity point of direction vectors 
% (i.e., class representatives).


path = './Simulation_results/';
load([path, '120220_164411_equivalence_class_by_weight_ZTCC_13_17_CRC_17_k_4.mat'],...
    'Direction_vectors');


temp = bi2de(fliplr(Direction_vectors{2}));
discontinuity_points = [];

for ii = 1:size(temp, 1)
    if ii == size(temp, 1)
        discontinuity_points = [discontinuity_points; ii];
    elseif temp(ii)+1 ~= temp(ii+1)
        discontinuity_points = [discontinuity_points; ii];
    end
end


discontinuity_points