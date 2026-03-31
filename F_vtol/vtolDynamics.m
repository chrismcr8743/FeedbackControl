classdef vtolDynamics < handle
    properties
        state
        mc
        mr
        ml
        Jc
        d
        mu
        g
        F_wind
        Ts
        force_limit
    end

    methods
        function self = vtolDynamics(alpha)
            if nargin < 1
                alpha = 0.0;
            end

            P = vtolParams();

            self.state = [ ...
                P.z0;
                P.h0;
                P.theta0;
                P.zdot0;
                P.hdot0;
                P.thetadot0];

            self.mc = P.mc * (1 + alpha*(2*rand - 1));
            self.mr = P.mr;
            self.ml = P.ml;
            self.Jc = P.Jc * (1 + alpha*(2*rand - 1));
            self.d  = P.d  * (1 + alpha*(2*rand - 1));
            self.mu = P.mu * (1 + alpha*(2*rand - 1));

            self.g = P.g;
            self.F_wind = P.F_wind;
            self.Ts = P.Ts;
            self.force_limit = P.F_max;
        end

        function y = update(self, u)
            % u = [fr; fl]
            u = u(:);

            % rotor saturation
            u(1) = saturateRotor(u(1), self.force_limit);
            u(2) = saturateRotor(u(2), self.force_limit);

            % propagate one sample
            self.rk4_step(u);

            % measured output
            y = self.h();
        end

        function xdot = f(self, state, u)
            z = state(1); 
            h = state(2); 
            theta = state(3);
            zdot = state(4);
            hdot = state(5);
            thetadot = state(6);

            fr = u(1);
            fl = u(2);

            % total mass and inertia
            m = self.mc + self.mr + self.ml;
            J = self.Jc + (self.mr + self.ml)*self.d^2;

            % total force and torque
            F = fr + fl;
            tau = self.d * (fr - fl);

            % equations of motion
            zddot = (-F*sin(theta) - self.mu*zdot + self.F_wind) / m;
            hddot = ( F*cos(theta) - m*self.g ) / m;
            thetaddot = tau / J;

            xdot = [ ...
                zdot;
                hdot;
                thetadot;
                zddot;
                hddot;
                thetaddot];
        end

        function y = h(self)
            y = [ ...
                self.state(1);
                self.state(2);
                self.state(3)];
        end

        function rk4_step(self, u)
            F1 = self.f(self.state, u);
            F2 = self.f(self.state + self.Ts/2*F1, u);
            F3 = self.f(self.state + self.Ts/2*F2, u);
            F4 = self.f(self.state + self.Ts*F3, u);

            self.state = self.state + self.Ts/6*(F1 + 2*F2 + 2*F3 + F4);
        end
    end
end

function u = saturateRotor(u, limit)
u = min(max(u, 0), limit);
end