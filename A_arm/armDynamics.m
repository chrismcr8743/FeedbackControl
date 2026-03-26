classdef armDynamics < handle
    properties
        state
        m
        ell
        b
        g
        Ts
        torque_limit
    end

    methods
        function self = armDynamics(alpha)
            if nargin < 1
                alpha = 0.0;
            end

            P = armParams();

            % Initial state
            self.state = [P.theta0; P.thetadot0];

            % Randomized parameters
            self.m = P.m * (1 + alpha*(2*rand - 1));
            self.ell = P.ell * (1 + alpha*(2*rand - 1));
            self.b = P.b * (1 + alpha*(2*rand - 1));
            self.g = P.g;

            % Sample time
            self.Ts = P.Ts;
            self.torque_limit = P.tau_max;
        end

        function y = update(self, u)
            % Saturate the input torque
            u = saturate(u, self.torque_limit);

            % Propagate one time step
            self.rk4_step(u);

            % Return output
            y = self.h();
        end

        function xdot = f(self, state, tau)
            % State dynamics
            theta = state(1);
            thetadot = state(2);

            thetaddot = (3.0 / (self.m * self.ell^2)) * ...
                (tau - self.b*thetadot ...
                - self.m*self.g*self.ell/2.0*cos(theta));

            xdot = [thetadot; thetaddot];
        end

        function y = h(self)
            % Output equation
            theta = self.state(1);
            y = theta;
        end

        function rk4_step(self, u)
            % Runge-Kutta 4 integration
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