clc;
close all;
clear;

% load parameters
P = armParams();

% instantiate arm, controller, and reference classes
arm = armDynamics();
controller = ch08_armPD();
reference = signalGenerator( ...
    'amplitude', 50.0*pi/180.0, ...
    'frequency', 0.05);

disturbance = signalGenerator('amplitude', 0.0); %#ok<NASGU>

% instantiate the simulation plots and animation
dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;
y = arm.h(); %#ok<NASGU>

while t < P.t_end
    % propagate dynamics in between plot samples
    t_next_plot = t + P.t_plot;

    % update control and dynamics at faster simulation rate
    while t < t_next_plot
        r = reference.square(t);
        x = arm.state;
        u = controller.update(r, x);
        y = arm.update(u); %#ok<NASGU>
        t = t + P.Ts;
    end

    % update animation and data plots
    animation.update(arm.state);
    dataPlot.update(t, arm.state, u, r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;