classdef ch10_armPID < handle
    properties
        kp
        ki
        kd
        sigma

        theta_dot
        theta_dot_prev
        theta_prev
        error_prev
        integrator
    end

    methods
        function self = ch10_armPID()
            P = armParams();

            % tuning parameters 
            tr = 0.6;
            zeta = 0.90;
            self.ki = 0.2;

            % desired natural frequency
            wn = 0.5*pi / (tr*sqrt(1-zeta^2));

            % compute PD gains
            alpha1 = 2.0*zeta*wn;
            alpha0 = wn^2;
            self.kp = alpha0 * (P.m * P.ell^2) / 3.0;
            self.kd = (P.m * P.ell^2) / 3.0 * ...
                (alpha1 - 3.0 * P.b / (P.m * P.ell^2));

            fprintf('kp: %f\n', self.kp);
            fprintf('ki: %f\n', self.ki);
            fprintf('kd: %f\n', self.kd);

            % dirty derivative gain
            self.sigma = 0.05;

            % controller memory
            self.theta_dot = P.thetadot0;
            self.theta_dot_prev = P.thetadot0;
            self.theta_prev = P.theta0;
            self.error_prev = 0.0;
            self.integrator = 0.0;
        end

        function tau = update(self, theta_r, y)
            P = armParams();

            % measured output only
            theta = y(1);

            % feedback linearized torque
            tau_fl = P.m * P.g * (P.ell / 2.0) * cos(theta);

            % current tracking error
            error = theta_r - theta;

            % dirty derivative of theta
            self.theta_dot = ...
                (2.0*self.sigma - P.Ts) / (2.0*self.sigma + P.Ts) * self.theta_dot_prev ...
                + (2.0 / (2.0*self.sigma + P.Ts)) * (theta - self.theta_prev);

            % integrate only when theta_dot is small
            if abs(self.theta_dot) < 0.08
                self.integrator = self.integrator + ...
                    (P.Ts / 2.0) * (error + self.error_prev);
            end

            % PID control
            tau_tilde = self.kp * error ...
                      + self.ki * self.integrator ...
                      - self.kd * self.theta_dot;

            % total torque with saturation
            tau_unsat = tau_fl + tau_tilde;
            tau = saturate(tau_unsat, P.tau_max);

            % update delayed variables
            self.error_prev = error;
            self.theta_prev = theta;
            self.theta_dot_prev = self.theta_dot;
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end