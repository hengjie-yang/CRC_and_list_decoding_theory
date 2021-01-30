% This plot is to plot the derived induced density function and verify
% whether the integral of the density function is equal to 1.
%
% Here, we only verify the 2D and 3D cases.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   01/26/21.
%



set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');




%% n = 2 case
% we assume that A\sqrt{n} = 1

w = 2;

% g_w1 = @(theta, w) (1+sqrt(1+(1+tan(theta).^2).*(w.^2-1))).^2./((w.^2-1).*(1+tan(theta).^2)+1+sqrt(1+(1+tan(theta).^2)*(w.^2-1))).*1./(2*pi);
g_w1 = @(theta, ratio) (1+sqrt(ratio.^2./(ratio.^2+(1+tan(theta).^2).*(1-ratio.^2)))).*1./(2*pi);



% g_w2 = @(theta, w) (1-sqrt(1+(1+tan(theta).^2).*(w.^2-1))).^2./((w.^2-1).*(1+tan(theta).^2)+1-sqrt(1+(1+tan(theta).^2)*(w.^2-1))).*1./(2*pi);
g_w2 = @(theta, ratio) (1-sqrt(ratio.^2./(ratio.^2+(1+tan(theta).^2).*(1-ratio.^2)))).*1./(2*pi);





density = [];
delta = 0.001;

ws = -pi/2:delta:pi/2;
density = [density, g_w1(ws, 1/w)];
wss = pi/2:delta:3*pi/2;
density = [density, g_w2(wss, 1/w)];

w = 10;
temp = [];
ws = -pi/2:delta:pi/2;
temp = [temp, g_w1(ws, 1/w)];
wss = pi/2:delta:3*pi/2;
temp = [temp, g_w2(wss, 1/w)];
density = [density; temp];

w = 100;
temp = [];
ws = -pi/2:delta:pi/2;
temp = [temp, g_w1(ws, 1/w)];
wss = pi/2:delta:3*pi/2;
temp = [temp, g_w2(wss, 1/w)];
density = [density; temp];

thetas = -pi/2:delta:3*pi/2;

convergence = 1/(2*pi)*ones(size(thetas));

figure;
plot(thetas, density(1,:),'-'); hold on
plot(thetas, density(2,:),'-'); hold on
plot(thetas, density(3,:),'-'); hold on
plot(thetas, convergence, '-.');
grid on
legend('$w = 2,\ A = 1/\sqrt{2}$',...
    '$w = 10,\ A = 1/\sqrt{2}$',...
    '$w = 100,\ A = 1/\sqrt{2}$',...
    '$w = \infty,\ A = 1/\sqrt{2}$',...
    'interpreter','latex');
xlabel('$\theta$','interpreter','latex');
ylabel('$g_w(\theta)$','interpreter','latex');
set(gca,'XTick',-pi/2:pi/2:3*pi/2) 
set(gca,'XTickLabel',{'$-\pi/2$','$0$','$\pi/2$','$\pi$','$3\pi/2$'});

title('Induced density function for 2D space');



%% Plot the induced density function according to x-coordinate
% default A = 1, n = 2 case

g_w = @(x, w) (1+x./sqrt(x.^2+(w^2-(1*sqrt(2))^2))).*1/(2*pi*1*sqrt(2));


x_zs = -1*sqrt(2):delta:1*sqrt(2);

w = 1.01*sqrt(2);

density = [];
delta = 0.001;
density = [density, g_w(x_zs, w)];

w = 10*sqrt(2);

temp = [];
temp = [temp, g_w(x_zs, w)];
density = [density; temp];

w = 100*sqrt(2);

temp = [];
temp = [temp, g_w(x_zs, w)];
density = [density; temp];


convergence = 1/(2*pi*sqrt(2))*ones(size(x_zs));

figure;
plot(x_zs, density(1,:),'-'); hold on
plot(x_zs, density(2,:),'-'); hold on
plot(x_zs, density(3,:),'-'); hold on
plot(x_zs, convergence, '-.');
grid on
legend('$w = 1.01\sqrt{2},\ A = 1$',...
    '$w = 10\sqrt{2},\ A = 1$',...
    '$w = 100\sqrt{2},\ A = 1$',...
    '$w = \infty,\ A = 1$',...
    'interpreter','latex');
