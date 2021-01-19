w = 10;
x1 = 3;

theta = 0:0.01:pi/2-0.01;

sins = sin(theta);
coss = cos(theta);
tans = tan(theta);

f = sqrt(((w.*x1.*sins.*tans)./(w.*sins.*tans+x1+w.*coss)-x1-w.*coss).^2+((x1+w.*coss).*x1.*tans./(w.*sins.*tans+x1+w.*coss)+w.*sins).^2);

figure;
plot(theta, f, '-.');
grid on

