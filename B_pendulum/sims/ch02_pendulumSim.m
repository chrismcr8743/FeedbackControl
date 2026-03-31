function ch02_pendulumSim()
clc;
close all;
clear;

P = pendulumParams();

z_sig= signalGenerator('amplitude', 0.5, 'frequency', 0.1);
theta_sig = signalGenerator('amplitude', 0.25*pi, 'frequency', 0.5);
f_sig = signalGenerator('amplitude', 5.0, 'frequency', 0.5);

dataPlot = pendulumDataPlotter();
animation = pendulumAnimation();

t = P.t_start;
while t < P.t_end
    z = z_sig.sin(t);
    theta = theta_sig.square(t);
    f = f_sig.sawtooth(t);

    state = [z; theta; 0.0; 0.0];

    animation.update(state);
    dataPlot.update(t, state, f);

    t = t + P.t_plot;
    pause(0.02);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end