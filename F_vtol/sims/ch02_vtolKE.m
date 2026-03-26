% Kinetic energy for VTOL system
clc
syms mc mr ml Jc d zvdot hdot thetadot real
m = mc + mr + ml; % Total mass
J = Jc + mr*d^2 + ml*d^2; % Rotational inertia
K = simplify(1/2*m*(zvdot^2 + hdot^2) + 1/2*J*thetadot^2 ); % Kinetic energy
disp('Kinetic energy K =')
pretty(K)