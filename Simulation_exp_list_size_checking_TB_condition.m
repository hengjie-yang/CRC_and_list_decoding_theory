% This script is to verify whether E[L] is approximately 2^v when the first
% path that meets the TB condition is identified by SLVD.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/09/21.
%


clear all;
clc;

% System parameters
k = 10;
v = 3;
code_generator = [13, 17];
omega = size(code_generator, 2);
trellis = poly2trellis(v+1, code_generator);

SNR_dBs = 3;

Psi = 10^5; % max. list size
target_num_undetected_errors = 50;


List_record = cell(length(SNR_dBs), 1);
for iter = 1:length(SNR_dBs)
    List_record{iter} = zeros(Psi+1, 3);
end
% the j-th column means the SLVD terminates at list rank = j.
% the (j, 1) entry represents the # correct decoding at list rank = j.
% the (j, 2) entry represents the # undetected errors at list rank = j.
% the (\Psi+1, 3) entry represents the # NACKs at list rank = \Psi + 1.

% Simulation part
for iter = 1:length(SNR_dBs)
    snr = 10^(SNR_dBs(iter)/10);
    
    num_undetected_errors = 0;
    num_trial = 0;
    while num_undetected_errors < target_num_undetected_errors
        num_trial = num_trial + 1;
        info_sequence = randi([0 1], 1, k);
        
        % Perform tail-biting encoding
        extended_info_sequence = [info_sequence(end-v+1:end), info_sequence, zeros(1, v)];
        extended_codeword = convenc(extended_info_sequence, trellis);
        codeword = extended_codeword(omega*v+1: end-omega*v);
        
        % BPSK modulation
        txSig = codeword;
        txSig(txSig == 0) = -1;
        
        % Send txSig over the AWGN channel
        rxSig = awgn(txSig, SNR_dBs(iter), 'measured');
        
        % soft SLVD
        [check_flag, correct_flag, L] = DBS_LVA_TBCC_Euclidean(trellis, rxSig, extended_info_sequence, Psi);
        
        disp(['SNR (dB): ', num2str(SNR_dBs(iter)), ' # trials: ',num2str(num_trial),...
            ' # errors: ', num2str(num_undetected_errors), ' check: ',num2str(check_flag)...
            ' correct: ',num2str(correct_flag), ' list_rank: ', num2str(L)]);
        
        % update results
        if check_flag == 0
            List_record{iter}(Psi+1, 3) = List_record{iter}(Psi+1, 3) + 1;
        elseif check_flag == 1 && correct_flag == 0
            List_record{iter}(L, 2) = List_record{iter}(L, 2) + 1;
            num_undetected_errors = num_undetected_errors + 1;
        elseif check_flag == 1 && correct_flag == 1
            List_record{iter}(L, 1) = List_record{iter}(L, 1) + 1;  
        end
    end
end


% Compute the average list rank
Ave_list_sizes = zeros(1, length(SNR_dBs));
numerator = 0;
dem = 0;
for iter = 1:length(SNR_dBs)
    for L = 1:Psi
        numerator = numerator + L*sum(List_record{iter}(L, :));
        dem = dem + sum(List_record{iter}(L, :));
    end
    numerator = numerator + Psi*sum(List_record{iter}(Psi+1, :));
    dem = dem + sum(List_record{iter}(Psi+1, :));
    Ave_list_sizes(iter) = numerator / dem;
end


% save the results
timestamp = datestr(now, 'mmddyy_HHMMSS');
path = './Simulation_results/';
save([path, timestamp, '_sim_exp_list_rank_TB_condition_check_TBCC_13_17_CRC_17_k_4.mat'],'SNR_dBs','List_record','Ave_list_sizes');



        
    


