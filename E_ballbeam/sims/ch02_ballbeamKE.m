% Kinetic energy for ballbeam system
syms m1 m2 ell z theta zdot thetadot real

q = [z; theta];
qdot = [zdot; thetadot];

% Ball position
p1 = [z*cos(theta);
         z*sin(theta);
         0];

% Beam center of mass position
p2 = [ell/2*cos(theta);
         ell/2*sin(theta);
         0];

% Velocities
v1 = jacobian(p1, q) * qdot;
v2 = jacobian(p2, q) * qdot;

% Beam angular velocity
omega = [0; 0; thetadot];

% Beam rotation matrix
R = [cos(theta), -sin(theta), 0;
     sin(theta),  cos(theta), 0;
     0,           0,          1];

% Beam inertia tensor about its center of mass
J2 = diag([0, m2*ell^2/12, m2*ell^2/12]);

% Kinetic energy
K = simplify( ...
    1/2*m1*(v1.'*v1) + ...
    1/2*m2*(v2.'*v2) + ...
    1/2*(omega.'*R*J2*R.'*omega) );

K = simplify(K(1));

disp('Kinetic energy K =')
pretty(K)