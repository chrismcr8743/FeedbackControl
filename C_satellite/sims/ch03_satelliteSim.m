function ch03_satelliteSim()
clc;
close all;
clear;

P = satelliteParams();

satellite = satelliteDynamics();
reference = signalGenerator('amplitude', 0.5, 'frequency', 0.1);
torque = signalGenerator('amplitude', 0.1, 'frequency', 0.1);

dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

t = P.t_start;
while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = 0;
        u = torque.sin(t);
        y = satellite.update(u); 
        t = t + P.Ts;
    end

    animation.update(satellite.state);
    dataPlot.update(t, satellite.state, u, r);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end