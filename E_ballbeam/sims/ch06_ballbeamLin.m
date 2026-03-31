% Linearization for ballbeam system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch03_ballbeamSV.m'));

syms ze Fe real

% Jacobians of the first order state model
A = jacobian(state_dot, state);
B = jacobian(state_dot, ctrl_input);

Fe_expr = simplify((m1*g*ze + m2*g*ell/2)/ell);

A_jac = simplify(subs(A, ...
    {z, theta, zdot, thetadot, F}, ...
    {ze, 0, 0, 0, Fe_expr}));

B_jac = simplify(subs(B, ...
    {z, theta, zdot, thetadot, F}, ...
    {ze, 0, 0, 0, Fe_expr}));

disp('A from Jacobian =')
pretty(A_jac)

disp('B from Jacobian =')
pretty(B_jac)

Je = simplify(m1*ze^2 + m2*ell^2/3);

A_lin = [0, 0, 1, 0;
         0, 0, 0, 1;
         0, -g, 0, 0;
         -(m1*g)/Je, 0, 0, 0];

B_lin = [0;
         0;
         0;
         ell/Je];

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