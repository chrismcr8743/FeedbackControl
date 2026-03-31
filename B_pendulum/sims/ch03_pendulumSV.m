this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch02_pendulumKE.m'));

% additional symbols
syms zdd thetadd F b real

% potential energy
P = simplify(m1*g*ell/2*(cos(theta) - 1));

% lagrangian
L = simplify(K - P);

disp('Potential energy P =')
pretty(P)

disp('Lagrangian L =')
pretty(L)

% convenience vectors
q = [z; theta];
qdot = [zd; thetad];
qdd = [zdd; thetadd];

% Euler-Lagrange:
% d/dt(dL/dqdot) - dL/dq
dLdqdot = jacobian(L, qdot).';
dLdq = jacobian(L, q).';

d_dt_dLdqdot = jacobian(dLdqdot, [q; qdot]) * [qdot; qdd];
EL_case_studyB = simplify(d_dt_dLdqdot - dLdq);

disp('Euler-Lagrange expression =')
pretty(EL_case_studyB)

% include friction and generalized forces
RHS = [F - b*zd;
       0];

full_eom = simplify(EL_case_studyB - RHS);

% solve for highest order derivatives
sol = solve(full_eom == 0, [zdd, thetadd]);

zdd_eom = simplify(sol.zdd);
thetadd_eom = simplify(sol.thetadd);

disp('zdd equation =')
pretty(zdd_eom)

disp('thetadd equation =')
pretty(thetadd_eom)

% define state variables and state derivative
state = [z; theta; zd; thetad];
ctrl_input = F;

state_dot = [zd;
             thetad;
             zdd_eom;
             thetadd_eom];

disp('State derivative xdot =')
pretty(state_dot)

% optional callable function for testing
Pnum = pendulumParams();
eom = matlabFunction(state_dot, ...
    'Vars', {z, theta, zd, thetad, F, m1, m2, ell, b, g});

xdot_test = eom(0, 0, 0, 0, 1, Pnum.m1, Pnum.m2, Pnum.ell, Pnum.b, Pnum.g);

disp('x_dot test at [0 0 0 0], input 1 =')
disp(xdot_test)