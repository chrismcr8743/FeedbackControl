classdef ch10_satellitePID < handle
    properties
        sigma
        beta

        kp_th
        kd_th

        kp_phi
        ki_phi
        kd_phi

        theta_max

        integrator_phi
        error_phi_prev
        phi_dot
        phi_prev
        theta_dot
        theta_prev
    end

    methods
        function self = ch10_satellitePID()
            P = satelliteParams();

            self.sigma = 0.05;
            self.beta = (2*self.sigma - P.Ts) / (2*self.sigma + P.Ts);

            % tuning parameters 
            tr_th = 0.4;
            zeta_th = 0.9;
            M = 15.0;
            zeta_phi = 0.9;
            self.ki_phi = 0.15;

            self.theta_max = 30.0*pi/180.0;

            %---------------------------------------------------
            % Inner loop
            %---------------------------------------------------
            wn_th = 2.2 / tr_th;
            self.kp_th = wn_th^2 * (P.Js + P.Jp);
            self.kd_th = 2 * zeta_th * wn_th * (P.Js + P.Jp);

            k_DC_th = 1.0;

            %---------------------------------------------------
            % Outer loop
            %---------------------------------------------------
            tr_phi = M * tr_th;
            wn_phi = 2.2 / tr_phi;

            AA = [P.k * k_DC_th, ...
                 -P.b * k_DC_th * wn_phi^2;
                  P.b * k_DC_th, ...
                  P.k * k_DC_th - 2 * zeta_phi * wn_phi * P.b * k_DC_th];

            bb = [-P.k + P.Jp * wn_phi^2;
                  -P.b + 2 * P.Jp * zeta_phi * wn_phi];

            tmp = AA \ bb;
            self.kp_phi = tmp(1);
            self.kd_phi = tmp(2);

            k_DC_phi = P.k * k_DC_th * self.kp_phi / ...
                (P.k + P.k * k_DC_th * self.kp_phi);

            fprintf('k_DC_phi: %f\n', k_DC_phi);
            fprintf('kp_th:  %f\n', self.kp_th);
            fprintf('kd_th:  %f\n', self.kd_th);
            fprintf('kp_phi: %f\n', self.kp_phi);
            fprintf('ki_phi: %f\n', self.ki_phi);
            fprintf('kd_phi: %f\n', self.kd_phi);

            %---------------------------------------------------
            % initialize integrator and differentiators
            %---------------------------------------------------
            self.integrator_phi = 0.0;
            self.error_phi_prev = 0.0;
            self.phi_dot = P.phidot0;
            self.phi_prev = P.phi0;
            self.theta_dot = P.thetadot0;
            self.theta_prev = P.theta0;
        end

        function tau = update(self, phi_r, y)
            P = satelliteParams();

            % measured outputs only
            theta = y(1);
            phi   = y(2);

            %---------------------------------------------------
            % Outer loop (phi control)
            %---------------------------------------------------
            error_phi = phi_r - phi;

            self.integrator_phi = self.integrator_phi ...
                + (P.Ts/2) * (error_phi + self.error_phi_prev);

            self.phi_dot = self.beta * self.phi_dot ...
                + (2.0/(2.0*self.sigma + P.Ts)) * (phi - self.phi_prev);

            theta_r_unsat = self.kp_phi * error_phi ...
                + self.ki_phi * self.integrator_phi ...
                - self.kd_phi * self.phi_dot;

            theta_r = saturate(theta_r_unsat, self.theta_max);

            % anti windup
            if self.ki_phi ~= 0.0
                self.integrator_phi = self.integrator_phi ...
                    + P.Ts / self.ki_phi * (theta_r - theta_r_unsat);
            end

            %---------------------------------------------------
            % Inner loop (theta control)
            %---------------------------------------------------
            error_th = theta_r - theta;

            self.theta_dot = self.beta * self.theta_dot ...
                + (2.0/(2.0*self.sigma + P.Ts)) * (theta - self.theta_prev);

            tau_unsat = self.kp_th * error_th - self.kd_th * self.theta_dot;
            tau = saturate(tau_unsat, P.tau_max);

            % update delayed variables
            self.error_phi_prev = error_phi;
            self.phi_prev = phi;
            self.theta_prev = theta;
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end