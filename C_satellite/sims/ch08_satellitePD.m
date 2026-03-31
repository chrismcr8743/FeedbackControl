classdef ch08_satellitePD < handle
    properties
        kp_th
        kd_th
        kp_phi
        kd_phi
        theta_max
        use_tau_saturation
    end

    methods
        function self = ch08_satellitePD(mode)
            if nargin < 1
                mode = 'f';
            end

            P = satelliteParams();

            zeta_th = 0.9;
            zeta_phi = 0.9;
            self.theta_max = 30.0*pi/180.0;

            switch lower(mode)
                case 'f'
                    tr_th = 1.0;
                    self.use_tau_saturation = false;
                case 'g'
                    tr_th = 1.75;
                    self.use_tau_saturation = true;
                otherwise
                    error('Unknown mode. Use ''f'' or ''g''.');
            end

            %---------------------------------------------------
            % Inner loop
            %---------------------------------------------------
            wn_th = 0.5*pi / (tr_th*sqrt(1 - zeta_th^2));

            self.kp_th = wn_th^2 * (P.Js + P.Jp);
            self.kd_th = 2*zeta_th*wn_th * (P.Js + P.Jp);

            % DC gain of inner loop
            DC_th = 1.0;

            %---------------------------------------------------
            % Outer loop
            %---------------------------------------------------
            M = 10.0;
            tr_phi = M * tr_th;
            wn_phi = 0.5*pi / (tr_phi*sqrt(1 - zeta_phi^2));

            AA = [P.k*DC_th,                   -P.b*DC_th*wn_phi^2;
                  P.b*DC_th,   P.k*DC_th - 2*zeta_phi*wn_phi*P.b*DC_th];

            bb = [-P.k + P.Jp*wn_phi^2;
                  -P.b + 2*P.Jp*zeta_phi*wn_phi];

            tmp = AA \ bb;
            self.kp_phi = tmp(1);
            self.kd_phi = tmp(2);

            k_DC_phi = P.k * DC_th * self.kp_phi / ...
                (P.k + P.k * DC_th * self.kp_phi);

            fprintf('mode: %s\n', mode);
            fprintf('k_DC_phi: %f\n', k_DC_phi);
            fprintf('kp_th: %f\n', self.kp_th);
            fprintf('kd_th: %f\n', self.kd_th);
            fprintf('kp_phi: %f\n', self.kp_phi);
            fprintf('kd_phi: %f\n', self.kd_phi);
        end

        function tau = update(self, phi_r, state)
            theta = state(1);
            phi = state(2);
            thetadot = state(3);
            phidot = state(4);

            % outer loop: desired body angle
            theta_r = self.kp_phi*(phi_r - phi) - self.kd_phi*phidot + phi_r;
            theta_r = saturate(theta_r, self.theta_max);

            % inner loop: body torque
            P = satelliteParams();
            tau = self.kp_th*(theta_r - theta) - self.kd_th*thetadot;

            if self.use_tau_saturation
                tau = saturate(tau, P.tau_max);
            end
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end