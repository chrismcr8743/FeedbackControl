classdef armVisualizer < handle
    properties
        fig

        % axes
        axAnim
        axTheta
        axTorque

        % animation
        armHandle
        flagInit = true
        length
        width

        % data history
        time_history = []
        theta_ref_history = []
        theta_history = []
        torque_history = []

        % plot handles
        thetaLine
        thetaRefLine
        torqueLine
    end

    methods
        function self = armVisualizer()
            P = armParams();

            self.length = P.length;
            self.width = P.width;

            self.fig = figure('Name', 'Arm Visualization', 'NumberTitle', 'off');

            tiled = tiledlayout(self.fig, 2, 2, ...
                'TileSpacing', 'compact', ...
                'Padding', 'compact');

            % Animation axis
            self.axAnim = nexttile(tiled, [2 1]);
            hold(self.axAnim, 'on');
            grid(self.axAnim, 'on');
            axis(self.axAnim, 'equal');
            axis(self.axAnim, [-2.0*P.length, 2.0*P.length, -2.0*P.length, 2.0*P.length]);
            xlabel(self.axAnim, 'x (m)');
            ylabel(self.axAnim, 'y (m)');
            title(self.axAnim, 'Arm Animation');

            plot(self.axAnim, [0, P.length], [0, 0], 'k--');

            % Theta axis
            self.axTheta = nexttile(tiled, 2);
            hold(self.axTheta, 'on');
            grid(self.axTheta, 'on');
            ylabel(self.axTheta, 'theta (deg)');
            title(self.axTheta, 'Arm Data');

            self.thetaLine = plot(self.axTheta, NaN, NaN, 'b', 'LineWidth', 1.5);
            self.thetaRefLine = plot(self.axTheta, NaN, NaN, 'g--', 'LineWidth', 1.5);

            legend(self.axTheta, {'theta', 'theta ref'}, 'Location', 'best');

            % Torque axis 
            self.axTorque = nexttile(tiled, 4);
            hold(self.axTorque, 'on');
            grid(self.axTorque, 'on');
            xlabel(self.axTorque, 't (s)');
            ylabel(self.axTorque, 'torque (N-m)');

            self.torqueLine = plot(self.axTorque, NaN, NaN, 'r', 'LineWidth', 1.5);

            % exit button
            uicontrol( ...
                'Parent', self.fig, ...
                'Style', 'pushbutton', ...
                'String', 'Exit', ...
                'Units', 'normalized', ...
                'Position', [0.86, 0.92, 0.10, 0.05], ...
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

            % Update animation 
            X = [0, self.length*cos(theta)];
            Y = [0, self.length*sin(theta)];

            if self.flagInit
                self.armHandle = plot(self.axAnim, X, Y, 'b', 'LineWidth', 5);
                self.flagInit = false;
            else
                set(self.armHandle, 'XData', X, 'YData', Y);
            end

            % Update data histories 
            self.time_history(end+1) = t;
            self.theta_ref_history(end+1) = 180/pi * reference;
            self.theta_history(end+1) = 180/pi * theta;
            self.torque_history(end+1) = ctrl;

            % Update theta plot 
            set(self.thetaLine, ...
                'XData', self.time_history, ...
                'YData', self.theta_history);

            set(self.thetaRefLine, ...
                'XData', self.time_history, ...
                'YData', self.theta_ref_history);

            % Update torque plot 
            set(self.torqueLine, ...
                'XData', self.time_history, ...
                'YData', self.torque_history);

            drawnow;
        end

        function write_data_file(self)
            time = self.time_history;
            theta = self.theta_history;
            torque = self.torque_history;
            save('io_data.mat', 'time', 'theta', 'torque');
        end
    end
end