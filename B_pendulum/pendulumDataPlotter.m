classdef pendulumDataPlotter < handle
    properties
        fig
        ax

        time_history = []
        zref_history = []
        z_history = []
        theta_history = []
        force_history = []

        zLine
        zRefLine
        thetaLine
        forceLine
    end

    methods
        function self = pendulumDataPlotter()
            self.fig = figure('Name', 'Pendulum Data', 'NumberTitle', 'off');

            self.ax(1) = subplot(3,1,1);
            hold(self.ax(1), 'on');
            grid(self.ax(1), 'on');
            ylabel(self.ax(1), 'z (m)');
            title(self.ax(1), 'Pendulum Data');
            self.zLine = plot(self.ax(1), NaN, NaN, 'b', 'LineWidth', 1.5);
            self.zRefLine = plot(self.ax(1), NaN, NaN, 'g--', 'LineWidth', 1.5);
            legend(self.ax(1), {'z', 'z ref'}, 'Location', 'best');

            self.ax(2) = subplot(3,1,2);
            hold(self.ax(2), 'on');
            grid(self.ax(2), 'on');
            ylabel(self.ax(2), 'theta (deg)');
            self.thetaLine = plot(self.ax(2), NaN, NaN, 'b', 'LineWidth', 1.5);

            self.ax(3) = subplot(3,1,3);
            hold(self.ax(3), 'on');
            grid(self.ax(3), 'on');
            xlabel(self.ax(3), 't (s)');
            ylabel(self.ax(3), 'force (N)');
            self.forceLine = plot(self.ax(3), NaN, NaN, 'r', 'LineWidth', 1.5);
        end

        function update(self, t, states, ctrl, reference)
            if nargin < 5
                reference = 0.0;
            end

            self.time_history(end+1) = t;
            self.zref_history(end+1) = reference;
            self.z_history(end+1) = states(1);
            self.theta_history(end+1) = 180/pi * states(2);
            self.force_history(end+1) = ctrl;

            set(self.zLine, 'XData', self.time_history, 'YData', self.z_history);
            set(self.zRefLine, 'XData', self.time_history, 'YData', self.zref_history);
            set(self.thetaLine, 'XData', self.time_history, 'YData', self.theta_history);
            set(self.forceLine, 'XData', self.time_history, 'YData', self.force_history);

            drawnow;
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