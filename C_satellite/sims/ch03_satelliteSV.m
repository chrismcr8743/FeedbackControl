% State variable form for the satellite system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch02_satelliteKE.m'));

syms theta phi thetaddot phiddot k b tau real

% Generalized coordinates
q = [theta; phi];
qdot = [thetadot; phidot];
qdd = [thetaddot; phiddot];

P = simplify(1/2*k*(phi - theta)^2); % Potential energy from torsional spring

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
d_dt_dLdqdot = jacobian(dLdqdot, [q; qdot]) * [qdot; qdd];
EL_case_studyC = simplify(d_dt_dLdqdot - dLdq);

disp('Euler-Lagrange expression =')
pretty(EL_case_studyC)

% Generalized input + damping torques
RHS = [tau - b*(thetadot - phidot);
       -b*(phidot - thetadot)];

full_eom = simplify(EL_case_studyC - RHS);

<<<<<<< HEAD
% Solve for highest order derivatives
=======
% Solve for highest-order derivatives
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
sol = solve(full_eom == 0, [thetaddot, phiddot]);

thetaddot_eom = simplify(sol.thetaddot);
phiddot_eom = simplify(sol.phiddot);

disp('thetaddot equation =')
pretty(thetaddot_eom)

disp('phiddot equation =')
pretty(phiddot_eom)

<<<<<<< HEAD
% State variable form
=======
% State-variable form
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
state = [theta;
         phi;
         thetadot;
         phidot];

ctrl_input = tau;

state_dot = [thetadot;
             phidot;
             thetaddot_eom;
             phiddot_eom];

disp('State derivative xdot =')
pretty(state_dot)