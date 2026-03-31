<<<<<<< HEAD
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch03_armSV.m'));

=======
%% ch06_armLin
% MATLAB version of hw06_arm_linearization.py

this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch03_armSV.m'));

% Define derivative of states, states, and input symbolically
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
f = state_dot;
x = state;
uin = u;

% Jacobians
A = jacobian(f, x);
B = jacobian(f, uin);

% Equilibrium:
% theta_e = 0
% thetadot_e = 0
% tau_e = m*g*ell/2
tau_e = m*g*ell/2;

A_lin = simplify(subs(A, ...
    {theta_sym, thetadot_sym, uin}, ...
    {0, 0, tau_e}));

B_lin = simplify(subs(B, ...
    {theta_sym, thetadot_sym, uin}, ...
    {0, 0, tau_e}));

disp('A_lin =')
pretty(A_lin)

disp('B_lin =')
pretty(B_lin)