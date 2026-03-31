<<<<<<< HEAD
syms m1 m2 ell g real
syms z theta zd thetad real

=======
%% ch02_pendulumKE
% MATLAB version of hw02_pendulum_finding_KE.py

% symbolic variables
syms m1 m2 ell g real
syms z theta zd thetad real

% generalized coordinates
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
q = [z; theta];
qdot = [zd; thetad];

% positions
p1 = [z + ell/2*sin(theta);
<<<<<<< HEAD
        ell/2*cos(theta);
        0];

p2 = [z;
         0;
         0];
=======
      ell/2*cos(theta);
      0];

p2 = [z;
      0;
      0];
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468

% velocities via chain rule
v1 = jacobian(p1, q) * qdot;
v2 = jacobian(p2, q) * qdot;

% angular velocity of rod
omega = [0; 0; thetad];

% rotation matrix of rod
R = [cos(theta), -sin(theta), 0;
     sin(theta),  cos(theta), 0;
     0,           0,          1];

<<<<<<< HEAD
% inertia tensor of rod about its center of mass
J = diag([0, m1*ell^2/12, m1*ell^2/12]);

% kinetic energy
K = simplify(1/2*m1*(v1.'*v1) + ...
                   1/2*m2*(v2.'*v2) + ...
                   1/2*(omega.'*R*J*R.'*omega) );
=======
% inertia tensor of rod about its COM
J = diag([0, m1*ell^2/12, m1*ell^2/12]);

% kinetic energy
K = simplify( ...
    1/2*m1*(v1.'*v1) + ...
    1/2*m2*(v2.'*v2) + ...
    1/2*(omega.'*R*J*R.'*omega) );
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468

K = simplify(K(1));

disp('Kinetic energy K =')
pretty(K)