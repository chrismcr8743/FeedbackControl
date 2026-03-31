function ch02_armSim()
clc;
close all;
clear;

P = armParams();
<<<<<<< HEAD
theta_plot = signalGenerator('amplitude', 2.0*pi, 'frequency', 0.1);
tau_plot = signalGenerator('amplitude', 5.0, 'frequency', 0.5);
=======

% Instantiate reference input classes
theta_plot = signalGenerator('amplitude', 2.0*pi, 'frequency', 0.1);
tau_plot = signalGenerator('amplitude', 5.0, 'frequency', 0.5);

% Instantiate plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;
while t < P.t_end
<<<<<<< HEAD
    theta = theta_plot.sin(t);
    tau = tau_plot.sawtooth(t);
    theta_dot = 0.0;
    state = [theta; theta_dot];

    animation.update(state);
    dataPlot.update(t, state, tau);

=======
    % Set variables
    theta = theta_plot.sin(t);
    tau = tau_plot.sawtooth(t);

    % For Chapter 2, theta_dot is just for display
    theta_dot = 0.0;

    % State = [theta; theta_dot]
    state = [theta; theta_dot];

    % Update animation and plots
    animation.update(state);
    dataPlot.update(t, state, tau);

    % Advance time
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    t = t + P.t_plot;
    pause(0.02);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end