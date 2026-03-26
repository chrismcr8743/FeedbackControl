classdef ch08_ballbeamPD < handle
    properties
        kp_th
        kd_th
        k_DC_th

        kp_z
        kd_z

        F_max
        use_saturation
        tr_th
        tr_z
        zeta_th
        zeta_z
    end

    methods
        function self = ch08_ballbeamPD(mode, tr_z_override)

            if nargin < 1
                mode = 'e';
            end

            P = ballbeamParams();

            self.F_max = P.F_max;

            % design point
            ze = P.length/2;
            Je = P.m1*ze^2 + P.m2*P.length^2/3;

            %---------------------------------------------------
            % Inner loop design from part b
            %---------------------------------------------------
            self.tr_th = 1.0;
            self.zeta_th = 0.707;

            wn_th = 2.2 / self.tr_th;

            % Inner loop plant: theta_tilde/F_tilde = (ell/Je)/s^2
            b0_th = P.length / Je;

            self.kp_th = wn_th^2 / b0_th;
            self.kd_th = 2*self.zeta_th*wn_th / b0_th;

            % Inner loop DC gain from theta_r_tilde to theta_tilde
            self.k_DC_th = 1.0;

            %---------------------------------------------------
            % Outer loop design from part d
            %---------------------------------------------------
            self.zeta_z = 0.707;

            switch lower(mode)
                case 'e'
                    self.tr_z = 10.0 * self.tr_th;
                    self.use_saturation = false;

                case 'f'
                    self.tr_z = 3.6; 
                    self.use_saturation = true;

                otherwise
                    error('use ''e'' or ''f''.');
            end

            if nargin >= 2
                self.tr_z = tr_z_override;
            end

            wn_z = 2.2 / self.tr_z;

            % Outer-loop plant: z_tilde/theta_tilde = -g/s^2
            % with inner loop replaced by its DC gain k_DC_th
            self.kp_z = -(wn_z^2) / (P.g * self.k_DC_th);
            self.kd_z = -(2*self.zeta_z*wn_z) / (P.g * self.k_DC_th);

            fprintf('mode: %s\n', mode);
            fprintf('kp_th: %f\n', self.kp_th);
            fprintf('kd_th: %f\n', self.kd_th);
            fprintf('k_DC_th: %f\n', self.k_DC_th);
            fprintf('kp_z: %f\n', self.kp_z);
            fprintf('kd_z: %f\n', self.kd_z);
            fprintf('tr_z: %f\n', self.tr_z);
        end

        function F = update(self, z_r, state)
            % state = [z; theta; zdot; thetadot]
            z = state(1);
            theta = state(2);
            zdot = state(3);
            thetadot = state(4);

            P = ballbeamParams();

            % Outer loop: ball-position control
            % Since (z_r_tilde - z_tilde) = (z_r - z), actual positions work here
            theta_r_tilde = self.kp_z*(z_r - z) - self.kd_z*zdot;

            % Inner loop: beam-angle control
            F_tilde = self.kp_th*(theta_r_tilde - theta) - self.kd_th*thetadot;

            % Feedback-linearizing equilibrium force term using actual z
            F_eq = (P.m1*P.g*z + P.m2*P.g*P.length/2) / P.length;

            % Total force
            F = F_eq + F_tilde;

            if self.use_saturation
                F = saturate(F, self.F_max);
            end
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end