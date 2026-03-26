function P = satelliteParams()
% SATELLITE PARAMETER FILE

% Physical parameters
P.Js = 5.0;      % kg m^2
P.Jp = 1.0;      % kg m^2
P.k  = 0.1;      % N m
P.b  = 0.05;     % N m s

% Parameters for animation
P.length = 1.0;  % length of solar panel
P.width  = 0.3;  % width of satellite body

% Initial conditions
P.theta0    = 0.0;   % rad
P.phi0      = 0.0;   % rad
P.thetadot0 = 0.0;   % rad/s
P.phidot0   = 0.0;   % rad/s

% Simulation parameters
P.t_start = 0.0;
P.t_end   = 100.0;
P.Ts      = 0.01;
P.t_plot  = 0.1;

% Saturation limits
P.tau_max = 5.0;     % N m
end