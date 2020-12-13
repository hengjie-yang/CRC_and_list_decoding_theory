% This script is to identify all equivalence classes and its corresponding
% relative distance spectrum.
%
% Current research suggests that when noise weight w is large, the
% overestimate resulted from the fact that a large-weight noise vector
% relative to all-zero codeword is equivalent to a small-weight noise
% vector relative to the closest non-zero low-rate codeword. This
% observation motivates the idea of finding equivalence classes of all 2^n
% noise vectors. See 12-04-20 slides for more information.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/27/20.
%


clear all;
clc;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% Input parameters
k = 4; % the information length
m = 3; % the CRC degree
v = 3; % the # memory elements
omega = 2;
n = omega*(k + m + v); % the blocklength
weights = 0:n;
rho = 9; % the true covering radius
% d_crc = 8; % the minimum distance of the low-rate code.


crc_gen_poly = '11';
poly = dec2base(base2dec(crc_gen_poly, 8), 2) - '0';
poly = fliplr(poly); % degree from low to high
crc_coded_sequence = zeros(1, k+m+v);


constraint_len = v+1;
code_generator = [13, 17];
trellis = poly2trellis(constraint_len, code_generator);

num_classes = 2^(n-k);
Equivalence_classes = cell(num_classes, 1);
Low_rate_code = [];


% Step 1: construct the low-rate code C'.
disp('Step 1: construct the low-rate code.');
num_low_rate_code = 2^k;
for ii = 0:num_low_rate_code-1
    info_sequence = dec2bin(ii, k) - '0';
    

    % add CRC behind the message
    msg_temp = fliplr(info_sequence); % degree from low to high
    [~, remd] = gfdeconv([zeros(1, m), msg_temp], poly, 2); 
    msg_temp = gfadd(remd, [zeros(1, m), msg_temp]);
    crc_coded_sequence = [zeros(1, v), msg_temp]; % append termination bits
    crc_coded_sequence = fliplr(crc_coded_sequence); %degree from high to low

    % convolutionally encode the crc-coded sequence
    codeword = convenc(crc_coded_sequence, trellis);
    Low_rate_code = [Low_rate_code; codeword];
end



%% Enumerate in lexicographical order
% Step 2: search for all equivalence classes.
% disp('Step 2: search for all equivalence classes by lexicographical order.');
% Direction_vectors = [];
% Relative_dist_spectra_high_rate_code = [];
% HashTable = containers.Map;
% 
% temp = 0:rho;
% max_idx = 2^n-1;
% cnt = 0;
% 
% tic
% for ii = 0:max_idx
%     if cnt == num_classes
%         disp("Find all classes. Break triggered.");
%         break
%     end
%     direction_vec = dec2bin(ii, n) - '0';
%     key_val = binary_to_hex(direction_vec);
%     if ~isKey(HashTable, key_val)
%         cnt = cnt + 1;
%         Direction_vectors = [Direction_vectors; direction_vec];
%         if mod(cnt, 1000) == 0
%             disp(['Current class index: ',num2str(cnt), ', total index: ',num2str(num_classes), ' time elapsed: ',num2str(toc)]);
%         end
%         
%         weight_node = Compute_relative_distance_spectrum_brute_force(v+1, code_generator, k+m, poly, direction_vec);
%         distance_spectrum_high_rate = weight_node.distance_spectrum_high_rate';
%         Relative_dist_spectra_high_rate_code = [Relative_dist_spectra_high_rate_code; distance_spectrum_high_rate];
%         
%         for jj = 1:size(Low_rate_code, 1)
%             codeword = Low_rate_code(jj, :);
%             new_element = gfadd(codeword, direction_vec, 2);
%             key_val = binary_to_hex(new_element);
%             if ~isKey(HashTable, key_val)
%                 HashTable(key_val) = 1;
%                 Equivalence_classes{cnt} = [Equivalence_classes{cnt}; new_element];
%             else
%                 error('Duplicate elements found!');
%             end
%         end
%     end
% end  
% 
% 
% 
% % Step 4: save the result
% code_string = '';
% for iter = 1:size(code_generator,2)
%     if iter < size(code_generator,2)
%         code_string = [code_string, num2str(code_generator(iter)), '_'];
%     else
%         code_string = [code_string, num2str(code_generator(iter))];
%     end
% end
% timestamp = datestr(now, 'mmddyy_HHMMSS');
% path = './Simulation_results/';
% save([path, timestamp, '_equivalence_class_by_lex_ZTCC_', code_string, '_CRC_',...
%     crc_gen_poly,'_k_',num2str(k),'.mat'],'Direction_vectors',...
%     'Relative_dist_spectra_high_rate_code','Equivalence_classes');


