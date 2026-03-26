classdef armDataPlotter < handle
    properties
        fig
        ax

        time_history = []
        theta_ref_history = []
        theta_history = []
        torque_history = []

        thetaLine
        thetaRefLine
        torqueLine
    end

    methods
        function self = armDataPlotter()
            self.fig = figure('Name', 'Arm Data', 'NumberTitle', 'off');

            self.ax(1) = subplot(2,1,1);
            hold(self.ax(1), 'on');
            grid(self.ax(1), 'on');
            ylabel(self.ax(1), 'theta (deg)');
            title(self.ax(1), 'Arm Data');
            self.thetaLine = plot(self.ax(1), NaN, NaN, 'b', 'LineWidth', 1.5);
            self.thetaRefLine = plot(self.ax(1), NaN, NaN, 'g--', 'LineWidth', 1.5);
            legend(self.ax(1), {'theta', 'theta ref'}, 'Location', 'best');

            self.ax(2) = subplot(2,1,2);
            hold(self.ax(2), 'on');
            grid(self.ax(2), 'on');
            xlabel(self.ax(2), 't (s)');
            ylabel(self.ax(2), 'torque (N-m)');
            self.torqueLine = plot(self.ax(2), NaN, NaN, 'r', 'LineWidth', 1.5);
        end

        function update(self, t, states, ctrl, reference)
            if nargin < 5
                reference = 0.0;
            end

            self.time_history(end+1) = t;
            self.theta_ref_history(end+1) = 180/pi * reference;
            self.theta_history(end+1) = 180/pi * states(1);
            self.torque_history(end+1) = ctrl;

            set(self.thetaLine, ...
                'XData', self.time_history, ...
                'YData', self.theta_history);

            set(self.thetaRefLine, ...
                'XData', self.time_history, ...
                'YData', self.theta_ref_history);

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