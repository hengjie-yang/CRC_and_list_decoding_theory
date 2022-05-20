% This script is to simulate the expected list size of CRC-aided list
% decoding of conv. code under soft S-LVD. 
%
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/16/20.
%

clear all;
clc;

% System parameters
k = 2;
crc_gen_poly = '5';
constraint_length = 3;
code_generator = [5, 7];
v = constraint_length - 1;
trellis = poly2trellis(constraint_length, code_generator);


poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly);
m = length(poly)-1; % CRC degree

% snr_dBs = -10:0.5:5;
snr_dBs = -6;

Max_list_size = 2^(k+m) - 2^k + 1;
List_size_instances = cell(size(snr_dBs, 2), 1);
Ave_list_sizes = zeros(size(snr_dBs, 2), 1);

% Simulation part
for iter = 1:size(snr_dBs, 2)
    snr = 10^(snr_dBs(iter)/10);
%     alpha = qfunc(sqrt(snr)); % the crossover probability
    
    num_error = 0;
    num_erasure = 0;
    num_trial = 0;
    while num_error < 50 || num_trial < 1e4
        num_trial = num_trial + 1;
%         info_sequence = randi([0, 1], 1, k);
        info_sequence = zeros(1, k);
        
        
        
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
%         txSig(txSig == 0) = -1;
        txSig = -2*txSig + 1;
        
        % Send txSig over the AWGN channel
%         rxSig = awgn(txSig, snr_dBs(iter), 'measured');

%         rxSig = [2.1	-0.4	2.4	0.1	0.9	-0.5	1.9	0.1	-0.5	-1.8	1.1	0.1]; % rank = 2
%         rxSig = [-0.951689632600121	-0.133605181704839	-1.43021005617041,...
%                   0.00440302387860680	-1.54683794757479	-0.603083968957352,...
%                   -0.676854447680759	-0.135398265135869	1.49628739592619,...
%                   0.407172739324260	2.19716534907104	0.474397973539210]; % rank = 9
%         rxSig = [-0.9, -0.1, -1.4, 0.1, -1.5, -0.6, -0.7, -0.1, 1.5, 0.4, 2.2, 0.5]; % rank = 9
%         rxSig = [-1.30482007278150	0.648492751951457	-0.650656445973346	2.17515306029286	-1.56179819115487	-1.04189799149172	-2.33402688863057	-0.0594514755026150	1.32204801756456	0.0655934269194083	1.21302739459454	-0.113683879375709];
%         rxSig = [-1.3, 0.6, -0.7, 2.2, -1.6, -1, -2.3, -0.1, 1.3, 0.1, 1.2, -0.1]; % rank = 11
%         rxSig = [-0.630866174337225	0.527491063244123	1.90086285246573	3.64463663116197	-4.81665743924459	0.194954902658770	-5.45760121923513	-2.19101873243034	-0.521704171491809	-0.417715700835329	0.719635440984192	-0.406006646133354]; % rank = 13
        rxSig = [-0.6, 0.5, 1.9, 3.6, -4.8, 0.2, -5.4, -2.2, -0.5, -0.4, 0.7, -0.4]; % rank = 13
        noise_norm = sum((rxSig - txSig).^2);
        
        
        % soft S-LVD
        [check_flag, correct_flag, path_rank, dec] = ...
            DBS_LVA_Euclidean(trellis, rxSig, poly, crc_coded_sequence, Max_list_size);
        
        disp(['SNR (dB): ', num2str(snr_dBs(iter)), ' # trials: ',num2str(num_trial),...
            ' # errors: ', num2str(num_error), ' check: ',num2str(check_flag)...
            ' correct: ',num2str(correct_flag), ' list_rank: ', num2str(path_rank)]);

        if path_rank > 11
            error('catched a large path rank!');
        end
        
        if check_flag == 0
            num_erasure = num_erasure + 1;
        elseif check_flag == 1 && correct_flag == 0
            num_error = num_error + 1;
        end
        node = struct('snr', snr_dBs(iter), 'list_rank', path_rank, 'noise_norm',noise_norm,...
            'check_flag',check_flag, 'correct_flag', correct_flag);
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
% save([path, timestamp, '_sim_list_sizes_soft_ZTCC_13_17_CRC_17_k_4.mat'],'snr_dBs','List_size_instances','Ave_list_sizes');



