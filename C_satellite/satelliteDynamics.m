classdef satelliteDynamics < handle
    properties
        state
        Js
        Jp
        k
        b
        Ts
        torque_limit
    end

    methods
        function self = satelliteDynamics(alpha)
            if nargin < 1
                alpha = 0.0;
            end

            P = satelliteParams();

            % Initial state
            self.state = [...
                P.theta0;
                P.phi0;
                P.thetadot0;
                P.phidot0];

            % Randomized parameters
            self.Js = P.Js * (1 + alpha*(2*rand - 1));
            self.Jp = P.Jp * (1 + alpha*(2*rand - 1));
            self.k  = P.k  * (1 + alpha*(2*rand - 1));
            self.b  = P.b  * (1 + alpha*(2*rand - 1));

            % Sample time and limits
            self.Ts = P.Ts;
            self.torque_limit = P.tau_max;
        end

        function y = update(self, u)
            % Saturate the input torque
            u = saturate(u, self.torque_limit);

            % Propagate one sample
            self.rk4_step(u);

            % Return measured output
            y = self.h();
        end

        function xdot = f(self, state, u)
            % Return xdot = f(x,u)
            theta    = state(1);
            phi      = state(2);
            thetadot = state(3);
            phidot   = state(4);
            tau      = u;

            M = [self.Js, 0;
                 0,       self.Jp];

            C = [tau - self.b*(thetadot - phidot) - self.k*(theta - phi);
                -self.b*(phidot - thetadot) - self.k*(phi - theta)];

            tmp = M \ C;
            thetaddot = tmp(1);
            phiddot   = tmp(2);

            xdot = [thetadot;
                    phidot;
                    thetaddot;
                    phiddot];
        end

        function y = h(self)
            % Return y = h(x)
            theta = self.state(1);
            phi   = self.state(2);
            y = [theta; phi];
        end

        function rk4_step(self, u)
            % Integrate ODE using RK4
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