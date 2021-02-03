% This script is to visualize the 3D Voronoi region of list ranks
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   01/31/21.
%

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


%% n = 2 case
% Assumptions: 
%   1) low-rate codewords: (0, 0), (1, 1).
%   2) high-rate codewords: (0, 0), (0, 1), (1, 0), (1, 1).
%


High_rate_codewords = [0 0; 0 1; 1 0; 1 1];
Low_rate_identifier = [1; 0; 0; 1]; % The i-th codeword is low-rate if its value is 1



% Convert binary codewords to 2D real points
High_rate_points = -2*High_rate_codewords + 1;



% Scan the 2D circle to identify list rank.
n = 2;
A = 1;
r = A*sqrt(n);

delta = 0.01;
thetas = 0:delta:2*pi;
list_ranks = zeros(size(thetas));

for iter = 1:size(thetas, 2)
    theta = thetas(iter);
    x = r*cos(theta);
    y = r*sin(theta);
    list_ranks(iter) = Compute_list_rank([x,y], High_rate_points, Low_rate_identifier);
end


% Plot the figure;
figure;
sz = 10;


xs = r*cos(thetas(list_ranks == 1));
ys = r*sin(thetas(list_ranks == 1));
scatter(xs, ys, sz,...
    'MarkerEdgeColor',[1 1 1], 'MarkerFaceColor','r','LineWidth',1);hold on

xs = r*cos(thetas(list_ranks == 2));
ys = r*sin(thetas(list_ranks == 2));
scatter(xs, ys, sz,...
    'MarkerEdgeColor',[1 1 1], 'MarkerFaceColor',[0.5, .5, 0],'LineWidth',1);hold on


scatter(High_rate_points(:,1), High_rate_points(:,2),'filled','k');hold on

scatter(High_rate_points(Low_rate_identifier==1, 1), High_rate_points(Low_rate_identifier==1, 2),'filled', 'g');hold on

legend('$s = 1$', '$s=2$');

grid on;
xlabel('$x$', 'interpreter','latex');
ylabel('$y$', 'interpreter','latex');
axis equal
title('List rank Voronoi region on 2D codeword sphere');






%% n = 3 case, subcase 1
% Assumptions: 
%   1) low-rate codewords: (000), (111). Namely, k = 1.
%   2) high-rate codewords: (000), (001), (010), (011), (100), (101),
%   (110), (111). Namely, k + m = 3.
%


High_rate_codewords = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
Low_rate_identifier = [1 0 0 0 0 0 0 1]'; % The i-th codeword is low-rate if its value is 1



% Convert binary codewords to 2D real points
High_rate_points = -2*High_rate_codewords + 1;



% Scan the 2D circle to identify list rank.
n = 3;
A = 1;
r = A*sqrt(n);

delta = 0.02;
phis = 0:delta:2*pi; % the azimuth angle, definition agrees with MATLAB 'sph2cart' document
thetas = -pi/2:delta:pi/2; % the elevation angle, definition agrees with MATLAB 'sph2cart' document

list_ranks = zeros(length(phis), length(thetas));

for ii = 1:length(phis)
    for jj = 1:length(thetas)
        phi = phis(ii);
        theta = thetas(jj);
        x = r*cos(theta)*cos(phi);
        y = r*cos(theta)*sin(phi);
        z = r*sin(theta);
        list_ranks(ii, jj) = Compute_list_rank([x,y,z], High_rate_points, Low_rate_identifier);
    end
end


% Plot the figure for list rank one region;
figure;
sz = 8;


Max_list_size = 6;

Xs = cell(Max_list_size, 1);
Ys = cell(Max_list_size, 1);
Zs = cell(Max_list_size, 1);

for ss = 1:Max_list_size
    Xs{ss} = [];
    for ii = 1:length(phis)
        for jj = 1:length(thetas)
            if list_ranks(ii, jj) == ss
                Xs{ss} = [Xs{ss}; r*cos(thetas(jj))*cos(phis(ii))];
                Ys{ss} = [Ys{ss}; r*cos(thetas(jj))*sin(phis(ii))];
                Zs{ss} = [Zs{ss}; r*sin(thetas(jj))];
            end
        end
    end
end


