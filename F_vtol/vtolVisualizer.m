classdef vtolVisualizer < handle
    properties
        fig

        % axes
        axAnim
        axZ
        axH
        axTheta
        axForce
        axTorque

        % animation
        flagInit = true
        vehicleHandle
        targetHandle

        % data history
        time_history = []
        zref_history = []
        z_history = []
        href_history = []
        h_history = []
        theta_history = []
        force_history = []
        torque_history = []

        % plot handles
        zLine
        zRefLine
        hLine
        hRefLine
        thetaLine
        forceLine
        torqueLine
    end

    methods
        function self = vtolVisualizer()
            P = vtolParams();

            self.fig = figure('Name', 'VTOL Visualization', 'NumberTitle', 'off');

            tiled = tiledlayout(self.fig, 5, 2, ...
                'TileSpacing', 'compact', ...
                'Padding', 'compact');

            %  Animation 
            self.axAnim = nexttile(tiled, [5 1]);
            hold(self.axAnim, 'on');

            plot(self.axAnim, [0, P.length], [0, 0], 'k');  % ground line
            axis(self.axAnim, [-P.length/5, P.length + P.length/5, ...
                               -P.length/5, P.length + P.length/5]);
            xlabel(self.axAnim, 'z (m)');
            ylabel(self.axAnim, 'h (m)');
            title(self.axAnim, 'VTOL Animation');

            %  z plot 
            self.axZ = nexttile(tiled, 2);
            hold(self.axZ, 'on');
            grid(self.axZ, 'on');
            ylabel(self.axZ, 'z (m)');
            title(self.axZ, 'VTOL System Data');
            self.zLine = plot(self.axZ, NaN, NaN, 'b', 'LineWidth', 1.5);
            self.zRefLine = plot(self.axZ, NaN, NaN, 'g', 'LineWidth', 1.5);
            legend(self.axZ, {'z', 'z ref'}, 'Location', 'best');

            %  h plot 
            self.axH = nexttile(tiled, 4);
            hold(self.axH, 'on');
            grid(self.axH, 'on');
            ylabel(self.axH, 'h (m)');
            self.hLine = plot(self.axH, NaN, NaN, 'b', 'LineWidth', 1.5);
            self.hRefLine = plot(self.axH, NaN, NaN, 'g', 'LineWidth', 1.5);
            legend(self.axH, {'h', 'h ref'}, 'Location', 'best');

            %  theta plot 
            self.axTheta = nexttile(tiled, 6);
            hold(self.axTheta, 'on');
            grid(self.axTheta, 'on');
            ylabel(self.axTheta, '\theta (deg)');
            self.thetaLine = plot(self.axTheta, NaN, NaN, 'b', 'LineWidth', 1.5);

            %  force plot 
            self.axForce = nexttile(tiled, 8);
            hold(self.axForce, 'on');
            grid(self.axForce, 'on');
            ylabel(self.axForce, 'force (N)');
            self.forceLine = plot(self.axForce, NaN, NaN, 'b', 'LineWidth', 1.5);

            %  torque plot 
            self.axTorque = nexttile(tiled, 10);
            hold(self.axTorque, 'on');
            grid(self.axTorque, 'on');
            xlabel(self.axTorque, 't (s)');
            ylabel(self.axTorque, 'torque (N m)');
            self.torqueLine = plot(self.axTorque, NaN, NaN, 'b', 'LineWidth', 1.5);

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

        function update(self, t, states, motor_thrusts, z_ref, h_ref)
            if nargin < 5
                z_ref = 0.0;
            end
            if nargin < 6
                h_ref = 0.0;
            end

            z = states(1);
            h = states(2);
            theta = states(3);

            %  animation 
            self.drawVehicle(z, h, theta);
            self.drawTarget(z_ref);

            %  convert motor thrusts to force/torque 
            P = vtolParams();
            motor_thrusts = motor_thrusts(:);
            F_tau = P.unmixing * motor_thrusts;

            %  history 
            self.time_history(end+1) = t;
            self.zref_history(end+1) = z_ref;
            self.z_history(end+1) = z;
            self.href_history(end+1) = h_ref;
            self.h_history(end+1) = h;
            self.theta_history(end+1) = 180/pi * theta;
            self.force_history(end+1) = F_tau(1);
            self.torque_history(end+1) = F_tau(2);

            %  plots 
            set(self.zLine, 'XData', self.time_history, 'YData', self.z_history);
            set(self.zRefLine, 'XData', self.time_history, 'YData', self.zref_history);

            set(self.hLine, 'XData', self.time_history, 'YData', self.h_history);
            set(self.hRefLine, 'XData', self.time_history, 'YData', self.href_history);

            set(self.thetaLine, 'XData', self.time_history, 'YData', self.theta_history);
            set(self.forceLine, 'XData', self.time_history, 'YData', self.force_history);
            set(self.torqueLine, 'XData', self.time_history, 'YData', self.torque_history);

            drawnow;

            if self.flagInit
                self.flagInit = false;
            end
        end

        function drawVehicle(self, z, h, theta)
            x1 = 0.1; x2 = 0.3; x3 = 0.4;
            y1 = 0.05; y2 = 0.01;

            pts = [ ...
                 x1,  y1;
                 x1,  0;
                 x2,  0;
                 x2,  y2;
                 x3,  y2;
                 x3, -y2;
                 x2, -y2;
                 x2,  0;
                 x1,  0;
                 x1, -y1;
                -x1, -y1;
                -x1,  0;
                -x2,  0;
                -x2, -y2;
                -x3, -y2;
                -x3,  y2;
                -x2,  y2;
                -x2,  0;
                -x1,  0;
                -x1,  y1;
                 x1,  y1]';

            R = [cos(theta), -sin(theta);
                 sin(theta),  cos(theta)];

            pts = R * pts + [z; h];
            xy = pts';

            if self.flagInit
                self.vehicleHandle = patch( ...
                    'Parent', self.axAnim, ...
                    'XData', xy(:,1), ...
                    'YData', xy(:,2), ...
                    'FaceColor', 'blue', ...
                    'EdgeColor', 'black');
            else
                set(self.vehicleHandle, 'XData', xy(:,1), 'YData', xy(:,2));
            end
        end

        function drawTarget(self, target)
            w = 0.1;
            h = 0.05;
            pts = [ ...
                target + w/2, h;
                target + w/2, 0;
                target - w/2, 0;
                target - w/2, h;
                target + w/2, h];

            if self.flagInit
                self.targetHandle = patch( ...
                    'Parent', self.axAnim, ...
                    'XData', pts(:,1), ...
                    'YData', pts(:,2), ...
                    'FaceColor', 'blue', ...
                    'EdgeColor', 'black');
            else
                set(self.targetHandle, 'XData', pts(:,1), 'YData', pts(:,2));
            end
        end
    end
end