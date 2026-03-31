classdef ch07_vtolPD < handle
    properties
        kp
        kd
        Fe
    end

    methods
        function self = ch07_vtolPD()
            P = vtolParams();
            m = P.mc + P.mr + P.ml;

            % desired poles
            p1 = -0.2;
            p2 = -0.3;

            % desired characteristic polynomial
            alpha1 = -(p1 + p2);   
            alpha0 = p1 * p2;  

            % longitudinal plant
            self.kd = m * alpha1;
            self.kp = m * alpha0;

            % equilibrium force
            self.Fe = m * P.g;

            fprintf('kp: %f\n', self.kp);
            fprintf('kd: %f\n', self.kd);
            fprintf('Fe: %f\n', self.Fe);
        end

        function F = update(self, h_r, state)
            h = state(2);
            hdot = state(5);

            % PD on altitude deviation
            F_tilde = self.kp * (h_r - h) - self.kd * hdot;

            % total force
            F = self.Fe + F_tilde;
        end
    end
end