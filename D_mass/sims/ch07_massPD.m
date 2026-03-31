classdef ch07_massPD < handle
    properties
        kp
        kd
        F_max
    end

    methods
        function self = ch07_massPD()
            P = massParams();
            p1 = -1.0;
            p2 = -1.5;

            alpha1 = -(p1 + p2);   
            alpha0 = p1 * p2;      

            self.kd = P.m*alpha1 - P.b;
            self.kp = P.m*alpha0 - P.k;

            self.F_max = P.F_max;

            fprintf('kp: %f\n', self.kp);
            fprintf('kd: %f\n', self.kd);
        end

        function F_sat = update(self, z_r, state)
            z = state(1);
            zdot = state(2);

            F = self.kp*(z_r - z) - self.kd*zdot;

            F_sat = saturate(F, self.F_max);
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end