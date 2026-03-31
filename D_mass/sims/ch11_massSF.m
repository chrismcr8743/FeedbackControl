classdef ch11_massSF < handle
    properties
        A
        B
        C
        D

        K
        kr

        sigma
        Ts
        beta

        z_dot_hat
        z_d1
    end

    methods
        function self = ch11_massSF()
            P = massParams();

            % state space matrices 
            self.A = P.A;
            self.B = P.B;
            self.C = P.C;
            self.D = P.D;

            tr = 2.0;
            zeta = 0.7;
            wn = 2.2 / tr;

            % desired poles from s^2 + 2*zeta*wn*s + wn^2
            des_char_poly = [1, 2*zeta*wn, wn^2];
            des_poles = roots(des_char_poly);

            % controllability check
            if rank(ctrb(self.A, self.B)) ~= size(self.A,1)
                error('Mass-spring-damper system is not controllable.');
            end

            % state feedback gain
            self.K = place(self.A, self.B, des_poles);

            % reference gain for unit DC gain from zr to z
            self.kr = -1 / (self.C * ((self.A - self.B*self.K) \ self.B));

            % digital differentiator setup
            self.sigma = 0.05;
            self.Ts = P.Ts;
            self.beta = (2*self.sigma - self.Ts) / (2*self.sigma + self.Ts);

            self.z_dot_hat = 0.0;
            self.z_d1 = P.z0;

            fprintf('Desired poles:\n');
            disp(des_poles);

            fprintf('K = \n');
            disp(self.K);

            fprintf('kr = \n');
            disp(self.kr);
        end

        function F = update(self, z_r, y)
            z = y(1);

            % digital differentiator to estimate zdot
            self.z_dot_hat = self.beta*self.z_dot_hat ...
                + (1-self.beta)/self.Ts * (z - self.z_d1);

            % estimated state
            x_hat = [z;
                     self.z_dot_hat];

            % state feedback
            F = -self.K*x_hat + self.kr*z_r;

            % update memory
            self.z_d1 = z;
        end
    end
end