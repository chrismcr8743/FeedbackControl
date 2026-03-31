% Symbolic state variable form for the msd system

this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch02_massKE.m'));

% symbols
syms z zdot zddot F b k real

% potential energy
P = simplify(1/2 * k * z^2);

% lagrangian
L = simplify(K - P);

disp('Potential energy P =')
pretty(P)

disp('Lagrangian L =')
pretty(L)

% generalized coordinate and derivatives
q = z;
qdot = zdot;
qddot = zddot;

% euler lagrange eqn
dLdqdot = diff(L, qdot);
d_dt_dLdqdot = diff(dLdqdot, z) * zdot + diff(dLdqdot, zdot) * zddot;
dLdq = diff(L, q);

EL_case_studyD = simplify(d_dt_dLdqdot - dLdq);

disp('Euler-Lagrange expression =')
pretty(EL_case_studyD)

% include damping and generalized force
eom_eq = simplify(EL_case_studyD - (F - b*zdot));

disp('Equation of motion = 0:')
pretty(eom_eq)

% solve for zddot
zddot_eom = simplify(solve(eom_eq == 0, zddot));

disp('zddot equation =')
pretty(zddot_eom)

% state-variable form
state = [z;
         zdot];

ctrl_input = F;

state_dot = [zdot;
             zddot_eom];

disp('State derivative xdot =')
pretty(state_dot)

