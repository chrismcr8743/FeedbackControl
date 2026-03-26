classdef ch07_massPD < handle
    properties
        kp
        kd
        F_max
    end

    methods
        function self = ch07_massPD()
            P = massParams();

            % place closed loop poles at -1 and -1.5
            p1 = -1.0;
            p2 = -1.5;

            % desired characteristic polynomial:
            % (s-p1)(s-p2) = s^2 - (p1+p2)s + p1*p2
            alpha1 = -(p1 + p2);   % 2.5
            alpha0 = p1 * p2;      % 1.5

            % plant: m*zddot + b*zdot + k*z = F
            % closed-loop characteristic polynomial with PD:
            % m*s^2 + (b+kd)*s + (k+kp)
            self.kd = P.m*alpha1 - P.b;
            self.kp = P.m*alpha0 - P.k;

            self.F_max = P.F_max;

            fprintf('kp: %f\n', self.kp);
            fprintf('kd: %f\n', self.kd);
        end

        function F_sat = update(self, z_r, state)
            % state = [z; zdot]
            z = state(1);
            zdot = state(2);

            % PD control
            F = self.kp*(z_r - z) - self.kd*zdot;

            % saturate
            F_sat = saturate(F, self.F_max);
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end