clc;
clear;
close all;

P = massParams();

% D.8 pd gains 
tr_z = 2;
zeta_z = 0.707;
wn_z = 2.2/tr_z;

kp = P.m*wn_z^2 - P.k;
kd = 2*zeta_z*wn_z*P.m - P.b;

fprintf('kp = %f\n', kp);
fprintf('kd = %f\n', kd);

num = 1;
den = [P.m, P.b + kd, P.k + kp, 0];

L = tf(num, den);

figure(1);
rlocus(L);
grid on;

[K, poles] = rlocfind(L);
ki = K;

fprintf('\nki = %f\n', ki);
disp('closed loop poles:');
disp(poles);
