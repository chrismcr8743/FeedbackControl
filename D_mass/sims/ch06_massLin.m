% Linearization for the msd system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch03_massSV.m'));

% derivative of states, states, and input
state_variable_form = state_dot;
states = state;
inputs = ctrl_input;

% Jacobians
A = jacobian(state_variable_form, states);
B = jacobian(state_variable_form, inputs);

% linearize about the standard equilibrium:
% z = 0, zdot = 0, F = 0
A_lin = simplify(subs(A, ...
    {z, zdot, F}, ...
    {0, 0, 0}));

B_lin = simplify(subs(B, ...
    {z, zdot, F}, ...
    {0, 0, 0}));

disp('A_lin =')
pretty(A_lin)

disp('B_lin =')
pretty(B_lin)