classdef ch08_massPD < handle
    properties
        kp
        kd
        kr
        F_max
        use_saturation
        tr
        zeta
    end

    methods
        function self = ch08_massPD(mode, tr_override)

            if nargin < 1
                mode = 'a';
            end

            P = massParams();

            self.zeta = 0.7;
            self.F_max = 6.0;

            switch lower(mode)
                case 'a'
                    self.tr = 2.0;
                    self.use_saturation = false;

                case 'b'
                    self.tr = 2.019;   
                    self.use_saturation = true;

                otherwise
                    error('Unknown mode. use ''a'' or ''b''.');
            end

            if nargin >= 2
                self.tr = tr_override;
            end

            wn = 2.2 / self.tr;
            alpha1 = 2.0 * self.zeta * wn;
            alpha0 = wn^2;

            % m*zddot + b*zdot + k*z = F
            self.kp = P.m * alpha0 - P.k;
            self.kd = P.m * alpha1 - P.b;

            % reference feedforward to remove steady state error
            self.kr = P.k;

            fprintf('mode: %s\n', mode);
            fprintf('tr: %f\n', self.tr);
            fprintf('zeta: %f\n', self.zeta);
            fprintf('kp: %f\n', self.kp);
            fprintf('kd: %f\n', self.kd);
            fprintf('kr: %f\n', self.kr);
        end

        function F_cmd = update(self, z_r, state)
            z = state(1);
            zdot = state(2);

            F = self.kp*(z_r - z) - self.kd*zdot + self.kr*z_r;

            if self.use_saturation
                F_cmd = saturate(F, self.F_max);
            else
                F_cmd = F;
            end
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end