<<<<<<< HEAD
=======
%% ch06_pendulumLin
% MATLAB version of hw06_pendulum_linearization.py

>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch03_pendulumSV.m'));

% define derivative of states, states, and input
state_variable_form = state_dot;
states = state;
inputs = ctrl_input;

% Jacobians
A = jacobian(state_variable_form, states);
B = jacobian(state_variable_form, inputs);

% linearize about equilibrium:
% z = 0, theta = 0, zd = 0, thetad = 0, F = 0
A_lin = simplify(subs(A, ...
    {z, theta, zd, thetad, F}, ...
    {0, 0, 0, 0, 0}));

B_lin = simplify(subs(B, ...
    {z, theta, zd, thetad, F}, ...
    {0, 0, 0, 0, 0}));

disp('A_lin =')
pretty(A_lin)

disp('B_lin =')
pretty(B_lin)