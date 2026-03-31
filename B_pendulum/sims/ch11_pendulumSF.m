classdef ch11_pendulumSF < handle
    properties
        K
        kr
    end

    methods
        function self = ch11_pendulumSF()
            P = pendulumParams();

            tr_theta = 0.5;
            tr_z = 5 * tr_theta;
            zeta_z = 0.9;
            zeta_theta = 0.9;

            % linearized state space model
            A = [...
                0.0, 0.0, 1.0, 0.0;
                0.0, 0.0, 0.0, 1.0;
                0.0, -3*P.m1*P.g/(4*(0.25*P.m1 + P.m2)), ...
                    -P.b/(0.25*P.m1 + P.m2), 0.0;
                0.0, 3*(P.m1 + P.m2)*P.g/(2*(0.25*P.m1 + P.m2)*P.ell), ...
                    3*P.b/(2*(0.25*P.m1 + P.m2)*P.ell), 0.0];

            B = [...
                0.0;
                0.0;
                1/(0.25*P.m1 + P.m2);
                -3/(2*(0.25*P.m1 + P.m2)*P.ell)];

            C = [1.0, 0.0, 0.0, 0.0;
                 0.0, 1.0, 0.0, 0.0]; 

            % desired poles
            wn_theta = 0.5*pi / (tr_theta*sqrt(1 - zeta_theta^2));
            wn_z = 0.5*pi / (tr_z*sqrt(1 - zeta_z^2));

            des_char_poly = conv( ...
                [1, 2*zeta_z*wn_z, wn_z^2], ...
                [1, 2*zeta_theta*wn_theta, wn_theta^2]);

            des_poles = roots(des_char_poly);

            % controllability check
            if rank(ctrb(A, B)) ~= 4
                error('The pendulum system is not controllable.');
            end

            % state feedback gain
            self.K = place(A, B, des_poles);

            % reference gain for z tracking
            Cr = [1.0, 0.0, 0.0, 0.0];
            self.kr = -1.0 / (Cr * inv(A - B*self.K) * B);

            fprintf('K = \n');
            disp(self.K);
            fprintf('kr = \n');
            disp(self.kr);
        end

        function F = update(self, z_r, x)
            P = pendulumParams();

            F_unsat = -self.K * x + self.kr * z_r;
            F = saturate(F_unsat, P.F_max);
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end