classdef ballbeamDynamics < handle
    properties
        state
        m1
        m2
        ell
        g
        Ts
        force_limit
    end

    methods
        function self = ballbeamDynamics(alpha)
            if nargin < 1
                alpha = 0.0;
            end

            P = ballbeamParams();

            self.state = [P.z0; P.theta0; P.zdot0; P.thetadot0];

            self.m1 = P.m1 * (1 + alpha*(2*rand - 1));
            self.m2 = P.m2 * (1 + alpha*(2*rand - 1));
            self.ell = P.length * (1 + alpha*(2*rand - 1));
            self.g = P.g;

            self.Ts = P.Ts;
            self.force_limit = P.F_max;
        end

        function y = update(self, u)
            u = saturate(u, self.force_limit);
            self.rk4_step(u);
            y = self.h();
        end

        function xdot = f(self, state, u)
            z = state(1);
            theta = state(2);
            zdot = state(3);
            thetadot = state(4);
            F = u;

            zddot = z*thetadot^2 - self.g*sin(theta);

            denom = self.m1*z^2 + self.m2*self.ell^2/3.0;
            thetaddot = ( ...
                self.ell*F*cos(theta) ...
                - 2*self.m1*z*zdot*thetadot ...
                - (self.m1*self.g*z + self.m2*self.g*self.ell/2.0)*cos(theta) ...
                ) / denom;

            xdot = [zdot; thetadot; zddot; thetaddot];
        end

        function y = h(self)
            y = [self.state(1); self.state(2)];
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

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
end