function ch03_armSim()
clc;
close all;
clear;

P = armParams();

% instantiate arm and input generators
arm = armDynamics();
reference = signalGenerator('amplitude', 0.01, 'frequency', 0.02);
torque = signalGenerator('amplitude', 0.2, 'frequency', 0.05);

% instantiate plots and animation
dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;

while t < P.t_end
    % propagate dynamics between plot updates
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        % Chapter 3 uses generated signals, not feedback control
        r = reference.square(t);
        u = torque.square(t);

        % propagate plant one integration step
        y = arm.update(u); %#ok<NASGU>

        % advance time by simulation sample time
        t = t + P.Ts;
    end

    % update animation and plots at slower plotting rate
    animation.update(arm.state);
    dataPlot.update(t, arm.state, u, r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end