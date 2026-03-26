classdef vtolDataPlotter < handle
    properties
        fig
        ax

        time_history = []
        zref_history = []
        z_history = []
        href_history = []
        h_history = []
        theta_history = []
        force_history = []
        torque_history = []

        zLine
        zRefLine
        hLine
        hRefLine
        thetaLine
        forceLine
        torqueLine
    end

    methods
        function self = vtolDataPlotter()
            self.fig = figure('Name', 'VTOL System Data', 'NumberTitle', 'off');

            self.ax(1) = subplot(5,1,1); hold(self.ax(1), 'on'); grid(self.ax(1), 'on');
            ylabel(self.ax(1), 'z (m)');
            title(self.ax(1), 'VTOL System Data');
            self.zLine = plot(self.ax(1), NaN, NaN, 'b', 'LineWidth', 1.5);
            self.zRefLine = plot(self.ax(1), NaN, NaN, 'g', 'LineWidth', 1.5);

            self.ax(2) = subplot(5,1,2); hold(self.ax(2), 'on'); grid(self.ax(2), 'on');
            ylabel(self.ax(2), 'h (m)');
            self.hLine = plot(self.ax(2), NaN, NaN, 'b', 'LineWidth', 1.5);
            self.hRefLine = plot(self.ax(2), NaN, NaN, 'g', 'LineWidth', 1.5);

            self.ax(3) = subplot(5,1,3); hold(self.ax(3), 'on'); grid(self.ax(3), 'on');
            ylabel(self.ax(3), '\theta (deg)');
            self.thetaLine = plot(self.ax(3), NaN, NaN, 'b', 'LineWidth', 1.5);

            self.ax(4) = subplot(5,1,4); hold(self.ax(4), 'on'); grid(self.ax(4), 'on');
            ylabel(self.ax(4), 'force (N)');
            self.forceLine = plot(self.ax(4), NaN, NaN, 'b', 'LineWidth', 1.5);

            self.ax(5) = subplot(5,1,5); hold(self.ax(5), 'on'); grid(self.ax(5), 'on');
            xlabel(self.ax(5), 't (s)');
            ylabel(self.ax(5), 'torque (N m)');
            self.torqueLine = plot(self.ax(5), NaN, NaN, 'b', 'LineWidth', 1.5);
        end

        function update(self, t, states, motor_thrusts, z_ref, h_ref)
            if nargin < 5
                z_ref = 0.0;
            end
            if nargin < 6
                h_ref = 0.0;
            end

            P = vtolParams();
            motor_thrusts = motor_thrusts(:);
            F_tau = P.unmixing * motor_thrusts;

            self.time_history(end+1) = t;
            self.zref_history(end+1) = z_ref;
            self.z_history(end+1) = states(1);
            self.href_history(end+1) = h_ref;
            self.h_history(end+1) = states(2);
            self.theta_history(end+1) = 180/pi * states(3);
            self.force_history(end+1) = F_tau(1);
            self.torque_history(end+1) = F_tau(2);

            set(self.zLine,     'XData', self.time_history, 'YData', self.z_history);
            set(self.zRefLine,  'XData', self.time_history, 'YData', self.zref_history);
            set(self.hLine,     'XData', self.time_history, 'YData', self.h_history);
            set(self.hRefLine,  'XData', self.time_history, 'YData', self.href_history);
            set(self.thetaLine, 'XData', self.time_history, 'YData', self.theta_history);
            set(self.forceLine, 'XData', self.time_history, 'YData', self.force_history);
            set(self.torqueLine,'XData', self.time_history, 'YData', self.torque_history);

            drawnow;
        end
    end
end