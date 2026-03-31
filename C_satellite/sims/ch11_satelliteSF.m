classdef ch11_satelliteSF < handle
    properties
        K
        kr
    end

    methods
        function self = ch11_satelliteSF()
            P = satelliteParams();

            tr_th = 2.0;
            M = 3.0;
            tr_phi = M * tr_th;
            zeta_th = 0.9;
            zeta_phi = 0.9;

            % state space model
            A = [ ...
                0.0,      0.0,        1.0,        0.0;
                0.0,      0.0,        0.0,        1.0;
               -P.k/P.Js, P.k/P.Js,  -P.b/P.Js,   P.b/P.Js;
                P.k/P.Jp,-P.k/P.Jp,   P.b/P.Jp,  -P.b/P.Jp];

            B = [ ...
                0.0;
                0.0;
                1.0/P.Js;
                0.0];

            C = [ ...
                1.0, 0.0, 0.0, 0.0;
                0.0, 1.0, 0.0, 0.0]; 

            % desired poles
            wn_th = 0.5*pi / (tr_th*sqrt(1 - zeta_th^2));
            wn_phi = 0.5*pi / (tr_phi*sqrt(1 - zeta_phi^2));

            des_char_poly = conv( ...
                [1, 2*zeta_th*wn_th, wn_th^2], ...
                [1, 2*zeta_phi*wn_phi, wn_phi^2]);

            des_poles = roots(des_char_poly);

            % controllability check
            if rank(ctrb(A, B)) ~= 4
                error('The satellite system is not controllable.');
            end

            % state feedback gain
            self.K = place(A, B, des_poles);

            % reference gain for phi tracking
            Cr = [1.0, 0.0, 0.0, 0.0];
            self.kr = -1.0 / (Cr * inv(A - B*self.K) * B);

            fprintf('K = \n');
            disp(self.K);
            fprintf('kr = \n');
            disp(self.kr);
        end

        function tau = update(self, phi_r, x)
            P = satelliteParams();

            tau_unsat = -self.K * x + self.kr * phi_r;
            tau = saturate(tau_unsat, P.tau_max);
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end