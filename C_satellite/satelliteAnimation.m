classdef satelliteAnimation < handle
    properties
        flagInit = true
        fig
        ax
        baseHandle
        panelHandle
        length
        width
    end

    methods
        function self = satelliteAnimation()
            P = satelliteParams();

            self.length = P.length;
            self.width = P.width;

            self.fig = figure('Name', 'Satellite Animation', 'NumberTitle', 'off');
            self.ax = axes('Parent', self.fig);
            hold(self.ax, 'on');

            axis(self.ax, [-2.0*P.length, 2.0*P.length, -2.0*P.length, 2.0*P.length]);
            plot(self.ax, [-2.0*P.length, 2.0*P.length], [0, 0], 'b--');

            % Match the Python look more closely:
            % do NOT force axis equal here, since the Python file leaves it commented out
            % do NOT add extra title/grid unless you want a different style

            uicontrol( ...
                'Parent', self.fig, ...
                'Style', 'pushbutton', ...
                'String', 'Exit', ...
                'Units', 'normalized', ...
                'Position', [0.80, 0.805, 0.10, 0.075], ...
                'BackgroundColor', 'r', ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'Callback', @(~,~) close(self.fig));
        end

        function update(self, u)
            theta = u(1);   % base angle
            phi   = u(2);   % panel angle

            self.drawBase(theta);
            self.drawPanel(phi);

            if self.flagInit
                self.flagInit = false;
            end

            drawnow;
        end

        function drawBase(self, theta)
            pts = [...
                 self.width/2.0,                 -self.width/2.0;
                 self.width/2.0,                 -self.width/6.0;
                 self.width/2.0 + self.width/6.0, -self.width/6.0;
                 self.width/2.0 + self.width/6.0,  self.width/6.0;
                 self.width/2.0,                  self.width/6.0;
                 self.width/2.0,                  self.width/2.0;
                -self.width/2.0,                  self.width/2.0;
                -self.width/2.0,                  self.width/6.0;
                -self.width/2.0 - self.width/6.0, self.width/6.0;
                -self.width/2.0 - self.width/6.0, -self.width/6.0;
                -self.width/2.0,                 -self.width/6.0;
                -self.width/2.0,                 -self.width/2.0]';

            R = [cos(theta),  sin(theta);
                -sin(theta),  cos(theta)];

            xy = (R * pts)';

            if self.flagInit || isempty(self.baseHandle) || ~isgraphics(self.baseHandle)
                self.baseHandle = patch( ...
                    'Parent', self.ax, ...
                    'XData', xy(:,1), ...
                    'YData', xy(:,2), ...
                    'FaceColor', 'blue', ...
                    'EdgeColor', 'black');
            else
                set(self.baseHandle, 'XData', xy(:,1), 'YData', xy(:,2));
            end
        end

        function drawPanel(self, phi)
            pts = [...
                -self.length, -self.width/6.0;
                 self.length, -self.width/6.0;
                 self.length,  self.width/6.0;
                -self.length,  self.width/6.0]';

            R = [cos(phi),  sin(phi);
                -sin(phi),  cos(phi)];

            xy = (R * pts)';

            if self.flagInit || isempty(self.panelHandle) || ~isgraphics(self.panelHandle)
                self.panelHandle = patch( ...
                    'Parent', self.ax, ...
                    'XData', xy(:,1), ...
                    'YData', xy(:,2), ...
                    'FaceColor', 'green', ...
                    'EdgeColor', 'black');
            else
                set(self.panelHandle, 'XData', xy(:,1), 'YData', xy(:,2));
            end
        end
    end
end