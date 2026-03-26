classdef ch08_vtolPD < handle
    properties
        % altitude loop
        kp_h
        kd_h

        % lateral inner loop
        kp_th
        kd_th
        k_DC_th

        % lateral outer loop
        kp_z
        kd_z

        % options
        use_rotor_saturation
        tr_h
        tr_th
        tr_z
        zeta_h
        zeta_th
        zeta_z
    end

    methods
        function self = ch08_vtolPD(mode, tr_h_override, tr_z_override)
            % mode:
            %   'a' -> altitude design
            %   'e' -> nominal Chapter 8 design
            %   'f' -> same controller structure, but with rotor saturation on
            %
            % optional overrides:
            %   tr_h_override -> altitude rise time
            %   tr_z_override -> lateral outer-loop rise time

            if nargin < 1
                mode = 'e';
            end

            P = vtolParams();

            self.zeta_h  = 0.707;
            self.zeta_th = 0.707;
            self.zeta_z  = 0.707;

            % nominal Chapter 8 values
            % self.tr_h  = 1.150;
            % self.tr_th = 0.8;
            % self.tr_z  = 3.12;

            self.tr_h  = 1.150;
            self.tr_th = 0.8;
            self.tr_z  = 2.87;

            self.use_rotor_saturation = false;

            switch lower(mode)
                case 'a'
                    % altitude only design
                    self.use_rotor_saturation = false;

                case 'e'
                    % nominal
                    self.use_rotor_saturation = false;

                case 'f'
                    % same controller, but rotor saturation enabled
                    self.use_rotor_saturation = true;

                otherwise
                    error('use a, e, or f');
            end

            if nargin >= 2
                self.tr_h = tr_h_override;
            end
            if nargin >= 3
                self.tr_z = tr_z_override;
            end

            % total mass and inertia
            m = P.mc + P.mr + P.ml;
            J = P.Jc + (P.mr + P.ml)*P.d^2;

            %----------------------------------------------------------
            % Altitude loop: h_tilde_ddot = (1/m) F_tilde
            %----------------------------------------------------------
            wn_h = 2.2 / self.tr_h;
            self.kp_h = m * wn_h^2;
            self.kd_h = 2 * self.zeta_h * wn_h * m;

            %----------------------------------------------------------
            % Lateral inner loop: theta_ddot = tau / J
            %----------------------------------------------------------
            wn_th = 2.2 / self.tr_th;
            self.kp_th = J * wn_th^2;
            self.kd_th = 2 * self.zeta_th * wn_th * J;

            % DC gain of inner loop
            self.k_DC_th = 1.0;

            %----------------------------------------------------------
            % Lateral outer loop:
            % zddot = -(mu/m) zdot - g*theta
            % replacing inner loop by DC gain
            %----------------------------------------------------------
            wn_z = 2.2 / self.tr_z;
            self.kp_z = -(wn_z^2) / (P.g * self.k_DC_th);
            self.kd_z = -(2*self.zeta_z*wn_z - P.mu/m) / (P.g * self.k_DC_th);

            fprintf('mode: %s\n', mode);
            fprintf('kp_h:  %f\n', self.kp_h);
            fprintf('kd_h:  %f\n', self.kd_h);
            fprintf('kp_th: %f\n', self.kp_th);
            fprintf('kd_th: %f\n', self.kd_th);
            fprintf('k_DC_th: %f\n', self.k_DC_th);
            fprintf('kp_z:  %f\n', self.kp_z);
            fprintf('kd_z:  %f\n', self.kd_z);
            fprintf('tr_h:  %f\n', self.tr_h);
            fprintf('tr_z:  %f\n', self.tr_z);
        end

        function u = update(self, z_r, h_r, state)
            % state = [z; h; theta; zdot; hdot; thetadot]
            z = state(1);
            h = state(2);
            theta = state(3);
            zdot = state(4);
            hdot = state(5);
            thetadot = state(6);

            P = vtolParams();

            %----------------------------------------------------------
            % altitude loop
            %----------------------------------------------------------
            F_tilde = self.kp_h * (h_r - h) - self.kd_h * hdot;
            Fe = (P.mc + P.mr + P.ml) * P.g;
            F = Fe + F_tilde;

            %----------------------------------------------------------
            % lateral loop
            %----------------------------------------------------------
            theta_r = self.kp_z * (z_r - z) - self.kd_z * zdot;
            tau = self.kp_th * (theta_r - theta) - self.kd_th * thetadot;

            % convert [F; tau] to rotor forces [fr; fl]
            u = P.mixing * [F; tau];

            % rotor saturation for F.8(f)
            if self.use_rotor_saturation
                u(1) = saturateRotor(u(1), P.F_max);
                u(2) = saturateRotor(u(2), P.F_max);
            end
        end
    end
end

function f = saturateRotor(f, limit)
f = min(max(f, 0), limit);
end