% Test Minghao's example 02/09/21.

clear all;
clc;

% System parameters
k = 4;
n = 7;
num_low_rate = 2^k;
num_high_rate = 2^n;

High_rate_codewords = zeros(num_high_rate, n);
Low_rate_code_identifier = zeros(num_high_rate, 1);
Low_rate_codebook = zeros(num_low_rate, 1);



% step 1, generate all high-rate codewords and low-rate codewords;
low_rate_idx = 1;
for ii = 0:num_high_rate-1
    codeword = dec2bin(ii, n) - '0';
    High_rate_codewords(ii+1, :) = codeword;
    if High_rate_codewords(ii+1, 2) == 1 && High_rate_codewords(ii+1, 4) == 1 && High_rate_codewords(ii+1, 6) == 1
        Low_rate_code_identifier(ii+1) = 1;
        Low_rate_codebook(low_rate_idx) = ii+1;
        low_rate_idx = low_rate_idx + 1;
    end
end

High_rate_points = -2*High_rate_codewords+1;



% step 2: simulate E[L|W = \eta] vs. \eta

delta = 0.5;
etas = 0:delta:50;
snr_dB = 1;

Max_list_size = num_high_rate - num_low_rate + 1;
Cond_list_size_instances = cell(size(etas, 2), 1);
Ave_cond_list_sizes = zeros(size(etas, 2), 1);

parfor iter = 1:size(etas, 2)
    w = etas(iter)*1;
    
    num_error = 0;
    num_trial = 0;
    while num_trial < 1e4
        num_trial = num_trial + 1;
        info_index = randi(num_low_rate);
        high_rate_idx = Low_rate_codebook(info_index);
        codeword = High_rate_codewords(high_rate_idx, :);
        
        % BPSK modulation
        txSig = codeword;
        txSig = -2*txSig + 1; % mapping rule different from the classical script!
        
        % Send txSig over the AWGN channel
        rxSig = awgn(txSig, snr_dB, 'measured');
        
        % Project noise point to a norm-w point
        noise_vec = rxSig - txSig;
        noise_norm = norm(noise_vec);
        projected_noise_vec = noise_vec/noise_norm*w;
        
        new_rxSig = txSig + projected_noise_vec;
        
        % Soft S-LVD of the txSig + projected noise vector
        [correct_flag, path_rank] = soft_SLVD(High_rate_points, Low_rate_code_identifier, new_rxSig, high_rate_idx);
        
        disp(['eta: ', num2str(etas(iter)), ' # trials: ',num2str(num_trial),...
            ' # errors: ', num2str(num_error), ' correct: ',num2str(correct_flag),...
            ' list_rank: ', num2str(path_rank)]);
        
        
        if correct_flag == 0
            num_error = num_error + 1;
        end
        
        node = struct('eta', etas(iter), 'list_rank', path_rank, 'correct_flag', correct_flag);
        Cond_list_size_instances{iter} = [Cond_list_size_instances{iter}; node];
    end
end


% step 3: compute the average list size
for ii = 1:size(etas, 2)
    num_trials = size(Cond_list_size_instances{ii}, 1);
    temp = zeros(num_trials, 1);
    for jj = 1:num_trials
        temp(jj) = Cond_list_size_instances{ii}(jj).list_rank;
    end
    Ave_cond_list_sizes(ii) = mean(temp);
end



figure;
plot(etas, Ave_cond_list_sizes,'-+');
grid on
xlabel('$\eta$','interpreter','latex');
ylabel('Average list rank');



function [correct_flag, path_rank] = soft_SLVD(High_rate_points, Low_rate_identifier, rxSig, high_rate_idx)

correct_flag = 0;

distances = sum((rxSig - High_rate_points).^2, 2);
[~, I] = sort(distances);
closest_low_rate_idx = find(Low_rate_identifier(I) == 1);
path_rank = closest_low_rate_idx(1);

if I(path_rank) == high_rate_idx
    correct_flag = 1;
end


end



   







