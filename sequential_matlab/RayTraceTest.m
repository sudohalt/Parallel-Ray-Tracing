% Specify dimensions of GRIN
x_min = 0;
x_max = 5;
y_min = -0.25;
y_max = 0.25;

% Specify grid
Q = 100;            % number of grid points across y axis
delta = ( y_max - y_min ) / Q;      % separation between grid points

y = y_min : delta : y_max;      % y-axis
x = x_min : delta : x_max;      % x-axis
[X, Y] = meshgrid(x, y);

% Note: x_max - x_min should be an integer multiple of delta

% Specify index profile of GRIN
n0 = 1.5;                       % base index
kappa = 2*pi*sqrt(n0)/5;        % quadratic parameter
n_profile = n0 - 0.5 * ( kappa ^ 2 * Y .^2 );

% Note: periodicity for paraxial rays is T = 2*pi*sqrt(n0) / kappa

% Plot index profile
figure;
[~, h] = contourf(x, y, n_profile, 50);
set(h,'ShowText','off','TextStep',get(h,'LevelStep')*0);
set(h,'LineStyle','none');
set(gca,'FontSize',14);
xlabel('x');
ylabel('y');
colormap('summer');
colorbar('location','eastoutside');
set(gca,'FontSize',14);

% Calculate partial derivatives dn/dx and dn/dy
[Dx, Dy] = gradient(n_profile, delta, delta);

% Calculate 2nd partial derivatives
[Dxx, Dxy] = gradient(Dx, delta, delta);
[Dyx, Dyy] = gradient(Dy, delta, delta);

% Specify initial conditions
y0 = 0.01;
theta0 = 0;

foo = true;

% Specify ray trace parameters
dt = delta / 3;

[X_trace, Y_trace, OPL, ~] = getRayTrajectory(n_profile, Dx, Dy, ...
    Dxx, Dxy, Dyx, Dyy, x_min, x_max, y_min, y_max, delta, dt, ...
    y0, theta0);
hold on;
plot(X_trace, Y_trace, 'r', 'LineWidth', 2);