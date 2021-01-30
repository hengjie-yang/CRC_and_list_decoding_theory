% This script is to simulate the conditional expected list size of CRC-aided list
% decoding of conv. code under soft S-LVD assuming that the noise ball is
% center at the origin, rather than the transmitted point.
%
% We would like to see the actual E[L|W = w].
%
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   01/29/21.
%

clear all;
clc;

% System parameters
k = 4;
crc_gen_poly = '17';
constraint_length = 4;
code_generator = [13, 17];
v = constraint_length - 1;
trellis = poly2trellis(constraint_length, code_generator);


poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly);
m = length(poly)-1; % CRC degree

delta = 0.5;
etas = delta:delta:100; % the normalized factor w/A
snr_dB = 1;

Max_list_size = 2^(k+m) - 2^k + 1;
Cond_list_size_instances = cell(size(etas, 2), 1);
Ave_cond_list_sizes = zeros(size(etas, 2), 1);

% Simulation part
parfor iter = 1:size(etas, 2)
    w = etas(iter)*1; % the target noise vector norm, where A = 1
%     alpha = qfunc(sqrt(snr)); % the crossover probability
    
    num_error = 0;
    num_erasure = 0;
    num_trial = 0;
    while num_trial < 1e3
        num_trial = num_trial + 1;
        info_sequence = randi([0, 1], 1, k);
        
        
        % add CRC behind the message
        msg_temp = fliplr(info_sequence); % degree from low to high
        [~, remd] = gfdeconv([zeros(1, m), msg_temp], poly, 2); 
        msg_temp = gfadd(remd, [zeros(1, m), msg_temp]);
        crc_coded_sequence = [zeros(1, v), msg_temp]; % append termination bits
        crc_coded_sequence = fliplr(crc_coded_sequence); %degree from high to low
        
        % convolutionally encode the crc-coded sequence
        codeword = convenc(crc_coded_sequence, trellis);
        
        
        % BPSK modulation
        txSig = codeword;
        txSig(txSig == 0) = -1;
        
        % Send txSig over the AWGN channel
        rxSig = awgn(txSig, snr_dB, 'measured');
        
        % Project noise point to a norm-w point
        noise_vec = rxSig - txSig;
        noise_norm = norm(noise_vec);
        projected_noise_vec = noise_vec/noise_norm*w;
        
        new_rxSig = txSig + projected_noise_vec;
        
        
        % soft S-LVD of the txSig + projected_noise_vec
        [check_flag, correct_flag, path_rank, dec] = ...
            DBS_LVA_Euclidean(trellis, new_rxSig, poly, crc_coded_sequence, Max_list_size);
        
        disp(['eta: ', num2str(etas(iter)), ' # trials: ',num2str(num_trial),...
            ' # errors: ', num2str(num_error), ' check: ',num2str(check_flag)...
            ' correct: ',num2str(correct_flag), ' list_rank: ', num2str(path_rank)]);
        
        if check_flag == 0
            num_erasure = num_erasure + 1;
        elseif check_flag == 1 && correct_flag == 0
            num_error = num_error + 1;
        end
        node = struct('eta', etas(iter), 'list_rank', path_rank,...
            'check_flag',check_flag, 'correct_flag', correct_flag);
        Cond_list_size_instances{iter} = [Cond_list_size_instances{iter}; node];
    end
end


% process the average list size
for ii = 1:size(etas, 2)
    num_trials = size(Cond_list_size_instances{ii}, 1);
    temp = zeros(num_trials, 1);
    for jj = 1:num_trials
        temp(jj) = Cond_list_size_instances{ii}(jj).list_rank;
    end
    Ave_cond_list_sizes(ii) = mean(temp);
end


% save the results
timestamp = datestr(now, 'mmddyy_HHMMSS');
path = './Simulation_results/';
save([path, timestamp, '_sim_cond_list_sizes_soft_ZTCC_13_17_CRC_17_k_4.mat'],'etas','Cond_list_size_instances','Ave_cond_list_sizes');


%% Plot the curve


% % figure;
% plot(etas, Ave_cond_list_sizes, '-+');hold on
% grid on
% xlabel('$\eta$','interpreter','latex');
% ylabel('Average list rank', 'interpreter','latex');
% title('ZTCC (13, 17), CRC (17), k=4');



