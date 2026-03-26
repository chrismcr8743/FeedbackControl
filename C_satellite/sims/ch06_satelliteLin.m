% Linearization for satellite system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch03_satelliteSV.m'));

% State derivative, states, and input
state_variable_form = state_dot;
states = state;
inputs = ctrl_input;

% Jacobians
A = jacobian(state_variable_form, states);
B = jacobian(state_variable_form, inputs);

% Linearize about the standard equilibrium:
% theta = 0, phi = 0, thetadot = 0, phidot = 0, tau = 0
A_lin = simplify(subs(A, ...
    {theta, phi, thetadot, phidot, tau}, ...
    {0, 0, 0, 0, 0}));

B_lin = simplify(subs(B, ...
    {theta, phi, thetadot, phidot, tau}, ...
    {0, 0, 0, 0, 0}));

disp('A_lin =')
pretty(A_lin)

disp('B_lin =')
pretty(B_lin)