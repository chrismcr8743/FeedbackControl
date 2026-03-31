clearvars
clc

% Define symbolic variables
syms m ell theta thetadot real

% Position of the center of mass
p = [ell/2*cos(theta);
     ell/2*sin(theta);
     0];

% Velocity of the center of mass using chain rule
v = jacobian(p, theta) * thetadot;

% Angular velocity for a planar arm
omega = [0; 0; thetadot];

% Inertia tensor of a slender rod about its center of mass
J = diag([0, (1/12)*m*ell^2, (1/12)*m*ell^2]);

% Rotation matrix
R = [cos(theta), -sin(theta), 0;
     sin(theta),  cos(theta), 0;
     0,           0,          1];

% Kinetic energy
K = simplify(1/2*m*(v.'*v) + 1/2*(omega.'*R*J*R.'*omega));
K = simplify(K(1));

disp('Kinetic energy K =')
pretty(K)