% This tool script is to learn how to create a magnified plot inside a
% plot.
%
% Reference: 
% https://swetava.wordpress.com/2013/10/05/create-magnifier-plots-in-matlab/comment-page-1/
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)  04/20/21
%



% Create a dummy function
x = 0:0.01:pi;
y = 5*sin(x).*cos(10*x) + rand(size(x));

figure; 
plot(x, y); hold on;
grid on
xlabel('X');
ylabel('Y');


% Specify the position and the size of the rectangle
x_r = 0.95; y_r = -3.3; w_r = 0.2; h_r = 0.7;
rectangle('Position', [x_r-w_r/2, y_r-h_r/2, w_r, h_r], ...
'EdgeColor', [0.4, 0.1, 0.4], 'LineWidth',2);


% Specify the position and the size of the second box and thus add a second axis for plotting
x_a = 0.58; y_a = 0.18; w_a = 0.3; h_a = 0.3;
ax = axes('Units', 'Normalized', ...
'Position', [x_a, y_a, w_a, h_a], ...
'XTick', [], ...
'YTick', [], ...
'Box', 'on', ...
'LineWidth', 2, ...
'Color', [0.95, 0.99, 0.95]);
hold on;

plot(x, y);
xlabel('Detail at X==0.95');
axis([x_r-w_r/2, x_r+w_r/2, y_r-h_r/2, y_r+h_r/2]);




