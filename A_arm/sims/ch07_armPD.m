classdef ch07_armPD < handle
    properties
        kp
        kd
        use_feedback_linearization = true
    end

    methods
        function self = ch07_armPD()
            P = armParams();

            % Desired characteristic polynomial from (s+3)(s+4)
            des_poles_CE = conv([1, 3], [1, 4]);
            alpha1 = des_poles_CE(2);
            alpha0 = des_poles_CE(3);

            % Linearized plant coefficients
            b0 = 3 / (P.m * P.ell^2);
            a0 = 0.0;
            a1 = 3 * P.b / (P.m * P.ell^2);

            % PD gains
            self.kp = (alpha0 - a0) / b0;
            self.kd = (alpha1 - a1) / b0;

            fprintf('kp: %f\n', self.kp);
            fprintf('kd: %f\n', self.kd);
        end

        function tau = update(self, theta_r, x)
            theta = x(1);
            thetadot = x(2);

            % Linear PD torque
            tau_tilde = self.kp * (theta_r - theta) - self.kd * thetadot;

            P = armParams();

            if self.use_feedback_linearization
                % Feedback linearization torque
                tau_fl = P.m * P.g * (P.ell / 2.0) * cos(theta);
                tau = tau_fl + tau_tilde;
            else
                % Equilibrium torque about theta_e = 0
                theta_e = 0.0;
                tau_e = P.m * P.g * P.ell / 2.0 * cos(theta_e);
                tau = tau_e + tau_tilde;
            end
        end
    end
end