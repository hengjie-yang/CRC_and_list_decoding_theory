% This script is to compute the upper bound on d_crc for CRC-ZTCC codes and
% CRC-TBCC codes.
%
% The script requires either the full distance spectrum or full error
% events of sufficiently large d_tilde.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   03/03/21.
%


% ==========================================================
% Compute upper bound on d_crc for CRC-ZTCC codes
% ==========================================================


% Basic parameters
k = 64;
m = 10;
v = 3;
code_generator = [13,17];

path = './TCOM_truncated_union_bound/';
fileName = [path, 'weight_node_ZTCC_',num2str(code_generator(1)),'_',...
    num2str(code_generator(2)),'_N_',num2str(k+m+v),'.mat'];

if ~exist(fileName, 'file')
    disp(['ERROR: ', fileName, ' does not exist!']);
    return
else
    load(fileName, 'weight_node');
end

high_rate_weight_spectrum = weight_node.weight_spectrum;
index = find(high_rate_weight_spectrum>0);
d_min = index(2) - 1;
d_max = index(end) - 1;

w = d_min; % true distance
cnt = 0;
target_val = 2^m;
opt_w = -1;

while w>=d_min
    cnt = cnt + high_rate_weight_spectrum(w+1);
    if cnt >= target_val
        opt_w = w;
        break
    end
    w = w + 1;
end

disp(['Upper bound on d_crc for m = ',num2str(m),' : ',num2str(2*opt_w)]);
        



%% ==========================================================
% Compute upper bound on d_crc for CRC-TBCC codes
% ==========================================================


% Basic parameters
k = 64;
m = 10;
v = 3;
code_generator = [13,17];

path = './TCOM_truncated_union_bound/';
fileName = [path, 'weight_node_TBCC_',num2str(code_generator(1)),'_',...
    num2str(code_generator(2)),'_N_',num2str(k+m),'.mat'];

if ~exist(fileName, 'file')
    disp(['ERROR: ', fileName, ' does not exist!']);
    return
else
    load(fileName, 'weight_node');
end

high_rate_weight_spectrum = weight_node.weight_spectrum;
index = find(high_rate_weight_spectrum>0);
d_min = index(2) - 1;
d_max = index(end) - 1;

w = d_min; % true distance
cnt = 0;
target_val = 2^m;
opt_w = -1;

while w>=d_min
    cnt = cnt + high_rate_weight_spectrum(w+1);
    if cnt >= target_val
        opt_w = w;
        break
    end
    w = w + 1;
end

disp(['Upper bound on d_crc for m = ',num2str(m),' : ',num2str(2*opt_w)]);



