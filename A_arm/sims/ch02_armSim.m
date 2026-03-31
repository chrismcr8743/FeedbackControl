function ch02_armSim()
clc;
close all;
clear;

P = armParams();
theta_plot = signalGenerator('amplitude', 2.0*pi, 'frequency', 0.1);
tau_plot = signalGenerator('amplitude', 5.0, 'frequency', 0.5);
dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;
while t < P.t_end
    theta = theta_plot.sin(t);
    tau = tau_plot.sawtooth(t);
    theta_dot = 0.0;
    state = [theta; theta_dot];

    animation.update(state);
    dataPlot.update(t, state, tau);

    t = t + P.t_plot;
    pause(0.02);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end