

%% n = 2 case
% we assume that A\sqrt{n} = 1

w = 2;

% g_w1 = @(theta, w) (1+sqrt(1+(1+tan(theta).^2).*(w.^2-1))).^2./((w.^2-1).*(1+tan(theta).^2)+1+sqrt(1+(1+tan(theta).^2)*(w.^2-1))).*1./(2*pi);
g_w1 = @(theta, ratio) (1+sqrt(ratio.^2./(ratio.^2+(1+tan(theta).^2).*(1-ratio.^2)))).*1./(2*pi);

L1 = integral(@(theta) g_w1(theta, 1/w), -pi/2, pi/2);

% g_w2 = @(theta, w) (1-sqrt(1+(1+tan(theta).^2).*(w.^2-1))).^2./((w.^2-1).*(1+tan(theta).^2)+1-sqrt(1+(1+tan(theta).^2)*(w.^2-1))).*1./(2*pi);
g_w2 = @(theta, ratio) (1-sqrt(ratio.^2./(ratio.^2+(1+tan(theta).^2).*(1-ratio.^2)))).*1./(2*pi);


L2 = integral(@(theta) g_w2(theta, 1/w), pi/2, 3*pi/2);

L = L1 + L2


%% n = 3 case

A = 1;

fun = @(x, w) (sqrt(x.^2+w.^2 - 3.*A.^2)+x).^2./(w*sqrt(x.^2+w.^2 - 3.*A.^2)).*1./(4.*pi.*3.*A.^2).*2.*pi.*sqrt(3).*A;


wc = 4;
L = integral(@(x) fun(x, wc), -A*sqrt(3), A*sqrt(3));



%% General case
% default assumption: A = 1, r = A*sqrt(n) = sqrt(n)
% 01/28/21 result: Yes! the integral is always equal to 1!

n = 20;

fun = @(x, w) gamma(n./2)./(sqrt(pi).*gamma((n-1)./2).*sqrt(n).^(n-2).*w.^(n-2)).*(sqrt(x.^2+w.^2-n)+x).^(n-1).*(n-x.^2).^((n-3)./2)./sqrt(x.^2+w.^2-n);

wc = 2000*sqrt(n);
L = integral(@(x) fun(x, wc), -sqrt(n), sqrt(n));


delta = 0.01;
x_zs = -sqrt(n):delta:sqrt(n);
y_funs = fun(x_zs, wc);

figure;
plot(x_zs, y_funs, '-.');
grid on
xlabel('$x_1$','interpreter','latex');
ylabel('$f(x)$','interpreter','latex');



%% Plot lemma 1 upper bound
% default assumption A = 1

n = 20;
m = 3;

fun = @(w) (w+sqrt(n)).^(n-1)./w.^(n-1).*2^m;

delta = 0.01;
ws = 1.01*sqrt(n):delta:90*sqrt(n);
y_fun = fun(ws);

figure;
semilogy(ws, y_fun, '-.');
grid on
xlabel('w');






