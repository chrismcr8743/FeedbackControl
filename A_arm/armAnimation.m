classdef armAnimation < handle
    properties
        flagInit = true
        fig
        ax
        armHandle
        length
        width
    end

    methods
        function self = armAnimation()
            P = armParams();

            self.length = P.length;
            self.width = P.width;

            self.fig = figure('Name', 'Arm Animation', 'NumberTitle', 'off');
            self.ax = axes('Parent', self.fig);
            hold(self.ax, 'on');
            grid(self.ax, 'on');
            axis(self.ax, 'equal');
            axis(self.ax, [-2.0*P.length, 2.0*P.length, -2.0*P.length, 2.0*P.length]);

            plot(self.ax, [0, P.length], [0, 0], 'k--');
            xlabel(self.ax, 'x (m)');
            ylabel(self.ax, 'y (m)');
            title(self.ax, 'Arm Animation');

            uicontrol( ...
                'Parent', self.fig, ...
                'Style', 'pushbutton', ...
                'String', 'Exit', ...
                'Units', 'normalized', ...
                'Position', [0.80, 0.88, 0.12, 0.07], ...
                'BackgroundColor', [1 0.4 0.4], ...
                'FontWeight', 'bold', ...
                'FontSize', 12, ...
                'Callback', @(~,~) close(self.fig));
        end

        function update(self, x)
            theta = x(1);

            X = [0, self.length*cos(theta)];
            Y = [0, self.length*sin(theta)];

            if self.flagInit
                self.armHandle = plot(self.ax, X, Y, 'b', 'LineWidth', 5);
                self.flagInit = false;
            else
                set(self.armHandle, 'XData', X, 'YData', Y);
            end

            drawnow;
        end
    end
end