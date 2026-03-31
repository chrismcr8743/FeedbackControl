% Linearization for the VTOL system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch03_vtolSV.m'));

syms ze he Fe real

% Jacobians of the first order state model
A = jacobian(state_dot, state);
B = jacobian(state_dot, ctrl_input);

% Hover equilibrium:
% zv = ze, h = he, theta = 0
% zvdot = 0, hdot = 0, thetadot = 0
% Fe = (mc + mr + ml)*g
% tau_e = 0
Fe_expr = simplify((mc + mr + ml)*g);

A_jac = simplify(subs(A, ...
    {zv, h, theta, zvdot, hdot, thetadot, F, tau}, ...
    {ze, he, 0, 0, 0, 0, Fe_expr, 0}));

B_jac = simplify(subs(B, ...
    {zv, h, theta, zvdot, hdot, thetadot, F, tau}, ...
    {ze, he, 0, 0, 0, 0, Fe_expr, 0}));

disp('A from Jacobian =')
pretty(A_jac)

disp('B from Jacobian =')
pretty(B_jac)

m = mc + mr + ml;
J = Jc + mr*d^2 + ml*d^2;

A_lin = [0, 0, 0, 1, 0, 0;
         0, 0, 0, 0, 1, 0;
         0, 0, 0, 0, 0, 1;
         0, 0, -Fe_expr/m, -mu/m, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0];

B_lin = [0,   0;
         0,   0;
         0,   0;
         0,   0;
         1/m, 0;
         0,   1/J];

disp(' ')
disp('Simplified A_lin =')
pretty(A_lin)

disp('Simplified B_lin =')
pretty(B_lin)

disp(' ')
disp('Check A_jac - A_lin =')
pretty(simplify(A_jac - A_lin))

disp('Check B_jac - B_lin =')
pretty(simplify(B_jac - B_lin))