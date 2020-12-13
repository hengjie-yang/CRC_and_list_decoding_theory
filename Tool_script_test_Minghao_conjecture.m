

path = './Simulation_results/';
load([path, '120320_134145_low_rate_code_spectra_ZTCC_13_17_CRC_17_k_4.mat'],...
    'Low_rate_code_spectra');


num_size = size(Low_rate_code_spectra, 1);

target_dist = 7;
Partial_sum_v2 = zeros(num_size, 1);

for ii = 1:num_size
    Partial_sum_v2(ii) = sum(Low_rate_code_spectra{ii}(1:target_dist+1));
end

ans = max(Partial_sum_v2)