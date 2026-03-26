% State variable form for ballbeam system

this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch02_ballbeamKE.m'));

syms g F zddot thetaddot real

% Potential energy
PE = simplify(m1*g*z*sin(theta) + m2*g*(ell/2)*sin(theta));

% Lagrangian
L = simplify(K - PE);

disp('Potential energy P =')
pretty(PE)

disp('Lagrangian L =')
pretty(L)

% Generalized coordinates
q = [z; theta];
qdot = [zdot; thetadot];
qddot = [zddot; thetaddot];

% Euler-Lagrange equations
dLdqdot = jacobian(L, qdot).';
dLdq = jacobian(L, q).';
d_dt_dLdqdot = jacobian(dLdqdot, [q; qdot]) * [qdot; qddot];
EL_case_studyE = simplify(d_dt_dLdqdot - dLdq);

disp('Euler-Lagrange expression =')
pretty(EL_case_studyE)

% Generalized input
RHS = [0;
       F*ell*cos(theta)];

full_eom = simplify(EL_case_studyE - RHS);

% Solve for highest order derivatives
sol = solve(full_eom == 0, [zddot, thetaddot]);

zddot_eom = simplify(sol.zddot);
thetaddot_eom = simplify(sol.thetaddot);

disp('zddot equation =')
pretty(zddot_eom)

disp('thetaddot equation =')
pretty(thetaddot_eom)

% State-variable form
state = [z;
         theta;
         zdot;
         thetadot];

ctrl_input = F;

state_dot = [zdot;
             thetadot;
             zddot_eom;
             thetaddot_eom];

disp('State derivative xdot =')
pretty(state_dot)


% beam_dir = fileparts(this_dir);
% addpath(beam_dir);
% 
% Pnum = ballbeamParams();
% eom = matlabFunction(state_dot, ...
%     'Vars', {z, theta, zdot, thetadot, F, m1, m2, ell, g});
% 
% xdot_test = eom(Pnum.length/2, 0, 0, 0, 1, Pnum.m1, Pnum.m2, Pnum.length, Pnum.g);
% 
% disp('x_dot test at [ell/2 0 0 0], input 1 =')
% disp(xdot_test)