classdef ch11_ballbeamSF < handle
    properties
        K
        kr
        ze
        Fe
    end

    methods
        function self = ch11_ballbeamSF()
            P = ballbeamParams();

            self.ze = P.ze;
            self.Fe = P.Fe;

            A = P.A;
            B = P.B;
            C = P.C; 

            tr_theta = 0.1;
            tr_z = 2.5;
            zeta_theta = 0.9;
            zeta_z = 0.9;
            
            wn_theta = 0.5*pi / (tr_theta*sqrt(1 - zeta_theta^2));
            wn_z = 0.5*pi / (tr_z*sqrt(1 - zeta_z^2));

            des_char_poly = conv( ...
                [1, 2*zeta_z*wn_z, wn_z^2], ...
                [1, 2*zeta_theta*wn_theta, wn_theta^2]);

            des_poles = roots(des_char_poly);

            % controllability check
            if rank(ctrb(A, B)) ~= size(A,1)
                error('The ball-beam system is not controllable.');
            end

            % state feedback gain
            self.K = place(A, B, des_poles);

            % reference gain so DC gain from zr to z is 1
            Cr = [1, 0, 0, 0];
            self.kr = -1.0 / (Cr * ((A - B*self.K) \ B));

            fprintf('Desired poles = \n');
            disp(des_poles);

            fprintf('K = \n');
            disp(self.K);

            fprintf('kr = \n');
            disp(self.kr);
        end

        function F = update(self, z_r, x)
            x_tilde = [x(1) - self.ze;
                       x(2);
                       x(3);
                       x(4)];

            z_r_tilde = z_r - self.ze;

            % linear state feedback on deviation variables
            F_tilde = -self.K * x_tilde + self.kr * z_r_tilde;

            % convert back to actual input
            F = self.Fe + F_tilde;
        end
    end
end