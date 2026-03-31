classdef massDynamics < handle
    properties
        state
        m
        k
        b
        Ts
<<<<<<< HEAD
=======
        force_limit
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    end

    methods
        function self = massDynamics(alpha)
            if nargin < 1
                alpha = 0.0;
            end

            P = massParams();

<<<<<<< HEAD
            % state = [z; zdot]
            self.state = [P.z0; P.zdot0];

            % uncertainty
=======
            % Initial state: [z; zdot]
            self.state = [P.z0; P.zdot0];

            % Randomized parameters
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
            self.m = P.m * (1 + alpha*(2*rand - 1));
            self.k = P.k * (1 + alpha*(2*rand - 1));
            self.b = P.b * (1 + alpha*(2*rand - 1));

<<<<<<< HEAD
            self.Ts = P.Ts;
        end

        function y = update(self, u)
=======
            % Sample time and saturation
            self.Ts = P.Ts;
            self.force_limit = P.F_max;
        end

        function y = update(self, u)
            u = saturate(u, self.force_limit);
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
            self.rk4_step(u);
            y = self.h();
        end

        function xdot = f(self, state, u)
            z = state(1);
            zdot = state(2);
            F = u;

<<<<<<< HEAD
            zddot = (F - self.b*zdot - self.k*z)/self.m;
=======
            zddot = (F - self.b*zdot - self.k*z) / self.m;
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468

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
<<<<<<< HEAD
=======
end

function u = saturate(u, limit)
if abs(u) > limit
    u = limit * sign(u);
end
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
end