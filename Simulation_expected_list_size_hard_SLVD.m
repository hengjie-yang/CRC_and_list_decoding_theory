% This script is to simulate the expected list size of CRC-aided list
% decoding of conv. code. 
%
% Here, we will quantize the output of the channel and then perform hard
% SLVD.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/02/20.

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

snr_dBs = -10:0.5:5;

Max_list_size = 2^(k+m) - 2^k + 1;
List_size_instances = cell(size(snr_dBs, 2), 1);
Ave_list_sizes = zeros(size(snr_dBs, 2), 1);

% Simulation part
parfor iter = 1:size(snr_dBs, 2)
    snr = 10^(snr_dBs(iter)/10);
%     alpha = qfunc(sqrt(snr)); % the crossover probability
    
    num_error = 0;
    num_erasure = 0;
    num_trial = 0;
    while num_error < 50 || num_trial < 1e4
        num_trial = num_trial + 1;
        info_sequence = randi([0, 1], 1, k);
        
        
        % add CRC behind the message
        msg_temp = fliplr(info_sequence); % degree from low to high
        [~, remd] = gfdeconv([zeros(1, m), msg_temp], poly, 2); 
        msg_temp = gfadd(remd, [zeros(1, m), msg_temp]);
        crc_coded_sequence = [zeros(1, v), msg_temp]; % append termination bits
        crc_coded_sequence = fliplr(crc_coded_sequence); %deg
        
        % convolutionally encode the crc-coded sequence
        codeword = convenc(crc_coded_sequence, trellis);
        
        
        % BPSK modulation
        txSig = codeword;
        txSig(txSig == 0) = -1;
        
        % Send txSig over the AWGN channel
        rxSig = awgn(txSig, snr_dBs(iter), 'measured');
        
        %quantization
        rxSig = double(rxSig > 0);
        noise_weight = sum(rxSig~=codeword);

%         % send codeword over the BSC
%         rxSig = bsc(codeword, alpha);
        
        % hard S-LVD
        [check_flag, correct_flag, path_rank, dec] = ...
            DBS_LVA_Hamming(trellis, rxSig, poly, crc_coded_sequence, Max_list_size);
        
        disp(['SNR (dB): ', num2str(snr_dBs(iter)), ' # trials: ',num2str(num_trial),...
            ' # errors: ', num2str(num_error), ' check: ',num2str(check_flag)...
            ' correct: ',num2str(correct_flag), ' list_rank: ', num2str(path_rank)]);
        
        if check_flag == 0
            num_erasure = num_erasure + 1;
        elseif check_flag == 1 && correct_flag == 0
            num_error = num_error + 1;
        end
        node = struct('snr', snr_dBs(iter), 'list_rank', path_rank,'noise_weight',noise_weight,'check_flag',check_flag, 'correct_flag', correct_flag);
        List_size_instances{iter} = [List_size_instances{iter}; node];
    end
end


% process the average list size
for ii = 1:size(snr_dBs, 2)
    num_trials = size(List_size_instances{ii}, 1);
    temp = zeros(num_trials, 1);
    for jj = 1:num_trials
        temp(jj) = List_size_instances{ii}(jj).list_rank;
    end
    Ave_list_sizes(ii) = mean(temp);
end


% save the results
timestamp = datestr(now, 'mmddyy_HHMMSS');
path = './Simulation_results/';
save([path, timestamp, '_sim_list_sizes_ZTCC_13_17_CRC_17_k_4.mat'],'snr_dBs','List_size_instances','Ave_list_sizes');



