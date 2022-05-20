% This script is to compute the SLVD complexity upper bound for the review question.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   12/14/21
%

clear all;
clc;


% SLVD complexity for (k=64, v=8, m=10) punctured CRC-TBCC
k = 64;
m = 10;
v = 8;
EL = 44.41;

c1 = 1.5;
c2 = 2.2;

C_SSV = 1.5*(k+m)*2^(v+1) + 2^v + 3.5*c1*(k+m);
C_trace = 3.5*c1*(EL - 1)*(k+m);
E_I = (k+m)*EL + 2^v - 1;
C_list = c2*E_I*log2(E_I);

C_SLVD = C_SSV + C_trace + C_list;
disp(['C_SLVD for (v=8, m=10) CRC-TBCC: ', num2str(C_SLVD)]);


% 3-round WAVA complexity for v = 11 TBCC

I = 3;
k = 64;
v = 11;
omega = 2;
n = omega*k;

WAVA_v11 = I*(n/2)*(0.5*2^v + 2^(v+1));
disp(['3-round WAVA complexity for v = 11 TBCC: ', num2str(WAVA_v11)]);


% 3-round WAVA complexity for v = 14 TBCC

I = 3;
k = 64;
v = 14;
omega = 2;
n = omega*k;

WAVA_v11 = I*(n/2)*(0.5*2^v + 2^(v+1));
disp(['3-round WAVA complexity for v = 14 TBCC: ', num2str(WAVA_v11)]);





