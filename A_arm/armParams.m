function P = armParams()
% ARM PARAMETERS

% Physical parameters
P.m = 0.5;        % kg
P.ell = 0.3;      % m
P.g = 9.8;        % m/s^2
P.b = 0.01;       % N*m*s

% Parameters for animation
P.length = 1.0;
P.width = 0.3;

% Initial conditions
P.theta0 = 0.0*pi/180;   % rad
P.thetadot0 = 0.0;       % rad/s

% Simulation parameters
P.t_start = 0.0;
P.t_end = 50.0;
P.Ts = 0.01;
P.t_plot = 0.1;

% Saturation limit
P.tau_max = 1.0;         % N*m
end