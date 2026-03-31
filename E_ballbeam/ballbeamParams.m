function P = ballbeamParams()

% Physical parameters
P.m1 = 0.35;       % mass of block, kg
P.m2 = 2.0;        % mass of beam, kg
P.length = 0.5;    % beam length, m
P.g = 9.8;         % gravity, m/s^2

% Parameters for animation
P.radius = 0.03;   % m
P.gap = 0.005;     % m

% Initial conditions
P.z0 = 0.25;               % m
P.theta0 = 0.0*pi/180;     % rad
P.zdot0 = 0.0;             % m/s
P.thetadot0 = 0.0;         % rad/s

% Simulation parameters
P.t_start = 0.0;
P.t_end   = 20.0;
% P.Ts      = 0.01;
P.Ts      = 0.01;
P.t_plot  = 0.05;

% Saturation limit 
P.F_max = 15.0;            % N

P.ze = P.length/2;
P.Fe = P.g*(P.m1*P.ze + P.m2*P.length/2)/P.length;
end