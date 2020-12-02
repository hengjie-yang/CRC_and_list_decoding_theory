% This script is to play around interesting combinatorial formula.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   11/16/20.
%

%% f
n = 20;
w = 4;

threshold = floor((w-1)/2);
val = 0;
for a = 0:threshold
    val = val + nchoosek(w, a)*nchoosek(n - w, a);
end


disp(['Summation result: ', num2str(val), ' total: ',num2str(nchoosek(n, w)),...
    ' difference: ',num2str(nchoosek(n, w) - val)]);


%% Another bound

n = 20;
w = 8;
d_crc = 8;
val = 0;
for r = (d_crc - w):(w-1)
    if mod(d_crc+r-w, 2) == 0
        a = (d_crc + r - w)/2;
        val = val + nchoosek(d_crc, a)*nchoosek(n-d_crc, r-a);
    end
end


disp(['Summation result: ', num2str(val), ' total: ',num2str(nchoosek(n, w)),...
    ' difference: ',num2str(nchoosek(n, w) - val)]);