%% Search all equivalence classes by increasing noise weights
disp('Step 3: Search all equivalence classes by increasing noise weights.');

Equivalence_classes = cell(n+1, 1);
Direction_vectors = cell(n+1, 1);
Relative_dist_spectra_high_rate_code = cell(n+1, 1);
HashTable = containers.Map;
cnt = 0;
ok = 0;

tic
for w = 0:n
    num_vectors = nchoosek(n, n-w);
    zero_idx = nchoosek(1:n, n-w);  
    % generate weight-w lexicographically ordered binary vector
    for ii = 1:size(zero_idx, 1)
        if cnt == num_classes
            disp("Find all classes. Break triggered.");
            ok = 1;
            break
        end
        direction_vec = ones(1, n);
        direction_vec(zero_idx(ii, :)) = 0;
        key_val = binary_to_hex(direction_vec);
        if ~isKey(HashTable, key_val)
            cnt = cnt + 1;
            Direction_vectors{w+1} = [Direction_vectors{w+1}; direction_vec];
            if mod(cnt, 1000) == 0
                disp(['Current class index: ',num2str(cnt), ', total index: ',num2str(num_classes), ' time elapsed: ',num2str(toc)]);
            end
            weight_node = Compute_relative_distance_spectrum_brute_force(v+1, code_generator, k+m, poly, direction_vec);
            distance_spectrum_high_rate = weight_node.distance_spectrum_high_rate';
            Relative_dist_spectra_high_rate_code{w+1} = [Relative_dist_spectra_high_rate_code{w+1}; distance_spectrum_high_rate];
            
            temp = [];
            for jj = 1:size(Low_rate_code, 1)
                codeword = Low_rate_code(jj, :);
                new_element = gfadd(codeword, direction_vec, 2);
                key_val = binary_to_hex(new_element);
                if ~isKey(HashTable, key_val)
                    HashTable(key_val) = 1;
                    temp = [temp; new_element];
                else
                    error('Duplicate elements found!');
                end
            end        
            Equivalence_classes{w+1}{end+1,1} = temp;
        end    
    end
    
    if ok == 1
        break
    end
end



% Step 4: save the result
code_string = '';
for iter = 1:size(code_generator,2)
    if iter < size(code_generator,2)
        code_string = [code_string, num2str(code_generator(iter)), '_'];
    else
        code_string = [code_string, num2str(code_generator(iter))];
    end
end
timestamp = datestr(now, 'mmddyy_HHMMSS');
path = './Simulation_results/';
save([path, timestamp, '_equivalence_class_by_weight_ZTCC_', code_string, '_CRC_',...
    crc_gen_poly,'_k_',num2str(k),'.mat'],'Direction_vectors',...
    'Relative_dist_spectra_high_rate_code','Equivalence_classes');




function str = binary_to_hex(binary_vec)

str = '';
Len = length(binary_vec);
for i=Len:-4:1
    shift = min(3, i-1);
    four_tuple = binary_vec(i-shift:i);
    hex = dec2hex(bin2dec(num2str(four_tuple)));
    str = [str, hex];
end
str = fliplr(str);
end





