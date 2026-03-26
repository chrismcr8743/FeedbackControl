% Kinetic energy for the MSD system
clearvars
clc
syms m zdot real
K = simplify(1/2 * m * zdot^2);
disp('Kinetic energy K =')
pretty(K)