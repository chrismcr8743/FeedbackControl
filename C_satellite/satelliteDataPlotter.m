classdef satelliteDataPlotter < handle
    properties
        fig
        ax

        time_history = []
        phi_ref_history = []
        phi_history = []
        theta_history = []
        torque_history = []

        phiLine
        phiRefLine
        thetaLine
        torqueLine
    end

    methods
        function self = satelliteDataPlotter()
            self.fig = figure('Name', 'Satellite Data', 'NumberTitle', 'off');

            self.ax(1) = subplot(3,1,1);
            hold(self.ax(1), 'on');
            grid(self.ax(1), 'on');
            ylabel(self.ax(1), 'phi (deg)');
            title(self.ax(1), 'Satellite Data');
            self.phiLine    = plot(self.ax(1), NaN, NaN, 'b', 'LineWidth', 1.5);
            self.phiRefLine = plot(self.ax(1), NaN, NaN, 'g--', 'LineWidth', 1.5);
            legend(self.ax(1), {'phi', 'phi ref'}, 'Location', 'best');

            self.ax(2) = subplot(3,1,2);
            hold(self.ax(2), 'on');
            grid(self.ax(2), 'on');
            ylabel(self.ax(2), 'theta (deg)');
            self.thetaLine = plot(self.ax(2), NaN, NaN, 'b', 'LineWidth', 1.5);

            self.ax(3) = subplot(3,1,3);
            hold(self.ax(3), 'on');
            grid(self.ax(3), 'on');
            xlabel(self.ax(3), 't (s)');
            ylabel(self.ax(3), 'torque (N m)');
            self.torqueLine = plot(self.ax(3), NaN, NaN, 'r', 'LineWidth', 1.5);
        end

        function update(self, t, states, ctrl, reference)
            if nargin < 5
                reference = 0.0;
            end

            self.time_history(end+1) = t;
            self.phi_ref_history(end+1) = 180/pi * reference;
            self.phi_history(end+1) = 180/pi * states(2);
            self.theta_history(end+1) = 180/pi * states(1);
            self.torque_history(end+1) = ctrl;

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