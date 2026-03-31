classdef massDynamics < handle
    properties
        state
        m
        k
        b
        Ts
    end

    methods
        function self = massDynamics(alpha)
            if nargin < 1
                alpha = 0.0;
            end

            P = massParams();

            % state = [z; zdot]
            self.state = [P.z0; P.zdot0];

            % uncertainty
            self.m = P.m * (1 + alpha*(2*rand - 1));
            self.k = P.k * (1 + alpha*(2*rand - 1));
            self.b = P.b * (1 + alpha*(2*rand - 1));

            self.Ts = P.Ts;
        end

        function y = update(self, u)
            self.rk4_step(u);
            y = self.h();
        end

        function xdot = f(self, state, u)
            z = state(1);
            zdot = state(2);
            F = u;

            zddot = (F - self.b*zdot - self.k*z)/self.m;

            xdot = [zdot; zddot];
        end

        function y = h(self)
            y = self.state(1);
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