xlabel('$x_1$','interpreter','latex');
ylabel('$g_w(x_1)$','interpreter','latex');
xlim([-1*sqrt(2), 1*sqrt(2)]);

title('Induced density function in 2D space');


%% default A = 1, n = 3 case

g_w = @(x, w) (1+x.*sqrt(1./(x.^2+(w^2 - (1*sqrt(3))^2)))).*(x+sqrt(x.^2+(w^2-(1*sqrt(3))^2)))./w.*1/(4*pi*sqrt(3));


x_zs = -1*sqrt(3):delta:1*sqrt(3);

w = 1.01*sqrt(3);

density = [];
delta = 0.001;
density = [density, g_w(x_zs, w)];

w = 10*sqrt(3);

temp = [];
temp = [temp, g_w(x_zs, w)];
density = [density; temp];

w = 100*sqrt(3);

temp = [];
temp = [temp, g_w(x_zs, w)];
density = [density; temp];

convergence = 1/(4*pi*sqrt(3))*ones(size(x_zs));

figure;
plot(x_zs, density(1,:),'-'); hold on
plot(x_zs, density(2,:),'-'); hold on
plot(x_zs, density(3,:),'-'); hold on
plot(x_zs, convergence, '-.');
grid on
legend('$w = 1.01\sqrt{3},\ A = 1$',...
    '$w = 10\sqrt{3},\ A = 1$',...
    '$w = 100\sqrt{3},\ A = 1$',...
    '$w = \infty,\ A = 1$',...
    'interpreter','latex');
xlabel('$x_1$','interpreter','latex');
ylabel('$g_w(x_1)$','interpreter','latex');
xlim([-1*sqrt(3), 1*sqrt(3)]);

title('Induced density function in 3D space');


%% default r = 1, n = 10 case

n = 10;

g_w = @(x, w) (1+x./sqrt(x.^2+(w^2 - 1*n))).*(x+sqrt(x.^2+(w^2-1*n))).^(n-2)./(w.^(n-2)).*gamma(n/2)/(2*pi^(n/2)*(sqrt(n))^(n-1));


x_zs = -1*sqrt(n):delta:1*sqrt(n);



w = 1.01*sqrt(n);

density = [];
delta = 0.001;
density = [density, g_w(x_zs, w)];

w = 10*sqrt(n);

temp = [];
temp = [temp, g_w(x_zs, w)];
density = [density; temp];

w = 100*sqrt(n);

temp = [];
temp = [temp, g_w(x_zs, w)];
density = [density; temp];

convergence = gamma(n/2)/(2*pi^(n/2)*(sqrt(n))^(n-1))*ones(size(x_zs));

figure;
semilogy(x_zs, density(1,:),'-'); hold on
semilogy(x_zs, density(2,:),'-'); hold on
semilogy(x_zs, density(3,:),'-'); hold on
semilogy(x_zs, convergence, '-.');
grid on
legend('$w = 1.01\sqrt{10},\ A = 1$',...
    '$w = 10\sqrt{10},\ A = 1$',...
    '$w = 100\sqrt{10},\ A = 1$',...
    '$w = \infty,\ A = 1$',...
    'interpreter','latex');
xlabel('$x_1$','interpreter','latex');
ylabel('$g_w(x_1)$','interpreter','latex');
xlim([-1*sqrt(n), 1*sqrt(n)]);

title('Induced density function in 10-dim space');


%% Integrand plot

n = 100;

fun = @(x, w) (1+x./sqrt(x.^2+(w^2 - 1*n))).*(x+sqrt(x.^2+(w^2-1*n))).^(n-2)./(w.^(n-2)).*gamma(n/2)/(2*pi^(n/2)*(sqrt(n))^(n-1)).*2.*pi.^((n-1)/2).*(n-x.^2).^((n-3)/2).*sqrt(n)./gamma((n-1)/2);

x_zs = -1*sqrt(n):delta:1*sqrt(n);

w = 1.05*sqrt(n);

y_funs = fun(x_zs, w);


plot(x_zs, y_funs, '-.');
grid on

