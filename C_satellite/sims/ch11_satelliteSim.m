%% ch11_satelliteSim
clc;
close all;
clear;

P = satelliteParams();

satellite = satelliteDynamics();
controller = ch11_satelliteSF();
reference = signalGenerator('amplitude', 15.0*pi/180.0, 'frequency', 0.04);

dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

t = P.t_start;
y = satellite.h(); 

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.square(t);
        x = satellite.state;
        u = controller.update(r, x);
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