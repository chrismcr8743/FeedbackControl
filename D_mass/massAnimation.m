classdef massAnimation < handle
    properties
        flagInit = true
        fig
        ax
        massHandle
        springHandle
        length
        width
    end

    methods
        function self = massAnimation()
            P = massParams();

            self.length = P.length;
            self.width = P.width;

            self.fig = figure('Name', 'Mass Animation', 'NumberTitle', 'off');
            self.ax = axes('Parent', self.fig);
            hold(self.ax, 'on');

            axis(self.ax, [-P.length-P.length/5, 2*P.length, -P.length, 2*P.length]);
            plot(self.ax, [-P.length-P.length/5, 2*P.length], [0, 0], 'k--'); % track
            plot(self.ax, [-P.length, -P.length], [0, 2*P.width], 'k');       % wall

            uicontrol( ...
                'Parent', self.fig, ...
                'Style', 'pushbutton', ...
                'String', 'Exit', ...
                'Units', 'normalized', ...
                'Position', [0.8, 0.805, 0.1, 0.075], ...
                'BackgroundColor', 'r', ...
                'FontWeight', 'bold', ...
                'FontSize', 18, ...
                'Callback', @(~,~) close(self.fig));
        end

        function update(self, u)
            z = u(1);   % mass position

            self.drawWeight(z);
            self.drawSpring(z);

            if self.flagInit
                self.flagInit = false;
            end

            drawnow;
        end

        function drawWeight(self, z)
            P = massParams();
            x = z - P.width/2.0;
            y = 0.0;
            pos = [x, y, P.width, P.width];

            if self.flagInit
                self.massHandle = rectangle(self.ax, ...
                    'Position', pos, ...
                    'FaceColor', 'blue', ...
                    'EdgeColor', 'black');
            else
                set(self.massHandle, 'Position', pos);
            end
        end

        function drawSpring(self, z)
            X = [-self.length, z - self.width/2.0];
            Y = [self.width/2.0, self.width/2.0];

            if self.flagInit
                self.springHandle = plot(self.ax, X, Y, 'k', 'LineWidth', 1);
            else
                set(self.springHandle, 'XData', X, 'YData', Y);
            end
        end
    end
end