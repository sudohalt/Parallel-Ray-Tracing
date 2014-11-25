function [rayXvector, rayYvector, OPL, rayYfinal] = ...
    getRayTrajectory(n_profile, Dx, Dy, Dxx, Dxy, Dyx, Dyy, ...
    x_min, x_max, y_min, y_max, delta, dt, y0, theta0)

% Computes ray trajectory from input arguments
%   n_profile: matrix describing refractive index n(x, y)
%   Dx: partial derivative dn/dx
%   Dy: partial derivative dn/dy
%   Dxx: 2nd partial derivative d2n/dx2
%   Dyx: Mixed partial derivative d2n/(dydx)
%   Dxy: Mixed partial derivative d2n/(dxdy)
%   Dyy: 2nd partial derivative d2n/dy2
%   delta: spacing between adjacent grid points
%   dt: incremental step size in optical path length
%   y0: initial ray position in y (ray always starts at x = x_min)
%   theta0: initial ray angle (relative to x-axis)

% Specify initial conditions
rayX = x_min;       % ray's initial x position
rayY = y0;          % ray's initial y position

% Interpolate refractive index at initial position
i = ceil( ( rayY - y_min ) / delta );   % integer value for indexing row
ratio = ( ( rayY - y_min ) - ( i - 1 ) * delta ) / delta;
if( rayY == y_min)
    % Special case: j = 0, manually pick tile at y = y_min
    n = n_profile(1, 1);
else
    % Use linear interpolation
    n = n_profile(i, 1) + ratio * ( n_profile(i + 1) - n_profile(i - 1) );
end

% Optical path length
OPL = 0;            % starts at zero and accumulates

% Compute initial direction vector "T"
Tx = cos(theta0) / n;
Ty = sin(theta0) / n;

% Initialize tracking vectors, starting with ray's initial position
rayXvector = rayX;
rayYvector = rayY;

% Main loop for ray trace
while(rayX < x_max)
    % Store old ray position
    rayXbef = rayX;
    rayYbef = rayY;
    
    % Advance ray by dt, update ray position
    rayX = rayX + dt * Tx;
    rayY = rayY + dt * Ty;
    
    % Store new ray position
    rayXaft = rayX;
    rayYaft = rayY;
    
    % Find intersection with output plane y = y_max when ray gets there
    if(rayX == x_max)
        % Ray trace ended at x = x_max
        rayYfinal = rayY;
        OPL = OPL + dt;
    elseif(rayX > x_max)
        % Ray trace ended at x > x_max, compute intersection
        ratio = (x_max - rayXbef) / (rayXaft - rayXbef);
        rayY = rayYbef + ratio * (rayYaft - rayYbef);
        rayX = x_max;
        rayYfinal = rayY;
        OPL = OPL + ratio * dt;
    else
        % ray didn't reach output plane, just update optical path length
        OPL = OPL + dt;
    end
    
    % Update tracking vectors
    rayXvector = [rayXvector, rayX];
    rayYvector = [rayYvector, rayY];
    % Note: MATLAB recommends allocating space for the vectors beforehand
    
    % Make sure ray is not out of bounds
    if(rayX < x_max && rayX > x_min && rayY < y_max && rayY > y_min)
        % Locate grid row pertinent to current ray position
        j = ceil( ( rayX - x_min ) / delta );
        i = ceil( ( rayY - y_min ) / delta );
        
        % Calculate distance from grid row
        dx = ( rayY - y_min ) - ( j - 1 ) * delta;
        dy = ( rayY - y_min ) - ( i - 1 ) * delta;
        
        % Calculate 1st order approximation of n
        n = n_profile(i, j) + Dx(i, j) * dx + Dy(i, j) * dy;
        % Calculate 1st order approximation of dn/dx
        D_X = Dx(i, j) + Dxx(i, j) * dx + Dxy(i, j) * dy;
        % Calculate 1st order approximation of dn/dy
        D_Y = Dy(i, j) + Dyx(i, j) * dx + Dyy(i, j) * dy;
        
        % Update direction vector "T"
        Tx = Tx + dt * ( D_X / n^3 - ...
            2/n * ( Tx * D_X + Ty * D_Y ) * Tx );
        Ty = Ty + dt * ( D_Y / n^3 - ...
            2/n * ( Tx * D_X + Ty * D_Y ) * Ty );
    else
        % Ray is out of bounds (exited top or bottom), exit main loop
        break;
    end
end

% Set output parameters to null if rays went out of bounds
if(rayXvector(end) < x_max)
    OPL = NaN;
    rayYfinal = NaN;
end