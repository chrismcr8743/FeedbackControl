classdef pendulumVisualizer < handle
    properties
        fig

        % axes
        axAnim
        axZ
        axTheta
        axForce

        % animation handles
        flagInit = true
        cartHandle
        bobHandle
        rodHandle

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
        function self = pendulumVisualizer()
            P = pendulumParams();

            self.fig = figure('Name', 'Pendulum Visualization', 'NumberTitle', 'off');

            tiled = tiledlayout(self.fig, 3, 2, ...
                'TileSpacing', 'compact', ...
                'Padding', 'compact');

            % Animation
            self.axAnim = nexttile(tiled, [3 1]);
            hold(self.axAnim, 'on');
            grid(self.axAnim, 'on');
            axis(self.axAnim, [-3*P.ell, 3*P.ell, -0.1, 3*P.ell]);
            axis(self.axAnim, 'equal');
            xlabel(self.axAnim, 'z');
            ylabel(self.axAnim, 'y');
            title(self.axAnim, 'Pendulum Animation');
            plot(self.axAnim, [-2*P.ell, 2*P.ell], [0, 0], 'b--');

            % z plot
            self.axZ = nexttile(tiled, 2);
            hold(self.axZ, 'on');
            grid(self.axZ, 'on');
            ylabel(self.axZ, 'z (m)');
            title(self.axZ, 'Pendulum Data');

            self.zLine = plot(self.axZ, NaN, NaN, 'b', 'LineWidth', 1.5);
            self.zRefLine = plot(self.axZ, NaN, NaN, 'g--', 'LineWidth', 1.5);
            legend(self.axZ, {'z', 'z ref'}, 'Location', 'best');

            % theta plot
            self.axTheta = nexttile(tiled, 4);
            hold(self.axTheta, 'on');
            grid(self.axTheta, 'on');
            ylabel(self.axTheta, 'theta (deg)');
            self.thetaLine = plot(self.axTheta, NaN, NaN, 'b', 'LineWidth', 1.5);

            % force plot 
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

            % animation
            self.drawCart(z);
            self.drawBob(z, theta);
            self.drawRod(z, theta);

            % history
            self.time_history(end+1) = t;
            self.zref_history(end+1) = reference;
            self.z_history(end+1) = z;
            self.theta_history(end+1) = 180/pi * theta;
            self.force_history(end+1) = ctrl;

            % plots 
            set(self.zLine, ...
                'XData', self.time_history, ...
                'YData', self.z_history);

            set(self.zRefLine, ...
                'XData', self.time_history, ...
                'YData', self.zref_history);

            set(self.thetaLine, ...
                'XData', self.time_history, ...
                'YData', self.theta_history);

            set(self.forceLine, ...
                'XData', self.time_history, ...
                'YData', self.force_history);

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
                self.cartHandle = rectangle(self.axAnim, ...
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
                self.bobHandle = rectangle(self.axAnim, ...
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
                self.rodHandle = plot(self.axAnim, X, Y, 'k', 'LineWidth', 1.5);
            else
                set(self.rodHandle, 'XData', X, 'YData', Y);
            end
        end

        function writeDataFile(self)
            time = self.time_history;
            z = self.z_history;
            theta = self.theta_history;
            force = self.force_history;
            save('io_data.mat', 'time', 'z', 'theta', 'force');
        end
    end
end