classdef vtolAnimation < handle
    properties
        flagInit = true
        fig
        ax
        vehicleHandle
        targetHandle
    end

    methods
        function self = vtolAnimation()
            P = vtolParams();

            self.fig = figure('Name', 'VTOL Animation', 'NumberTitle', 'off');
            self.ax = axes('Parent', self.fig);
            hold(self.ax, 'on');

            plot(self.ax, [0, P.length], [0, 0], 'k');  % ground line
            axis(self.ax, [-P.length/5, P.length + P.length/5, ...
                           -P.length/5, P.length + P.length/5]);

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

        function update(self, x, target)
            if nargin < 3
                target = 0.0;
            end

            z = x(1);
            h = x(2);
            theta = x(3);

            self.drawVehicle(z, h, theta);
            self.drawTarget(target);

            if self.flagInit
                self.flagInit = false;
            end

            drawnow;
        end

        function drawVehicle(self, z, h, theta)
            x1 = 0.1; x2 = 0.3; x3 = 0.4;
            y1 = 0.05; y2 = 0.01;

            pts = [ ...
                 x1,  y1;
                 x1,  0;
                 x2,  0;
                 x2,  y2;
                 x3,  y2;
                 x3, -y2;
                 x2, -y2;
                 x2,  0;
                 x1,  0;
                 x1, -y1;
                -x1, -y1;
                -x1,  0;
                -x2,  0;
                -x2, -y2;
                -x3, -y2;
                -x3,  y2;
                -x2,  y2;
                -x2,  0;
                -x1,  0;
                -x1,  y1;
                 x1,  y1]';

            R = [cos(theta), -sin(theta);
                 sin(theta),  cos(theta)];

            pts = R * pts + [z; h];
            xy = pts';

            if self.flagInit
                self.vehicleHandle = patch( ...
                    'Parent', self.ax, ...
                    'XData', xy(:,1), ...
                    'YData', xy(:,2), ...
                    'FaceColor', 'blue', ...
                    'EdgeColor', 'black');
            else
                set(self.vehicleHandle, 'XData', xy(:,1), 'YData', xy(:,2));
            end
        end

        function drawTarget(self, target)
            w = 0.1;
            h = 0.05;
            pts = [ ...
                target + w/2, h;
                target + w/2, 0;
                target - w/2, 0;
                target - w/2, h;
                target + w/2, h];

            if self.flagInit
                self.targetHandle = patch( ...
                    'Parent', self.ax, ...
                    'XData', pts(:,1), ...
                    'YData', pts(:,2), ...
                    'FaceColor', 'blue', ...
                    'EdgeColor', 'black');
            else
                set(self.targetHandle, 'XData', pts(:,1), 'YData', pts(:,2));
            end
        end
    end
end