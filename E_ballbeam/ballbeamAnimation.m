classdef ballbeamAnimation < handle
    properties
        flagInit = true
        fig
        ax
        ballHandle
        beamHandle
    end

    methods
        function self = ballbeamAnimation()
            P = ballbeamParams();

            self.fig = figure('Name', 'Ball on Beam Animation', 'NumberTitle', 'off');
            self.ax = axes('Parent', self.fig);
            hold(self.ax, 'on');

            axis(self.ax, [-P.length/5, P.length + P.length/5, -P.length, P.length]);
            plot(self.ax, [0.0, P.length], [0.0, 0.0], 'k');

            uicontrol( ...
                'Parent', self.fig, ...
                'Style', 'pushbutton', ...
                'String', 'Exit', ...
                'Units', 'normalized', ...
                'Position', [0.8, 0.805, 0.1, 0.075], ...
                'BackgroundColor', 'r', ...
                'FontWeight', 'bold', ...
                'FontSize', 18, ...
                'Callback', @(~,~) close(self.fig));
        end

        function update(self, x)
            z = x(1);
            theta = x(2);

            self.drawBall(z, theta);
            self.drawBeam(theta);
            axis(self.ax, 'equal');

            if self.flagInit
                self.flagInit = false;
            end
            drawnow;
        end

        function drawBall(self, z, theta)
            P = ballbeamParams();

            % Ball center: move z along beam, then offset normal to beam
            cx = z*cos(theta) - (P.radius + P.gap)*sin(theta);
            cy = z*sin(theta) + (P.radius + P.gap)*cos(theta);

            pos = [cx - P.radius, cy - P.radius, 2*P.radius, 2*P.radius];

            if self.flagInit
                self.ballHandle = rectangle( ...
                    'Parent', self.ax, ...
                    'Position', pos, ...
                    'Curvature', [1 1], ...
                    'FaceColor', [0.2 0.9 0.2], ...
                    'EdgeColor', 'k');
            else
                set(self.ballHandle, 'Position', pos);
            end
        end

        function drawBeam(self, theta)
            P = ballbeamParams();

            X = [0, P.length*cos(theta)];
            Y = [0, P.length*sin(theta)];

            if self.flagInit
                self.beamHandle = plot(self.ax, X, Y, 'k', 'LineWidth', 3);
            else
                set(self.beamHandle, 'XData', X, 'YData', Y);
            end
        end
    end
end