classdef ch11_armSF < handle
    properties
        K
        kr
    end

    methods
        function self = ch11_armSF()
            P = armParams();

            tr = 0.4890;
            zeta = 0.707;

            A = [0, 1;
                 0, -3.0*P.b/(P.m*(P.ell^2))];
            B = [0;
                 3.0/(P.m*(P.ell^2))];
            C = [1, 0];

            % desired poles from second order polynomial
            wn = 2.2 / tr;
            des_char_poly = [1, 2*zeta*wn, wn^2];
            des_poles = roots(des_char_poly);

            % controllability check
            if rank(ctrb(A, B)) ~= size(A, 1)
                error('The arm state-space system is not controllable.');
            end

            % place poles
            self.K = place(A, B, des_poles);

            % reference gain for unit DC gain from theta_r to theta
            self.kr = -1 / (C * inv(A - B*self.K) * B);

            fprintf('K = \n');
            disp(self.K);
            fprintf('kr = \n');
            disp(self.kr);
            fprintf('desired poles = \n');
            disp(des_poles);
        end

        function tau = update(self, theta_r, x)
            theta = x(1);

            P = armParams();

            % feedback linearizing torque
            tau_fl = P.m * P.g * (P.ell/2.0) * cos(theta);

            % state feedback
            tau_tilde = -self.K * x + self.kr * theta_r;

            % total torque with saturation
            tau = saturate(tau_fl + tau_tilde, P.tau_max);
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end