function P = massParams()

% Physical parameters 
P.m = 5.0;      % kg
P.k = 3.0;      % N/m
P.b = 0.5;      % N*s/m

% Parameters for animation
P.length = 5.0;
P.width = 1.0;

% Initial conditions
P.z0 = 0.0;     % m
P.zdot0 = 0.0;  % m/s

% Simulation parameters
P.t_start = 0.0;
P.t_end   = 50.0;
P.Ts      = 0.01;
P.t_plot  = 0.1;

% Saturation limit
P.F_max = 6.0;  % N
end