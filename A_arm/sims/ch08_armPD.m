classdef ch08_armPD < handle
    properties
        kp
        kd
    end

    methods
        function self = ch08_armPD()
            P = armParams();
            tr = 0.37;    
            zeta = 0.707;

            % desired natural frequency
            wn = 2.2 / tr;
            alpha1 = 2.0 * zeta * wn;
            alpha0 = wn^2;

            % compute PD gains
            self.kp = alpha0 * (P.m * P.ell^2) / 3.0;
            self.kd = (P.m * P.ell^2) / 3.0 * ...
                (alpha1 - 3.0 * P.b / (P.m * P.ell^2));

            fprintf('kp: %f\n', self.kp);
            fprintf('kd: %f\n', self.kd);
        end

        function tau = update(self, theta_r, state)
            theta = state(1);
            thetadot = state(2);

            P = armParams();

            % feedback linearizing torque
            tau_fl = P.m * P.g * (P.ell / 2.0) * cos(theta);

            % linearized PD torque
            tau_tilde = self.kp * (theta_r - theta) - self.kd * thetadot;

            % total torque with saturation
            tau = tau_fl + tau_tilde;
            tau = saturate(tau, P.tau_max);
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end