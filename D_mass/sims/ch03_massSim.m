clc;
close all;
clear;

P = massParams();

% instantiate plant and input generator
mass = massDynamics(0.0);
force = signalGenerator('amplitude', 1.0, 'frequency', 0.1);

% instantiate plots and animation
animation = massAnimation();
dataPlot = massDataPlotter();

t = P.t_start;
while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        u = force.sin(t);
        y = mass.update(u); 
        t = t + P.Ts;
    end

    animation.update(mass.state);
    dataPlot.update(t, mass.state, u);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;