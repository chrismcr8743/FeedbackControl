classdef satelliteVisualizer < handle
    properties
        fig

        % axes
        axAnim
        axPhi
        axTheta
        axTorque

        % animation
        flagInit = true
        baseHandle
        panelHandle
        length
        width

        % data history
        time_history = []
        phi_ref_history = []
        phi_history = []
        theta_history = []
        torque_history = []

        % plot handles
        phiLine
        phiRefLine
        thetaLine
        torqueLine
    end

    methods
        function self = satelliteVisualizer()
            P = satelliteParams();

            self.length = P.length;
            self.width = P.width;

            self.fig = figure('Name', 'Satellite Visualization', 'NumberTitle', 'off');

            tiled = tiledlayout(self.fig, 3, 2, ...
                'TileSpacing', 'compact', ...
                'Padding', 'compact');

            % ---------------- Animation ----------------
            self.axAnim = nexttile(tiled, [3 1]);
            hold(self.axAnim, 'on');
            axis(self.axAnim, [-2.0*P.length, 2.0*P.length, -2.0*P.length, 2.0*P.length]);
            plot(self.axAnim, [-2.0*P.length, 2.0*P.length], [0, 0], 'b--');
            xlabel(self.axAnim, 'x');
            ylabel(self.axAnim, 'y');
            title(self.axAnim, 'Satellite Animation');

            % phi plot
            self.axPhi = nexttile(tiled, 2);
            hold(self.axPhi, 'on');
            grid(self.axPhi, 'on');
            ylabel(self.axPhi, 'phi (deg)');
            title(self.axPhi, 'Satellite Data');

            self.phiLine = plot(self.axPhi, NaN, NaN, 'b', 'LineWidth', 1.5);
            self.phiRefLine = plot(self.axPhi, NaN, NaN, 'g--', 'LineWidth', 1.5);
            legend(self.axPhi, {'phi', 'phi ref'}, 'Location', 'best');

            % theta plot
            self.axTheta = nexttile(tiled, 4);
            hold(self.axTheta, 'on');
            grid(self.axTheta, 'on');
            ylabel(self.axTheta, 'theta (deg)');
            self.thetaLine = plot(self.axTheta, NaN, NaN, 'b', 'LineWidth', 1.5);

            % torque plot 
            self.axTorque = nexttile(tiled, 6);
            hold(self.axTorque, 'on');
            grid(self.axTorque, 'on');
            xlabel(self.axTorque, 't (s)');
            ylabel(self.axTorque, 'torque (N m)');
            self.torqueLine = plot(self.axTorque, NaN, NaN, 'r', 'LineWidth', 1.5);

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

            theta = states(1);
            phi = states(2);

            % animation
            self.drawBase(theta);
            self.drawPanel(phi);

            % data history
            self.time_history(end+1) = t;
            self.phi_ref_history(end+1) = 180/pi * reference;
            self.phi_history(end+1) = 180/pi * phi;
            self.theta_history(end+1) = 180/pi * theta;
            self.torque_history(end+1) = ctrl;

            % update plots
            set(self.phiLine, ...
                'XData', self.time_history, ...
                'YData', self.phi_history);

            set(self.phiRefLine, ...
                'XData', self.time_history, ...
                'YData', self.phi_ref_history);

            set(self.thetaLine, ...
                'XData', self.time_history, ...
                'YData', self.theta_history);

            set(self.torqueLine, ...
                'XData', self.time_history, ...
                'YData', self.torque_history);

            drawnow;

            if self.flagInit
                self.flagInit = false;
            end
        end

        function drawBase(self, theta)
            pts = [...
                 self.width/2.0,                  -self.width/2.0;
                 self.width/2.0,                  -self.width/6.0;
                 self.width/2.0 + self.width/6.0, -self.width/6.0;
                 self.width/2.0 + self.width/6.0,  self.width/6.0;
                 self.width/2.0,                   self.width/6.0;
                 self.width/2.0,                   self.width/2.0;
                -self.width/2.0,                   self.width/2.0;
                -self.width/2.0,                   self.width/6.0;
                -self.width/2.0 - self.width/6.0,  self.width/6.0;
                -self.width/2.0 - self.width/6.0, -self.width/6.0;
                -self.width/2.0,                  -self.width/6.0;
                -self.width/2.0,                  -self.width/2.0]';

            R = [cos(theta),  sin(theta);
                -sin(theta),  cos(theta)];

            xy = (R * pts)';

            if self.flagInit || isempty(self.baseHandle) || ~isgraphics(self.baseHandle)
                self.baseHandle = patch( ...
                    'Parent', self.axAnim, ...
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
                    'Parent', self.axAnim, ...
                    'XData', xy(:,1), ...
                    'YData', xy(:,2), ...
                    'FaceColor', 'green', ...
                    'EdgeColor', 'black');
            else
                set(self.panelHandle, 'XData', xy(:,1), 'YData', xy(:,2));
            end
        end

        function writeDataFile(self)
            time = self.time_history;
            phi = self.phi_history;
            theta = self.theta_history;
            torque = self.torque_history;
            save('io_data.mat', 'time', 'phi', 'theta', 'torque');
        end
    end
end