classdef ch10_pendulumPID < handle
    properties
        sigma

        kp_th
        kd_th
        kp_z
        ki_z
        kd_z

        theta_max

        % outer loop states
        integrator_z
        error_z_prev
        z_dot
        z_prev

        % inner loop states
        theta_dot
        theta_prev

        % zero canceling filter states
        filter_a
        filter_b
        filter_state
    end

    methods
        function self = ch10_pendulumPID()
            P = pendulumParams();

            % dirty derivative parameter
            self.sigma = 0.05;

            % tuning parameters 
            tr_th = 0.2;
            zeta_th = 0.707;
            M = 10.0;
            zeta_z = 0.707;
            self.ki_z = -0.05;

            % saturation limit on commanded theta
            self.theta_max = 30.0 * pi / 180.0;

            %---------------------------------------------------
            % Inner loop
            %---------------------------------------------------
            b0_th = -1.0 / (P.m1*(P.ell/6.0) + P.m2*(2.0*P.ell/3.0));
            a1_th = 0.0;
            a0_th = -(P.m1 + P.m2)*P.g / ...
                (P.m1*(P.ell/6.0) + P.m2*(2.0*P.ell/3.0));

            wn_th = 2.2 / tr_th;
            alpha1_th = 2.0 * zeta_th * wn_th;
            alpha0_th = wn_th^2;

            self.kp_th = (alpha0_th - a0_th) / b0_th;
            self.kd_th = (alpha1_th - a1_th) / b0_th;

            DC_gain = self.kp_th / ((P.m1 + P.m2) * P.g + self.kp_th);

            %---------------------------------------------------
            % Outer loop
            %---------------------------------------------------
            tr_z = M * tr_th;
            wn_z = 2.2 / tr_z;

            a = -(wn_z^2) * sqrt(2.0 * P.ell / (3.0 * P.g));
            b = (a - 2.0 * zeta_z * wn_z) * sqrt(2.0 * P.ell / (3.0 * P.g));

            self.kd_z = b / (1.0 - b);
            self.kp_z = a * (1.0 + self.kd_z);

            fprintf('DC_gain: %f\n', DC_gain);
            fprintf('kp_th: %f\n', self.kp_th);
            fprintf('kd_th: %f\n', self.kd_th);
            fprintf('kp_z: %f\n', self.kp_z);
            fprintf('ki_z: %f\n', self.ki_z);
            fprintf('kd_z: %f\n', self.kd_z);

            %---------------------------------------------------
            % zero canceling filter
            %---------------------------------------------------
            self.filter_a = -3.0 / (2.0 * P.ell * DC_gain);
            self.filter_b = sqrt(3.0 * P.g / (2.0 * P.ell));
            self.filter_state = 0.0;

            %---------------------------------------------------
            % initialize integrators and differentiators
            %---------------------------------------------------
            self.integrator_z = 0.0;
            self.error_z_prev = 0.0;
            self.z_dot = P.zdot0;
            self.z_prev = P.z0;
            self.theta_dot = P.thetadot0;
            self.theta_prev = P.theta0;
        end

        function F = update(self, z_r, y)
            P = pendulumParams();

            % measured output only
            z = y(1);
            theta = y(2);

            %---------------------------------------------------
            % outer loop (z control)
            %---------------------------------------------------
            error_z = z_r - z;

            self.z_dot = ...
                (2.0*self.sigma - P.Ts)/(2.0*self.sigma + P.Ts) * self.z_dot ...
                + (2.0/(2.0*self.sigma + P.Ts)) * (z - self.z_prev);

            if abs(self.z_dot) < 0.07
                self.integrator_z = self.integrator_z ...
                    + (P.Ts/2.0) * (error_z + self.error_z_prev);
            end

            theta_r_unsat = self.kp_z * error_z ...
                          + self.ki_z * self.integrator_z ...
                          - self.kd_z * self.z_dot;

            theta_r = saturate(theta_r_unsat, self.theta_max);

            % zero canceling filter
            theta_r = self.filter_update(theta_r);

            %---------------------------------------------------
            % inner loop (theta control)
            %---------------------------------------------------
            error_th = theta_r - theta;

            self.theta_dot = ...
                (2.0*self.sigma - P.Ts)/(2.0*self.sigma + P.Ts) * self.theta_dot ...
                + (2.0/(2.0*self.sigma + P.Ts)) * (theta - self.theta_prev);

            F_unsat = self.kp_th * error_th - self.kd_th * self.theta_dot;
            F = saturate(F_unsat, P.F_max);

            % update delayed variables
            self.error_z_prev = error_z;
            self.z_prev = z;
            self.theta_prev = theta;
        end

        function y = filter_update(self, input_val)
            P = pendulumParams();
            self.filter_state = self.filter_state ...
                + P.Ts * (-self.filter_b * self.filter_state + self.filter_a * input_val);
            y = self.filter_state;
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end