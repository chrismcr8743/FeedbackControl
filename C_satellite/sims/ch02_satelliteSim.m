function ch02_satelliteSim()
clc;
close all;
clear;

P = satelliteParams();
theta_sig = signalGenerator('amplitude', 2.0*pi, 'frequency', 0.1);
phi_sig   = signalGenerator('amplitude', 0.5,    'frequency', 0.1);
tau_sig   = signalGenerator('amplitude', 5.0,    'frequency', 0.5);

dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

t = P.t_start;
while t < P.t_end
    theta = theta_sig.sin(t);
    phi   = phi_sig.sin(t);
    tau   = tau_sig.sawtooth(t);
    state = [theta; phi; 0.0; 0.0];

    animation.update(state);
    dataPlot.update(t, state, tau);

    t = t + P.t_plot;
    pause(0.02);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end