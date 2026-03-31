clc;
clear;
close all;

P = vtolParams();

% Longitudinal (h) PD gains
tr_h = 8.0;
zeta_h = 0.707;
wn_h = 2.2 / tr_h;

kPh = P.m * wn_h^2;
kDh = 2.0 * zeta_h * wn_h * P.m;

fprintf('longitudinal PD gains:\n');
fprintf('kPh = %f\n', kPh);
fprintf('kDh = %f\n\n', kDh);

% Lateral inner loop (theta) PD gains
tr_th = 0.8;
zeta_th = 0.707;
wn_th = 2.2 / tr_th;

kPth = P.J * wn_th^2;
kDth = 2.0 * zeta_th * wn_th * P.J;
kDCth = 1.0;

fprintf('lateral inner loop PD gains:\n');
fprintf('kPth  = %f\n', kPth);
fprintf('kDth  = %f\n', kDth);
fprintf('kDCth = %f\n\n', kDCth);

% Lateral outer loop (z) PD gains
tr_z = 10.0 * tr_th;
zeta_z = 0.707;
wn_z = 2.2 / tr_z;

b0_z = P.g * kDCth;
a1_z = P.mu / P.m;

kPz = -(wn_z^2) / b0_z;
kDz = (a1_z - 2.0*zeta_z*wn_z) / b0_z;

fprintf('lateral outer loop PD gains:\n');
fprintf('kPz = %f\n', kPz);
fprintf('kDz = %f\n\n', kDz);

num_h = 1;
den_h = [P.m, kDh, kPh, 0];

L_h = tf(num_h, den_h);

figure(1);
rlocus(L_h);
grid on;
title('longitudinal root locus for k_{Ih}');

[K_h, poles_h] = rlocfind(L_h);
kIh = K_h;

fprintf('longitudinal integrator gain:\n');
fprintf('kIh = %f\n', kIh);
disp('closed loop poles for longitudinal loop:');
disp(poles_h);

num_z = P.g * kDCth;
den_z = [1, (P.mu/P.m) - P.g*kDCth*kDz, -P.g*kDCth*kPz, 0];

L_z = tf(num_z, den_z);

figure(2);
rlocus(L_z);
grid on;
title('lateral outer loop root locus for K = -k_{Iz}');

[K_z, poles_z] = rlocfind(L_z);
kIz = -K_z;

fprintf('\nouter loop integrator gain:\n');
fprintf('K   = %f\n', K_z);
fprintf('kIz = %f\n', kIz);
disp('closed loop poles for lateral outer loop:');
disp(poles_z);