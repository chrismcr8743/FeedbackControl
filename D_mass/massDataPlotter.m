classdef massDataPlotter < handle
    properties
        fig
        ax

        time_history = []
        z_ref_history = []
        z_history = []
        force_history = []

        zLine
        zRefLine
        forceLine
    end

    methods
        function self = massDataPlotter()
            self.fig = figure('Name', 'Mass Data', 'NumberTitle', 'off');

            self.ax(1) = subplot(2,1,1);
            hold(self.ax(1), 'on');
            grid(self.ax(1), 'on');
            ylabel(self.ax(1), 'z(m)');
            title(self.ax(1), 'Mass Data');
            self.zLine    = plot(self.ax(1), NaN, NaN, 'b', 'LineWidth', 1.5);
            self.zRefLine = plot(self.ax(1), NaN, NaN, 'g', 'LineWidth', 1.5);

            self.ax(2) = subplot(2,1,2);
            hold(self.ax(2), 'on');
            grid(self.ax(2), 'on');
            xlabel(self.ax(2), 't(s)');
            ylabel(self.ax(2), 'force(N)');
            self.forceLine = plot(self.ax(2), NaN, NaN, 'b', 'LineWidth', 1.5);
        end

        function update(self, t, states, ctrl, reference)
            if nargin < 5
                reference = 0.0;
            end

            self.time_history(end+1) = t;
            self.z_ref_history(end+1) = reference;
            self.z_history(end+1) = states(1);
            self.force_history(end+1) = ctrl;

            set(self.zLine, ...
                'XData', self.time_history, ...
                'YData', self.z_history);

            set(self.zRefLine, ...
                'XData', self.time_history, ...
                'YData', self.z_ref_history);

            set(self.forceLine, ...
                'XData', self.time_history, ...
                'YData', self.force_history);

            drawnow;
        end
    end
end