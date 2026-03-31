classdef ch10_massPID < handle
    properties
        kp
        ki
        kd
        kr

        sigma
        Ts
        beta
        limit

        integrator
        error_d1
        z_dot
        z_d1
    end

    methods
        function self = ch10_massPID()
            P = massParams();

            self.kp = 3.05;
            self.kd = 7.20;

            % feedforward for spring force
            self.kr = P.k;

            % dirty derivative
            self.sigma = 0.05;
            self.Ts = P.Ts;
            self.beta = (2.0*self.sigma - self.Ts) / (2.0*self.sigma + self.Ts);

            % force limit
            self.limit = 6.0;

            self.ki = 0.4;

            % memory
            self.integrator = 0.0;
            self.error_d1 = 0.0;
            self.z_dot = 0.0;
            self.z_d1 = P.z0;

            fprintf('kp = %f\n', self.kp);
            fprintf('ki = %f\n', self.ki);
            fprintf('kd = %f\n', self.kd);
            fprintf('kr = %f\n', self.kr);
            fprintf('sigma = %f\n', self.sigma);
        end

        function F = update(self, z_r, y)
            z = y(1);
            error = z_r - z;

            self.integrator = self.integrator + (self.Ts/2.0) * (error + self.error_d1);

            % dirty derivative of measured position
            self.z_dot = self.beta*self.z_dot + ((1.0 - self.beta)/self.Ts) * (z - self.z_d1);

            F_unsat = self.kr*z_r + self.kp*error + self.ki*self.integrator - self.kd*self.z_dot;
            F = saturate(F_unsat, self.limit);

            % anti windup
            if self.ki ~= 0.0
                self.integrator = self.integrator + (1.0/self.ki) * (F - F_unsat);
            end

            % update memory
            self.error_d1 = error;
            self.z_d1 = z;
        end
    end
end

function u = saturate(u, limit)
    if abs(u) > limit
        u = limit * sign(u);
    end
end