classdef ch07_vtolPD < handle
    properties
        kp
        kd
        Fe
    end

    methods
        function self = ch07_vtolPD()
            P = vtolParams();
<<<<<<< HEAD
            m = P.mc + P.mr + P.ml;

            % desired poles
=======

            % total mass
            m = P.mc + P.mr + P.ml;

            % desired poles at -0.2 and -0.3
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
            p1 = -0.2;
            p2 = -0.3;

            % desired characteristic polynomial
<<<<<<< HEAD
            alpha1 = -(p1 + p2);   
            alpha0 = p1 * p2;  

            % longitudinal plant
=======
            % (s-p1)(s-p2) = s^2 - (p1+p2)s + p1*p2
            alpha1 = -(p1 + p2);   % 0.5
            alpha0 = p1 * p2;      % 0.06

            % longitudinal plant: h_tilde_ddot = (1/m) F_tilde
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
            self.kd = m * alpha1;
            self.kp = m * alpha0;

            % equilibrium force
            self.Fe = m * P.g;

            fprintf('kp: %f\n', self.kp);
            fprintf('kd: %f\n', self.kd);
            fprintf('Fe: %f\n', self.Fe);
        end

        function F = update(self, h_r, state)
<<<<<<< HEAD
=======
            % state = [z; h; theta; zdot; hdot; thetadot]
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
            h = state(2);
            hdot = state(5);

            % PD on altitude deviation
            F_tilde = self.kp * (h_r - h) - self.kd * hdot;

            % total force
            F = self.Fe + F_tilde;
        end
    end
end