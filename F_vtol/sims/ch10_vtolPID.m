classdef ch10_vtolPID < handle
    properties
        % altitude loop
        kp_h
        ki_h
        kd_h

        % lateral inner loop
        kp_th
        kd_th

        % lateral outer loop
        kp_z
        ki_z
        kd_z

        % derivative filter
        sigma
        Ts
        beta

        % limits
        Fe
        theta_max
        F_max
        tau_max

        % altitude memory
        h_d1
        h_dot
        integrator_h
        error_h_d1

        % lateral memory
        z_d1
        z_dot
        integrator_z
        error_z_d1

        % pitch memory
        theta_d1
        theta_dot
    end

    methods
        function self = ch10_vtolPID()
            P = vtolParams();

            % dirty derivative setup
            self.sigma = 0.05;
            self.Ts = P.Ts;
            self.beta = (2*self.sigma - self.Ts) / (2*self.sigma + self.Ts);

            m = P.mc + 2*P.mr;
            J = P.Jc + 2*P.mr*(P.d^2);

            self.Fe = m * P.g;
            self.theta_max = 14.21*pi/180;
            self.F_max = 2*P.F_max;          % total thrust limit
            self.tau_max = 2*P.F_max*P.d;    % torque limit

            zeta = 0.707;

            % Altitude loop 
            tr_h = 1.1066; 
            wn_h = 2.2 / tr_h;

            b0_h = 1 / m;
            alpha1_h = 2 * zeta * wn_h;
            alpha0_h = wn_h^2;

            self.kd_h = alpha1_h / b0_h;
            self.kp_h = alpha0_h / b0_h;
            self.ki_h = 1.4000; 

            % Pitch inner loop 
            tr_th = 0.3; 
            wn_th = 2.2 / tr_th;

            b0_th = 1 / J;
            alpha1_th = 2 * zeta * wn_th;
            alpha0_th = wn_th^2;

            self.kp_th = alpha0_th / b0_th;
            self.kd_th = alpha1_th / b0_th;

            % Lateral outer loop 
            tr_z = (10/2) * tr_th;  

            wn_z = 2.2 / tr_z;

            b0_z = -P.g;
            a1 = P.mu / m;

            alpha1_z = 2 * zeta * wn_z;
            alpha0_z = wn_z^2;

            self.kp_z = alpha0_z / b0_z;
            self.kd_z = (alpha1_z - a1) / b0_z;

            self.ki_z = -0.05; 

            fprintf('kp_h:  %f\n', self.kp_h);
            fprintf('ki_h:  %f\n', self.ki_h);
            fprintf('kd_h:  %f\n', self.kd_h);
            fprintf('kp_th: %f\n', self.kp_th);
            fprintf('kd_th: %f\n', self.kd_th);
            fprintf('kp_z:  %f\n', self.kp_z);
            fprintf('ki_z:  %f\n', self.ki_z);
            fprintf('kd_z:  %f\n', self.kd_z);

            % initialize memory
            self.h_d1 = P.h0;
            self.h_dot = P.hdot0;
            self.integrator_h = 0.0;
            self.error_h_d1 = 0.0;

            self.z_d1 = P.z0;
            self.z_dot = P.zdot0;
            self.integrator_z = 0.0;
            self.error_z_d1 = 0.0;

            self.theta_d1 = P.theta0;
            self.theta_dot = P.thetadot0;
        end

        function u = update(self, z_r, h_r, y)
            z = y(1);
            h = y(2);
            theta = y(3);

            P = vtolParams();

            % Altitude loop
            error_h = h_r - h;

            self.h_dot = self.beta*self.h_dot + (1-self.beta) * ((h - self.h_d1) / self.Ts);

            % only integrate when vertical motion is small
            if abs(self.h_dot) < 0.03
                self.integrator_h = self.integrator_h + (self.Ts/2) * (error_h + self.error_h_d1);
            end

            F_tilde = self.kp_h*error_h + self.ki_h*self.integrator_h - self.kd_h*self.h_dot;

            F_unsat = self.Fe + F_tilde;
            F = saturate(F_unsat, self.F_max);

            % lateral outer loop
            error_z = z_r - z;

            self.z_dot = self.beta*self.z_dot + (1-self.beta) * ((z - self.z_d1) / self.Ts);

            % trapezoidal integration
            self.integrator_z = self.integrator_z + (self.Ts/2) * (error_z + self.error_z_d1);

            theta_r_unsat = self.kp_z*error_z + self.ki_z*self.integrator_z - self.kd_z*self.z_dot;

            theta_r = saturate(theta_r_unsat, 1.5*self.theta_max);

            % anti windup
            if self.ki_z ~= 0
                self.integrator_z = self.integrator_z + self.Ts/self.ki_z * (theta_r - theta_r_unsat);
            end

            % pitch inner loop
            error_th = theta_r - theta;

            self.theta_dot = self.beta*self.theta_dot + (1-self.beta) * ((theta - self.theta_d1) / self.Ts);

            tau_unsat = self.kp_th*error_th - self.kd_th*self.theta_dot;
            tau = saturate(tau_unsat, self.tau_max);

            u = P.mixing * [F; tau];

            % update delayed variables
            self.error_h_d1 = error_h;
            self.h_d1 = h;

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