function P = vtolParams()

% Physical parameters
P.mc = 1.0;        % center pod mass, kg
P.Jc = 0.0042;     % center pod inertia, kg m^2
P.mr = 0.25;       % right rotor mass, kg
P.ml = 0.25;       % left rotor mass, kg
P.d  = 0.3;        % distance from COM to rotor, m
P.mu = 0.1;        % momentum drag coefficient, kg/s
P.g  = 9.81;       % gravity, m/s^2
P.F_wind = 0.0;    % wind disturbance for early homeworks

% Animation parameter 
P.length = 10.0;

% Initial conditions
P.z0 = 5.0;
P.h0 = 5.0;
P.theta0 = 0.0;
P.zdot0 = 0.0;
P.hdot0 = 0.0;
P.thetadot0 = 0.0;
P.target0 = 5.0;

% Simulation parameters
P.t_start = 0.0;
P.t_end   = 20.0;
P.Ts      = 0.01;
P.t_plot  = 0.05;

% Per-rotor saturation, used later in the VTOL homework sequence
P.F_max = 10.0;    % N

% mixing / unmixing matrices
% [F; tau] = [1 1; d -d] * [fr; fl]
P.unmixing = [1.0, 1.0;
                      P.d, -P.d];
P.mixing = inv(P.unmixing);

% equilibrium quantities
P.m = P.mc + P.mr + P.ml;
P.J = P.Jc + (P.mr + P.ml)*P.d^2;
P.Fe = P.m * P.g;

% longitudinal state space model 
% x_lon = [h_tilde; hdot_tilde], u_lon = F_tilde, y_lon = h_tilde
P.A_lon = [0, 1;
                 0, 0];
P.B_lon = [0;
                 1/P.m];
P.C_lon = [1, 0];
P.D_lon = 0;

% lateral state space model 
% x_lat = [z_tilde; theta_tilde; zdot_tilde; thetadot_tilde]
% u_lat = tau_tilde, y_lat = [z_tilde; theta_tilde]
P.A_lat = [0, 0, 1, 0;
                0, 0, 0, 1;
                0, -P.g, -P.mu/P.m, 0;
                0, 0, 0, 0];
P.B_lat = [0;
                0;
                0;
                1/P.J];
P.C_lat = [1, 0, 0, 0;
                0, 1, 0, 0];
P.D_lat = [0;
                0];
end