scatter3(Xs{1}, Ys{1}, Zs{1}, sz,'MarkerFaceColor',[1, 0, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{2}, Ys{2}, Zs{2}, sz,'MarkerFaceColor',[0.5, 0.5, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{3}, Ys{3}, Zs{3}, sz,'MarkerFaceColor',[0.2, 0, 1],'MarkerEdgeColor','none');hold on
scatter3(Xs{4}, Ys{4}, Zs{4}, sz,'MarkerFaceColor',[1, 0.8, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{5}, Ys{5}, Zs{5}, sz,'MarkerFaceColor',[0.5, 0, 0]);hold on
% scatter3(Xs{6}, Ys{6}, Zs{6}, sz,'MarkerFaceColor',[0, 0, 0.5]);hold on

scatter3(High_rate_points(:,1), High_rate_points(:,2),High_rate_points(:,3),100,'filled','k');hold on

scatter3(High_rate_points(Low_rate_identifier==1, 1), High_rate_points(Low_rate_identifier==1, 2),High_rate_points(Low_rate_identifier==1, 3),100, 'filled','g');hold on

[X, Y, Z] = sphere;

X = X*r;
Y = Y*r;
Z = Z*r;
mesh(X, Y, Z);

legend('s = 1',...
    's = 2',...
    's = 3',...
    's = 4');


xlabel('$x$','interpreter','latex');
ylabel('$y$','interpreter','latex');
zlabel('$z$','interpreter','latex');

axis equal
view(45, 25);
title('List rank Voronoi region on 3D codeword sphere');



%% n = 3 case, subcase 2
% Assumptions: 
%   1) low-rate codewords: (000), (101). Namely, k = 1.
%   2) high-rate codewords: (000), (001), (010), (011), (100), (101),
%   (110), (111). Namely, k + m = 3.
%


High_rate_codewords = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
Low_rate_identifier = [1 0 0 0 0 1 0 0]'; % The i-th codeword is low-rate if its value is 1


% Convert binary codewords to 2D real points
High_rate_points = -2*High_rate_codewords + 1;



% Scan the 2D circle to identify list rank.
n = 3;
A = 1;
r = A*sqrt(n);

delta = 0.02;
phis = 0:delta:2*pi; % the azimuth angle, definition agrees with MATLAB 'sph2cart' document
thetas = -pi/2:delta:pi/2; % the elevation angle, definition agrees with MATLAB 'sph2cart' document

list_ranks = zeros(length(phis), length(thetas));

for ii = 1:length(phis)
    for jj = 1:length(thetas)
        phi = phis(ii);
        theta = thetas(jj);
        x = r*cos(theta)*cos(phi);
        y = r*cos(theta)*sin(phi);
        z = r*sin(theta);
        list_ranks(ii, jj) = Compute_list_rank([x,y,z], High_rate_points, Low_rate_identifier);
    end
end


% Plot the figure for list rank one region;
figure;
sz = 8;


Max_list_size = 6;

Xs = cell(Max_list_size, 1);
Ys = cell(Max_list_size, 1);
Zs = cell(Max_list_size, 1);

for ss = 1:Max_list_size
    Xs{ss} = [];
    for ii = 1:length(phis)
        for jj = 1:length(thetas)
            if list_ranks(ii, jj) == ss
                Xs{ss} = [Xs{ss}; r*cos(thetas(jj))*cos(phis(ii))];
                Ys{ss} = [Ys{ss}; r*cos(thetas(jj))*sin(phis(ii))];
                Zs{ss} = [Zs{ss}; r*sin(thetas(jj))];
            end
        end
    end
end


scatter3(Xs{1}, Ys{1}, Zs{1}, sz,'MarkerFaceColor',[1, 0, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{2}, Ys{2}, Zs{2}, sz,'MarkerFaceColor',[0.5, 0.5, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{3}, Ys{3}, Zs{3}, sz,'MarkerFaceColor',[0.2, 0, 1],'MarkerEdgeColor','none');hold on
scatter3(Xs{4}, Ys{4}, Zs{4}, sz,'MarkerFaceColor',[1, 0.8, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{5}, Ys{5}, Zs{5}, sz,'MarkerFaceColor',[0.5, 0, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{6}, Ys{6}, Zs{6}, sz,'MarkerFaceColor',[0.2, 0.7, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{7}, Ys{7}, Zs{7}, sz,'MarkerFaceColor',[1, 0.7, 0.2],'MarkerEdgeColor','none');hold on
% scatter3(Xs{8}, Ys{8}, Zs{8}, sz,'MarkerFaceColor',[0.2, 0.7, 1],'MarkerEdgeColor','none');hold on

scatter3(High_rate_points(:,1), High_rate_points(:,2),High_rate_points(:,3),100,'filled','k');hold on

scatter3(High_rate_points(Low_rate_identifier==1, 1), High_rate_points(Low_rate_identifier==1, 2),High_rate_points(Low_rate_identifier==1, 3),100, 'filled','g');hold on

[X, Y, Z] = sphere;

X = X*r;
Y = Y*r;
Z = Z*r;
mesh(X, Y, Z);


legend('s = 1',...
    's = 2',...
    's = 3',...
    's = 4',...
    's = 5',...
    's = 6');


xlabel('$x$','interpreter','latex');
ylabel('$y$','interpreter','latex');
zlabel('$z$','interpreter','latex');

axis equal
view(225, 25);
title('List rank Voronoi region on 3D codeword sphere');




%% n = 3 case, subcase 3
% Assumptions: 
%   1) low-rate codewords: (000), (011), (110), (101). Namely, k = 2.
%   2) high-rate codewords: (000), (001), (010), (011), (100), (101),
%   (110), (111). Namely, k + m = 3.
%


High_rate_codewords = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
Low_rate_identifier = [1 0 0 1 0 1 1 0]'; % The i-th codeword is low-rate if its value is 1


% Convert binary codewords to 2D real points
High_rate_points = -2*High_rate_codewords + 1;



% Scan the 2D circle to identify list rank.
n = 3;
A = 1;
r = A*sqrt(n);

delta = 0.02;
phis = 0:delta:2*pi; % the azimuth angle, definition agrees with MATLAB 'sph2cart' document
thetas = -pi/2:delta:pi/2; % the elevation angle, definition agrees with MATLAB 'sph2cart' document

list_ranks = zeros(length(phis), length(thetas));

for ii = 1:length(phis)
    for jj = 1:length(thetas)
        phi = phis(ii);
        theta = thetas(jj);
        x = r*cos(theta)*cos(phi);
        y = r*cos(theta)*sin(phi);
        z = r*sin(theta);
        list_ranks(ii, jj) = Compute_list_rank([x,y,z], High_rate_points, Low_rate_identifier);
    end
end


% Plot the figure for list rank one region;
figure;
sz = 8;


Max_list_size = 6;

Xs = cell(Max_list_size, 1);
Ys = cell(Max_list_size, 1);
Zs = cell(Max_list_size, 1);

for ss = 1:Max_list_size
    Xs{ss} = [];
    for ii = 1:length(phis)
        for jj = 1:length(thetas)
            if list_ranks(ii, jj) == ss
                Xs{ss} = [Xs{ss}; r*cos(thetas(jj))*cos(phis(ii))];
                Ys{ss} = [Ys{ss}; r*cos(thetas(jj))*sin(phis(ii))];
                Zs{ss} = [Zs{ss}; r*sin(thetas(jj))];
            end
        end
    end
end


scatter3(Xs{1}, Ys{1}, Zs{1}, sz,'MarkerFaceColor',[1, 0, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{2}, Ys{2}, Zs{2}, sz,'MarkerFaceColor',[0.5, 0.5, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{3}, Ys{3}, Zs{3}, sz,'MarkerFaceColor',[0.2, 0, 1],'MarkerEdgeColor','none');hold on
% scatter3(Xs{4}, Ys{4}, Zs{4}, sz,'MarkerFaceColor',[1, 0.8, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{5}, Ys{5}, Zs{5}, sz,'MarkerFaceColor',[0.5, 0, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{6}, Ys{6}, Zs{6}, sz,'MarkerFaceColor',[0.2, 0.7, 0],'MarkerEdgeColor','none');hold on

scatter3(High_rate_points(:,1), High_rate_points(:,2),High_rate_points(:,3),100,'filled','k');hold on

scatter3(High_rate_points(Low_rate_identifier==1, 1), High_rate_points(Low_rate_identifier==1, 2),High_rate_points(Low_rate_identifier==1, 3),100, 'filled','g');hold on

[X, Y, Z] = sphere;

X = X*r;
Y = Y*r;
Z = Z*r;
mesh(X, Y, Z);


legend('s = 1',...
    's = 2');


xlabel('$x$','interpreter','latex');
ylabel('$y$','interpreter','latex');
zlabel('$z$','interpreter','latex');

axis equal
view(45, 25);
title('List rank Voronoi region on 3D codeword sphere');



%% n = 3 case, subcase 4
% Assumptions: 
%   1) low-rate codewords: (000), (101). Namely, k = 1.
%   2) high-rate codewords: (000), (011), (101), (110). Namely, k + m = 3.
%


High_rate_codewords = [0 0 0; 0 1 1; 1 0 1; 1 1 0];
Low_rate_identifier = [1 0 1 0]'; % The i-th codeword is low-rate if its value is 1


% Convert binary codewords to 2D real points
High_rate_points = -2*High_rate_codewords + 1;



% Scan the 2D circle to identify list rank.
n = 3;
A = 1;
r = A*sqrt(n);

delta = 0.02;
phis = 0:delta:2*pi; % the azimuth angle, definition agrees with MATLAB 'sph2cart' document
thetas = -pi/2:delta:pi/2; % the elevation angle, definition agrees with MATLAB 'sph2cart' document

list_ranks = zeros(length(phis), length(thetas));

for ii = 1:length(phis)
    for jj = 1:length(thetas)
        phi = phis(ii);
        theta = thetas(jj);
        x = r*cos(theta)*cos(phi);
        y = r*cos(theta)*sin(phi);
        z = r*sin(theta);
        list_ranks(ii, jj) = Compute_list_rank([x,y,z], High_rate_points, Low_rate_identifier);
    end
end


% Plot the figure for list rank one region;
figure;
sz = 8;


Max_list_size = 6;

Xs = cell(Max_list_size, 1);
Ys = cell(Max_list_size, 1);
Zs = cell(Max_list_size, 1);

for ss = 1:Max_list_size
    Xs{ss} = [];
    for ii = 1:length(phis)
        for jj = 1:length(thetas)
            if list_ranks(ii, jj) == ss
                Xs{ss} = [Xs{ss}; r*cos(thetas(jj))*cos(phis(ii))];
                Ys{ss} = [Ys{ss}; r*cos(thetas(jj))*sin(phis(ii))];
                Zs{ss} = [Zs{ss}; r*sin(thetas(jj))];
            end
        end
    end
end


scatter3(Xs{1}, Ys{1}, Zs{1}, sz,'MarkerFaceColor',[1, 0, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{2}, Ys{2}, Zs{2}, sz,'MarkerFaceColor',[0.5, 0.5, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{3}, Ys{3}, Zs{3}, sz,'MarkerFaceColor',[0.2, 0, 1],'MarkerEdgeColor','none');hold on
% scatter3(Xs{4}, Ys{4}, Zs{4}, sz,'MarkerFaceColor',[1, 0.8, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{5}, Ys{5}, Zs{5}, sz,'MarkerFaceColor',[0.5, 0, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{6}, Ys{6}, Zs{6}, sz,'MarkerFaceColor',[0.2, 0.7, 0],'MarkerEdgeColor','none');hold on

scatter3(High_rate_points(:,1), High_rate_points(:,2),High_rate_points(:,3),100,'filled','k');hold on

scatter3(High_rate_points(Low_rate_identifier==1, 1), High_rate_points(Low_rate_identifier==1, 2),High_rate_points(Low_rate_identifier==1, 3),100, 'filled','g');hold on

[X, Y, Z] = sphere;

X = X*r;
Y = Y*r;
Z = Z*r;
mesh(X, Y, Z);


legend('s = 1',...
    's = 2',...
    's = 3');


xlabel('$x$','interpreter','latex');
ylabel('$y$','interpreter','latex');
zlabel('$z$','interpreter','latex');

axis equal
view(45, 25);
title('List rank Voronoi region on 3D codeword sphere');



%% n = 3 case, special case (in which the arrangement does not exist in practice)
% Assumptions: 
%   1) low-rate codewords: (101), (111). Namely, k = 1.
%   2) high-rate codewords: (000), (010), (101), (111).
%


High_rate_codewords = [0 0 0; 0 1 0; 1 0 1; 1 1 1];
Low_rate_identifier = [0 0 1 1]'; % The i-th codeword is low-rate if its value is 1


% Convert binary codewords to 2D real points
High_rate_points = -2*High_rate_codewords + 1;



% Scan the 2D circle to identify list rank.
n = 3;
A = 1;
r = A*sqrt(n);

delta = 0.02;
phis = 0:delta:2*pi; % the azimuth angle, definition agrees with MATLAB 'sph2cart' document
thetas = -pi/2:delta:pi/2; % the elevation angle, definition agrees with MATLAB 'sph2cart' document

list_ranks = zeros(length(phis), length(thetas));

for ii = 1:length(phis)
    for jj = 1:length(thetas)
        phi = phis(ii);
        theta = thetas(jj);
        x = r*cos(theta)*cos(phi);
        y = r*cos(theta)*sin(phi);
        z = r*sin(theta);
        list_ranks(ii, jj) = Compute_list_rank([x,y,z], High_rate_points, Low_rate_identifier);
    end
end


% Plot the figure for list rank one region;
figure;
sz = 8;


Max_list_size = 6;

Xs = cell(Max_list_size, 1);
Ys = cell(Max_list_size, 1);
Zs = cell(Max_list_size, 1);

for ss = 1:Max_list_size
    Xs{ss} = [];
    for ii = 1:length(phis)
        for jj = 1:length(thetas)
            if list_ranks(ii, jj) == ss
                Xs{ss} = [Xs{ss}; r*cos(thetas(jj))*cos(phis(ii))];
                Ys{ss} = [Ys{ss}; r*cos(thetas(jj))*sin(phis(ii))];
                Zs{ss} = [Zs{ss}; r*sin(thetas(jj))];
            end
        end
    end
end


scatter3(Xs{1}, Ys{1}, Zs{1}, sz,'MarkerFaceColor',[1, 0, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{2}, Ys{2}, Zs{2}, sz,'MarkerFaceColor',[0.5, 0.5, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{3}, Ys{3}, Zs{3}, sz,'MarkerFaceColor',[0.2, 0, 1],'MarkerEdgeColor','none');hold on
scatter3(Xs{4}, Ys{4}, Zs{4}, sz,'MarkerFaceColor',[1, 0.8, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{5}, Ys{5}, Zs{5}, sz,'MarkerFaceColor',[0.5, 0, 0],'MarkerEdgeColor','none');hold on
scatter3(Xs{6}, Ys{6}, Zs{6}, sz,'MarkerFaceColor',[0.2, 0.7, 0],'MarkerEdgeColor','none');hold on
% scatter3(Xs{7}, Ys{7}, Zs{7}, sz,'MarkerFaceColor',[1, 0.7, 0.2],'MarkerEdgeColor','none');hold on
% scatter3(Xs{8}, Ys{8}, Zs{8}, sz,'MarkerFaceColor',[0.2, 0.7, 1],'MarkerEdgeColor','none');hold on

scatter3(High_rate_points(:,1), High_rate_points(:,2),High_rate_points(:,3),100,'filled','k');hold on

scatter3(High_rate_points(Low_rate_identifier==1, 1), High_rate_points(Low_rate_identifier==1, 2),High_rate_points(Low_rate_identifier==1, 3),100, 'filled','g');hold on

[X, Y, Z] = sphere;

X = X*r;
Y = Y*r;
Z = Z*r;
mesh(X, Y, Z);


legend('s = 1',...
    's = 2',...
    's = 3');


xlabel('$x$','interpreter','latex');
ylabel('$y$','interpreter','latex');
zlabel('$z$','interpreter','latex');

axis equal
view(235, 25);
title('List rank Voronoi region on 3D codeword sphere');





function res = Compute_list_rank(receive_point, High_rate_points, Low_rate_identifier)

distances = sum((receive_point - High_rate_points).^2, 2);
[~, I] = sort(distances);
closest_low_rate_idx = find(Low_rate_identifier(I) == 1);
res = closest_low_rate_idx(1);  

end


