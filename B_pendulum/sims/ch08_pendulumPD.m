classdef ch08_pendulumPD < handle
    properties
        kp_th
        kd_th
        kp_z
        kd_z
        F_max

        % zero canceling filter
        filter_a
        filter_b
        filter_state
        Ts
    end

    methods
        function self = ch08_pendulumPD()
            P = pendulumParams();

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %       PD Control: Time Design Strategy
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % tuning parameters
            tr_th = 0.15;      % rise time for inner loop (theta)
            zeta_th = 0.707;   % inner loop damping coefficient

            % saturation limits
            self.F_max = 5.0;         % max force, N
            error_max = 1;            %#ok<NASGU> % max step size, m
            theta_max = 30.0*pi/180;  %#ok<NASGU> % max theta, rad

            %---------------------------------------------------
            %                    Inner Loop
            %---------------------------------------------------
            b0_th = 1.0 / (P.m1*(P.ell/6.0) + P.m2*(2.0*P.ell/3.0));
            a0_th = (P.m1 + P.m2)*P.g / (P.m1*(P.ell/6.0) + P.m2*(2.0*P.ell/3.0));

            wn_th = 2.2 / tr_th;

            self.kp_th = -(wn_th^2 + a0_th) / b0_th;
            self.kd_th = -(2.0*zeta_th*wn_th) / b0_th;
            DC_gain = b0_th*self.kp_th / (b0_th*self.kp_th + a0_th);

            %---------------------------------------------------
            %                    Outer Loop
            %---------------------------------------------------
            M = 15.0;          % time scale separation
            zeta_z = 0.707;    % outer loop damping coefficient
            tr_z = M * tr_th;
            wn_z = 2.2 / tr_z;

            a = wn_z^2*sqrt(2.0*P.ell/(3.0*P.g)) - 2.0*zeta_z*wn_z;
            self.kd_z = a / (a + sqrt(3.0*P.g/(2.0*P.ell)));
            self.kp_z = -wn_z^2*sqrt(2.0*P.ell/(3.0*P.g))*(1.0 + self.kd_z);

            % print gains
            fprintf('DC_gain: %f\n', DC_gain);
            fprintf('kp_th: %f\n', self.kp_th);
            fprintf('kd_th: %f\n', self.kd_th);
            fprintf('kp_z: %f\n', self.kp_z);
            fprintf('kd_z: %f\n', self.kd_z);

            %---------------------------------------------------
            %                zero-canceling filter
            %---------------------------------------------------
            self.filter_a = -3.0 / (2.0 * P.ell * DC_gain);
            self.filter_b = sqrt(3.0 * P.g / (2.0 * P.ell));
            self.filter_state = 0.0;
            self.Ts = P.Ts;
        end

        function F_sat = update(self, z_r, state)
            % state = [z; theta; zdot; thetadot]
            z = state(1);
            theta = state(2);
            zdot = state(3);
            thetadot = state(4);

            % outer-loop PD
            tmp = self.kp_z * (z_r - z) - self.kd_z * zdot;

            % zero-canceling filter using RK1 / forward Euler
            theta_r = self.filter_update(tmp);

            % inner-loop PD
            F = self.kp_th * (theta_r - theta) - self.kd_th * thetadot;

            % saturate
            F_sat = saturate(F, self.F_max);
        end

        function y = filter_update(self, input_val)
            self.filter_state = self.filter_state + ...
                self.Ts * (-self.filter_b*self.filter_state + self.filter_a*input_val);
            y = self.filter_state;
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end