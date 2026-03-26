%% ch03_armSV
% MATLAB version of hw03_arm_solving_for_state_variable_form.py

this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch02_armKE.m'));

% Additional symbolic variables
syms g b tau thetaddot real

% Potential energy
P = simplify(m*g*(ell/2)*sin(theta));

% Lagrangian
L = simplify(K - P);

disp('Potential energy P =')
pretty(P)

disp('Lagrangian L =')
pretty(L)

% Euler-Lagrange equation:
% d/dt(dL/dthetadot) - dL/dtheta = tau - b*thetadot
%
% Since L = L(theta, thetadot), apply chain rule manually:
dLdthetadot = diff(L, thetadot);
d_dt_dLdthetadot = diff(dLdthetadot, theta)*thetadot + diff(dLdthetadot, thetadot)*thetaddot;
dLdtheta = diff(L, theta);

EL_case_studyA = simplify(d_dt_dLdthetadot - dLdtheta);

disp('Euler-Lagrange expression =')
pretty(EL_case_studyA)

% Include friction and generalized force
eom_eq = simplify(EL_case_studyA - (tau - b*thetadot));

disp('Equation of motion = 0:')
pretty(eom_eq)

% Solve for theta_ddot
thetadd_eom = simplify(solve(eom_eq == 0, thetaddot));

disp('theta_ddot equation =')
pretty(thetadd_eom)

% State-variable form
syms theta_sym thetadot_sym u real

state = [theta_sym;
         thetadot_sym];

state_dot = simplify(subs([thetadot; thetadd_eom], ...
    {theta, thetadot, tau}, ...
    {theta_sym, thetadot_sym, u}));

disp('State derivative xdot =')
pretty(state_dot)

% Create callable MATLAB function
eom = matlabFunction(state_dot, ...
    'Vars', {theta_sym, thetadot_sym, u, m, ell, b, g});

% Optional generated file:
% matlabFunction(state_dot, ...
%     'Vars', {theta_sym, thetadot_sym, u, m, ell, b, g}, ...
%     'File', fullfile(this_dir, 'armEomGenerated'));

% Quick numeric check using armParams
Pnum = armParams();
xdot_test = eom(0, 0, 1.0, Pnum.m, Pnum.ell, Pnum.b, Pnum.g);

disp('Test xdot at theta=0, thetadot=0, u=1:')
disp(xdot_test)