function P = pendulumParams()
% Inverted pendulum parameter file

% Physical parameters
P.m1 = 0.25;      % pendulum mass, kg
P.m2 = 1.0;       % cart mass, kg
P.ell = 1.0;      % rod length, m
P.g = 9.8;        % gravity, m/s^2
P.b = 0.05;       % damping coefficient, N*s

% Animation parameters
P.w = 0.5;        % cart width, m
P.h = 0.15;       % cart height, m
P.gap = 0.005;    % gap between cart and x-axis, m
P.radius = 0.06;  % bob radius, m

% Initial conditions
P.z0 = 0.0;                 % m
P.theta0 = 0.0*pi/180;      % rad
P.zdot0 = 0.0;              % m/s
P.thetadot0 = 0.0;          % rad/s

% Simulation parameters
P.t_start = 0.0;
P.t_end = 50.0;
P.Ts = 0.01;
P.t_plot = 0.1;

% Saturation limits
P.F_max = 5.0;              % N
end