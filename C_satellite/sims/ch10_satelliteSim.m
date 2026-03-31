clc;
close all;
clear;

satellite = satelliteDynamics(0.2);   % 20 percent uncertainty
controller = ch10_satellitePID();
reference = signalGenerator('amplitude', 15.0*pi/180.0, 'frequency', 0.02);

dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

P = satelliteParams();
t = P.t_start;
y = satellite.h();

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.square(t);
        u = controller.update(r, y);
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