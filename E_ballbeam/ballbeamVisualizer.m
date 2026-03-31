classdef ballbeamVisualizer < handle
    properties
        fig

        % axes
        axAnim
        axZ
        axTheta
        axForce

        % animation
        flagInit = true
        ballHandle
        beamHandle

        % data history
        time_history = []
        zref_history = []
        z_history = []
        theta_history = []
        force_history = []

        % plot handles
        zLine
        zRefLine
        thetaLine
        forceLine
    end

    methods
        function self = ballbeamVisualizer()
            P = ballbeamParams();

            self.fig = figure('Name', 'Ball-Beam Visualization', 'NumberTitle', 'off');

            tiled = tiledlayout(self.fig, 3, 2, ...
                'TileSpacing', 'compact', ...
                'Padding', 'compact');

            %  Animation 
            self.axAnim = nexttile(tiled, [3 1]);
            hold(self.axAnim, 'on');
            axis(self.axAnim, [-P.length/5, P.length + P.length/5, -P.length, P.length]);
            axis(self.axAnim, 'equal');
            plot(self.axAnim, [0.0, P.length], [0.0, 0.0], 'k');
            xlabel(self.axAnim, 'x (m)');
            ylabel(self.axAnim, 'y (m)');
            title(self.axAnim, 'Ball-Beam Animation');

            %  z plot 
            self.axZ = nexttile(tiled, 2);
            hold(self.axZ, 'on');
            grid(self.axZ, 'on');
            ylabel(self.axZ, 'z (m)');
            title(self.axZ, 'Ball-Beam Data');

            self.zLine = plot(self.axZ, NaN, NaN, 'b', 'LineWidth', 1.5);
            self.zRefLine = plot(self.axZ, NaN, NaN, 'g--', 'LineWidth', 1.5);
            legend(self.axZ, {'z', 'z ref'}, 'Location', 'best');

            %  theta plot 
            self.axTheta = nexttile(tiled, 4);
            hold(self.axTheta, 'on');
            grid(self.axTheta, 'on');
            ylabel(self.axTheta, '\theta (deg)');
            self.thetaLine = plot(self.axTheta, NaN, NaN, 'b', 'LineWidth', 1.5);

            %  force plot 
            self.axForce = nexttile(tiled, 6);
            hold(self.axForce, 'on');
            grid(self.axForce, 'on');
            xlabel(self.axForce, 't (s)');
            ylabel(self.axForce, 'force (N)');
            self.forceLine = plot(self.axForce, NaN, NaN, 'r', 'LineWidth', 1.5);

            % exit button
            uicontrol( ...
                'Parent', self.fig, ...
                'Style', 'pushbutton', ...
                'String', 'Exit', ...
                'Units', 'normalized', ...
                'Position', [0.87, 0.93, 0.10, 0.05], ...
                'BackgroundColor', [1 0.4 0.4], ...
                'FontWeight', 'bold', ...
                'FontSize', 11, ...
                'Callback', @(~,~) close(self.fig));
        end

        function update(self, t, states, ctrl, reference)
            if nargin < 5
                reference = 0.0;
            end

            z = states(1);
            theta = states(2);

            %  animation 
            self.drawBall(z, theta);
            self.drawBeam(theta);

            %  history 
            self.time_history(end+1) = t;
            self.zref_history(end+1) = reference;
            self.z_history(end+1) = z;
            self.theta_history(end+1) = 180/pi * theta;
            self.force_history(end+1) = ctrl;

            %  plots 
            set(self.zLine, 'XData', self.time_history, 'YData', self.z_history);
            set(self.zRefLine, 'XData', self.time_history, 'YData', self.zref_history);
            set(self.thetaLine, 'XData', self.time_history, 'YData', self.theta_history);
            set(self.forceLine, 'XData', self.time_history, 'YData', self.force_history);

            drawnow;

            if self.flagInit
                self.flagInit = false;
            end
        end

        function drawBall(self, z, theta)
            P = ballbeamParams();

            % Ball center
            cx = z*cos(theta) - (P.radius + P.gap)*sin(theta);
            cy = z*sin(theta) + (P.radius + P.gap)*cos(theta);

            pos = [cx - P.radius, cy - P.radius, 2*P.radius, 2*P.radius];

            if self.flagInit
                self.ballHandle = rectangle( ...
                    'Parent', self.axAnim, ...
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
                self.beamHandle = plot(self.axAnim, X, Y, 'k', 'LineWidth', 3);
            else
                set(self.beamHandle, 'XData', X, 'YData', Y);
            end
        end
    end
end