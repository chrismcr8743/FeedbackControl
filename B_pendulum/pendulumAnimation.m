classdef pendulumAnimation < handle
    properties
        flagInit = true
        fig
        ax
        cartHandle
        bobHandle
        rodHandle
    end

    methods
        function self = pendulumAnimation()
            P = pendulumParams();

            self.fig = figure('Name', 'Pendulum Animation', 'NumberTitle', 'off');
            self.ax = axes('Parent', self.fig);
            hold(self.ax, 'on');
            grid(self.ax, 'on');
            axis(self.ax, [-3*P.ell, 3*P.ell, -0.1, 3*P.ell]);
            xlabel(self.ax, 'z');
            plot(self.ax, [-2*P.ell, 2*P.ell], [0, 0], 'b--');

            uicontrol( ...
                'Parent', self.fig, ...
                'Style', 'pushbutton', ...
                'String', 'Exit', ...
                'Units', 'normalized', ...
                'Position', [0.80, 0.88, 0.12, 0.07], ...
                'BackgroundColor', [1 0.4 0.4], ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'Callback', @(~,~) close(self.fig));
        end

        function update(self, state)
            z = state(1);
            theta = state(2);

            self.drawCart(z);
            self.drawBob(z, theta);
            self.drawRod(z, theta);

            axis(self.ax, 'equal');
            drawnow;

            if self.flagInit
                self.flagInit = false;
            end
        end

        function drawCart(self, z)
            P = pendulumParams();
            x = z - P.w/2.0;
            y = P.gap;
            pos = [x, y, P.w, P.h];

            if self.flagInit
                self.cartHandle = rectangle(self.ax, ...
                    'Position', pos, ...
                    'FaceColor', 'b', ...
                    'EdgeColor', 'k');
            else
                set(self.cartHandle, 'Position', pos);
            end
        end

        function drawBob(self, z, theta)
            P = pendulumParams();
            x = z + (P.ell + P.radius)*sin(theta);
            y = P.gap + P.h + (P.ell + P.radius)*cos(theta);
            pos = [x - P.radius, y - P.radius, 2*P.radius, 2*P.radius];

            if self.flagInit
                self.bobHandle = rectangle(self.ax, ...
                    'Position', pos, ...
                    'Curvature', [1 1], ...
                    'FaceColor', [0.2 0.8 0.2], ...
                    'EdgeColor', 'k');
            else
                set(self.bobHandle, 'Position', pos);
            end
        end

        function drawRod(self, z, theta)
            P = pendulumParams();
            X = [z, z + P.ell*sin(theta)];
            Y = [P.gap + P.h, P.gap + P.h + P.ell*cos(theta)];

            if self.flagInit
                self.rodHandle = plot(self.ax, X, Y, 'k', 'LineWidth', 1.5);
            else
                set(self.rodHandle, 'XData', X, 'YData', Y);
            end
        end
    end
end