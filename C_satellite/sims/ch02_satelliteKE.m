clearvars
clc
syms Js Jp thetadot phidot real
K = simplify(1/2*Js*thetadot^2 + 1/2*Jp*phidot^2);
disp('Kinetic energy K =')
pretty(K)