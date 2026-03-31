% State variable form for VTOL system

this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch02_vtolKE.m'));

syms zv h theta zvddot hddot thetaddot real
syms F tau mu g Fwind real

% Generalized coordinates
q = [zv; h; theta];
qdot = [zvdot; hdot; thetadot];
qddot = [zvddot; hddot; thetaddot];

% Potential energy
P = simplify((mc + mr + ml)*g*h);

% Lagrangian
L = simplify(K - P);

disp('Potential energy P =')
pretty(P)

disp('Lagrangian L =')
pretty(L)

<<<<<<< HEAD
% euler lagrange equations
=======
% Euler-Lagrange equations
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dLdqdot = jacobian(L, qdot).';
dLdq = jacobian(L, q).';
d_dt_dLdqdot = jacobian(dLdqdot, [q; qdot]) * [qdot; qddot];
EL_case_studyF = simplify(d_dt_dLdqdot - dLdq);

disp('Euler-Lagrange expression =')
pretty(EL_case_studyF)

% Generalized nonconservative forces
% Lateral:  -F*sin(theta) - mu*zvdot + Fwind
% Vertical:  F*cos(theta)
% Rotation:  tau
RHS = [ -F*sin(theta) - mu*zvdot + Fwind;
         F*cos(theta);
         tau ];

full_eom = simplify(EL_case_studyF - RHS);

<<<<<<< HEAD
% Solve for highest order derivatives
=======
% Solve for highest-order derivatives
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
sol = solve(full_eom == 0, [zvddot, hddot, thetaddot]);

zvddot_eom = simplify(sol.zvddot);
hddot_eom = simplify(sol.hddot);
thetaddot_eom = simplify(sol.thetaddot);

disp('zvddot equation =')
pretty(zvddot_eom)

disp('hddot equation =')
pretty(hddot_eom)

disp('thetaddot equation =')
pretty(thetaddot_eom)

<<<<<<< HEAD
% State variable form
=======
% State-variable form
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
state = [zv;
         h;
         theta;
         zvdot;
         hdot;
         thetadot];

ctrl_input = [F;
              tau];

state_dot = [zvdot;
             hdot;
             thetadot;
             zvddot_eom;
             hddot_eom;
             thetaddot_eom];

disp('State derivative xdot =')
pretty(state_dot)

% Numeric 
vtol_dir = fileparts(this_dir);
addpath(vtol_dir);

Pnum = vtolParams();

eom = matlabFunction(state_dot, ...
    'Vars', {zv, h, theta, zvdot, hdot, thetadot, F, tau, ...
             mc, mr, ml, Jc, d, mu, g, Fwind});

xdot_test = eom(0, 5, 0, 0, 0, 0, Pnum.Fe, 0, ...
    Pnum.mc, Pnum.mr, Pnum.ml, Pnum.Jc, Pnum.d, Pnum.mu, Pnum.g, Pnum.F_wind);

disp('x_dot test at hover input =')
disp(xdot_test)