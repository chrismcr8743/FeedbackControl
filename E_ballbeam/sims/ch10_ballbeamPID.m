classdef ch10_ballbeamPID < handle
    properties
        sigma
        Ts
        beta

        % inner loop PD
        kp_th
        kd_th
        k_DC_th

        % outer loop PID
        kp_z
        ki_z
        kd_z

        theta_max
        F_max

        integrator_z
        error_z_d1
        z_dot
        z_d1
        theta_dot
        theta_d1
    end

    methods
        function self = ch10_ballbeamPID()
            P = ballbeamParams();

            self.sigma = 0.05;
            self.Ts = P.Ts;
            self.beta = (2*self.sigma - self.Ts) / (2*self.sigma + self.Ts);

            self.theta_max = 9*pi/180;
            self.F_max = P.F_max;

            tr_th = .129;
            zeta_th = 0.707;

            ze = P.length/2;
            Je = P.m1*ze^2 + P.m2*P.length^2/3.0;

            wn_th = 2.2 / tr_th;
            b0_th = P.length / Je;

            self.kp_th = wn_th^2 / b0_th;
            self.kd_th = 2*zeta_th*wn_th / b0_th;
            self.k_DC_th = 1.0;

            tr_z = 10.0 * tr_th;
            zeta_z = 0.707;
            wn_z = 2.2 / tr_z;

            self.kp_z = -(wn_z^2) / (P.g * self.k_DC_th);
            self.kd_z = -(2*zeta_z*wn_z) / (P.g * self.k_DC_th);

            self.ki_z = -0.19;

            fprintf('kp_th:  %f\n', self.kp_th);
            fprintf('kd_th:  %f\n', self.kd_th);
            fprintf('k_DC_th:%f\n', self.k_DC_th);
            fprintf('kp_z:   %f\n', self.kp_z);
            fprintf('ki_z:   %f\n', self.ki_z);
            fprintf('kd_z:   %f\n', self.kd_z);

            self.integrator_z = 0.0;
            self.error_z_d1 = 0.0;
            self.z_dot = 0.0;
            self.z_d1 = P.z0;
            self.theta_dot = 0.0;
            self.theta_d1 = P.theta0;
        end

        function F = update(self, z_r, y)
            z = y(1);
            theta = y(2);

            P = ballbeamParams();

            % outer loop
            error_z = z_r - z;
            self.z_dot = self.beta*self.z_dot + (1-self.beta)/self.Ts * (z - self.z_d1);

            if abs(self.z_dot) < 0.02
                self.integrator_z = self.integrator_z + (self.Ts/2) * (error_z + self.error_z_d1);
            end

            theta_r = self.kp_z*error_z + self.ki_z*self.integrator_z - self.kd_z*self.z_dot;
            theta_r = saturate(theta_r, self.theta_max);

            % inner loop
            error_th = theta_r - theta;
            self.theta_dot = self.beta*self.theta_dot + (1-self.beta)/self.Ts * (theta - self.theta_d1);
            F_tilde = self.kp_th*error_th - self.kd_th*self.theta_dot;
            F_eq = (P.m1*P.g*z + P.m2*P.g*P.length/2) / P.length;

            F = F_eq + F_tilde;
            F = saturate(F, self.F_max);

            self.error_z_d1 = error_z;
            self.z_d1 = z;
            self.theta_d1 = theta;
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end

