clc;
clear;
close all;

P = ballbeamParams();

% inner loop gains
ze = P.length/2;
Je = P.m1*ze^2 + P.m2*P.length^2/3;

tr_th = 1.0;
zeta_th = 0.707;
wn_th = 2.2/tr_th;

b0_th = P.length/Je;

kp_th = wn_th^2 / b0_th;
kd_th = 2*zeta_th*wn_th / b0_th;
k_DC_th = 1.0;   

% outer loop PD gains
tr_z = 10*tr_th;
zeta_z = 0.707;
wn_z = 2.2/tr_z;

kp_z = -(wn_z^2)/(P.g*k_DC_th);
kd_z = -(2*zeta_z*wn_z)/(P.g*k_DC_th);

fprintf('kp_th   = %f\n', kp_th);
fprintf('kd_th   = %f\n', kd_th);
fprintf('k_DC_th = %f\n', k_DC_th);
fprintf('kp_z    = %f\n', kp_z);
fprintf('kd_z    = %f\n', kd_z);


% root locus for outer loop integrator
num = P.g*k_DC_th;
den = [1, -P.g*k_DC_th*kd_z, -P.g*k_DC_th*kp_z, 0];

L = tf(num, den);

figure(1);
rlocus(L);
grid on;

[K, poles] = rlocfind(L);
ki_z = -K;

fprintf('\nK   = %f\n', K);
fprintf('ki_z = %f\n', ki_z);
disp('closed loop poles:');
disp(poles);



