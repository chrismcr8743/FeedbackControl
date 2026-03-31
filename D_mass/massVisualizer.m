classdef massVisualizer < handle
    properties
        fig

        % axes
        axAnim
        axZ
        axForce

        % animation
        flagInit = true
        massHandle
        springHandle
        length
        width

        % data history
        time_history = []
        z_ref_history = []
        z_history = []
        force_history = []

        % plot handles
        zLine
        zRefLine
        forceLine
    end

    methods
        function self = massVisualizer()
            P = massParams();

            self.length = P.length;
            self.width = P.width;

            self.fig = figure('Name', 'Mass Visualization', 'NumberTitle', 'off');

            tiled = tiledlayout(self.fig, 2, 2, ...
                'TileSpacing', 'compact', ...
                'Padding', 'compact');

            % Animation 
            self.axAnim = nexttile(tiled, [2 1]);
            hold(self.axAnim, 'on');

            axis(self.axAnim, [-P.length-P.length/5, 2*P.length, -P.length, 2*P.length]);
            plot(self.axAnim, [-P.length-P.length/5, 2*P.length], [0, 0], 'k--'); % track
            plot(self.axAnim, [-P.length, -P.length], [0, 2*P.width], 'k');       % wall
            xlabel(self.axAnim, 'z');
            ylabel(self.axAnim, 'y');
            title(self.axAnim, 'Mass Animation');

            %  z plot 
            self.axZ = nexttile(tiled, 2);
            hold(self.axZ, 'on');
            grid(self.axZ, 'on');
            ylabel(self.axZ, 'z (m)');
            title(self.axZ, 'Mass Data');

            self.zLine = plot(self.axZ, NaN, NaN, 'b', 'LineWidth', 1.5);
            self.zRefLine = plot(self.axZ, NaN, NaN, 'g', 'LineWidth', 1.5);
            legend(self.axZ, {'z', 'z ref'}, 'Location', 'best');

            %  force plot 
            self.axForce = nexttile(tiled, 4);
            hold(self.axForce, 'on');
            grid(self.axForce, 'on');
            xlabel(self.axForce, 't (s)');
            ylabel(self.axForce, 'force (N)');

            self.forceLine = plot(self.axForce, NaN, NaN, 'b', 'LineWidth', 1.5);

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

            %  animation 
            self.drawWeight(z);
            self.drawSpring(z);

            %  history 
            self.time_history(end+1) = t;
            self.z_ref_history(end+1) = reference;
            self.z_history(end+1) = z;
            self.force_history(end+1) = ctrl;

            %  plots 
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

            if self.flagInit
                self.flagInit = false;
            end
        end

        function drawWeight(self, z)
            P = massParams();
            x = z - P.width/2.0;
            y = 0.0;
            pos = [x, y, P.width, P.width];

            if self.flagInit
                self.massHandle = rectangle(self.axAnim, ...
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
                self.springHandle = plot(self.axAnim, X, Y, 'k', 'LineWidth', 1);
            else
                set(self.springHandle, 'XData', X, 'YData', Y);
            end
        end
    end
end