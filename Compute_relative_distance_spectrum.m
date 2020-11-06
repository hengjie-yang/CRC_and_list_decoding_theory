function weight_node = Compute_relative_distance_spectrum(constraint_length, code_generator, N, error_vector)

%   This function computes the distance spectrum relative to "error_vector".
%
%   Inputs:
%       1) constraint_length: a scalar denoting the constraint length.
%       2) code_generator: a matrix describing the CC generator.
%       3) N: a scalar denoting the trellis length (Note that is is NOT the blocklength)
%       4) error_vector: a binary row vector with length equal to
%       blocklength.
%
%   Outputs:
%       1) weight_node: cosisted of the weight_spectrum and polynomial
%       expression.
%
%   Algorithm: the idea is that if the transfer matrix covers any of the
%   error locations, we alter its branch weight accordingly.
%
%   Caution: the function only works for rate-1/2 conv. encoder.
%   
%   Written by Hengjie Yang (hengjie.yang@ucla.edu) 11/05/20.
%

poly = [];
trellis = poly2trellis(constraint_length, code_generator);
num_states = trellis.numStates;
T = cell(4, 1);

syms X;


% Step 1: compute the one-step transfer function
disp('Step 1: Compute all possible one-step transfer functions');
T{1} = compute_transfer_func(trellis, [0, 0]); % no errors
T{2} = compute_transfer_func(trellis, [0, 1]); % one error
T{3} = compute_transfer_func(trellis, [1, 0]); % one error
T{4} = compute_transfer_func(trellis, [1, 1]); % two errors
 

% Step 2: compute the distance spectrum relative to the error vector.
disp('Step 2: Compute the distance spectrum relative to the error vector.');
B = eye(num_states);
B = sym(B);

for iter = 1:N 
%     disp(['Current depth: ',num2str(iter)]);
    
    % choose the proper one-step transfer function based on error locations
    if error_vector(2*iter-1) == 0 && error_vector(2*iter) == 0
        B = B*T{1};
    elseif error_vector(2*iter-1) == 0 && error_vector(2*iter) == 1
        B = B*T{2};
    elseif error_vector(2*iter-1) == 1 && error_vector(2*iter) == 0
        B = B*T{3};
    else
        B = B*T{4};
    end
    B = expand(B);
end



% Step 3: compute the distance spectrum relative to the error vector.
disp('Step 3: Compute the distance spectrum relative to the error vector.');

poly = B(1,1);
disp(poly);
weight_spectrum = coeffs(poly,'All');
weight_spectrum = fliplr(weight_spectrum);
weight_spectrum = double(weight_spectrum);
weight_spectrum = weight_spectrum';

weight_node.weight_spectrum = weight_spectrum;
weight_node.overall_weight_function = poly;







function T = compute_transfer_func(trellis, error_vec)

% error_vec is a 1 by 2 row indicator.

num_states = trellis.numStates;
T = zeros(num_states, num_states);
T = sym(T);

for cur_state = 1:num_states
    for input = 1:2
        next_state = trellis.nextStates(cur_state, input) + 1;
        output_symbol = dec2bin(oct2dec(trellis.outputs(cur_state, input)))-'0';
        output_symbol = bitxor(output_symbol, error_vec); % add noise vector
        output_weight = sum(output_symbol);
        weight_sym = convert_to_symbol(output_weight);
        T(cur_state, next_state) = weight_sym;
    end
end







function chr = convert_to_symbol(weight)

chr = 0; % invalid string
syms X;

if weight == 0
    chr = 1;
elseif weight == 1
    chr = X;
else
    chr = X^weight;
end
        

