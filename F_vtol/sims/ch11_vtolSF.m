classdef ch11_vtolSF < handle
    properties
        K_lon
        krh

        K_lat
        krz

        h_eq
        theta_max
        F_max
        tau_max
    end

    methods
        function self = ch11_vtolSF()
            P = vtolParams();

            self.h_eq = P.h0;
            self.theta_max = 10*pi/180;
            self.F_max = 2*P.F_max;
            self.tau_max = 2*P.F_max*P.d;

            zeta_h = 0.9;
            tr_h = 2.3;
            wn_h = 2.2 / tr_h;
            des_poles_lon = roots([1, 2*zeta_h*wn_h, wn_h^2]);

            zeta_th = 0.707;
            zeta_z = 0.707;
            tr_th = 0.17;
            tr_z = 10 * tr_th;

            wn_th = 2.2 / tr_th;
            wn_z = 2.2 / tr_z;

            des_char_poly_lat = conv( ...
                [1, 2*zeta_z*wn_z, wn_z^2], ...
                [1, 2*zeta_th*wn_th, wn_th^2]);
            des_poles_lat = roots(des_char_poly_lat);

            % controllability checks
            if rank(ctrb(P.A_lon, P.B_lon)) ~= size(P.A_lon,1)
                error('Longitudinal VTOL model is not controllable.');
            end
            if rank(ctrb(P.A_lat, P.B_lat)) ~= size(P.A_lat,1)
                error('Lateral VTOL model is not controllable.');
            end

            % state feedback gains
            self.K_lon = place(P.A_lon, P.B_lon, des_poles_lon);
            self.K_lat = place(P.A_lat, P.B_lat, des_poles_lat);

            % reference gains
            self.krh = -1 / (P.C_lon * ((P.A_lon - P.B_lon*self.K_lon) \ P.B_lon));

            Cr_z = [1, 0, 0, 0];
            self.krz = -1 / (Cr_z * ((P.A_lat - P.B_lat*self.K_lat) \ P.B_lat));

            fprintf('K_lon = \n');
            disp(self.K_lon);
            fprintf('krh = \n');
            disp(self.krh);

            fprintf('K_lat = \n');
            disp(self.K_lat);
            fprintf('krz = \n');
            disp(self.krz);

            fprintf('desired longitudinal poles = \n');
            disp(des_poles_lon);
            fprintf('desired lateral poles = \n');
            disp(des_poles_lat);
        end

        function u = update(self, z_r, h_r, x)
            P = vtolParams();

            z = x(1);
            h = x(2);
            theta = x(3);
            zdot = x(4);
            hdot = x(5);
            thetadot = x(6);

            % deviation states
            x_lon_tilde = [h - self.h_eq;
                           hdot];

            x_lat_tilde = [z;
                           theta;
                           zdot;
                           thetadot];

            h_r_tilde = h_r - self.h_eq;
            z_r_tilde = z_r;

            % longitudinal total force
            F_tilde = -self.K_lon * x_lon_tilde + self.krh * h_r_tilde;
            F = P.Fe + F_tilde;
            F = saturate(F, self.F_max);

            % lateral torque
            tau = -self.K_lat * x_lat_tilde + self.krz * z_r_tilde;
            tau = saturate(tau, self.tau_max);

            % convert [F; tau] to rotor forces
            u = P.mixing * [F; tau];
        end
    end
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end