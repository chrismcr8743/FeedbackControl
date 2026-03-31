clc;
close all;
clear;

P = massParams();
mass = massDynamics(0.0);
controller = ch07_massPD();
reference = signalGenerator('amplitude', 1.0, 'frequency', 0.0);

dataPlot = massDataPlotter();
animation = massAnimation();

t = P.t_start;
y = mass.h(); 

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.step(t);   
        x = mass.state;
        u = controller.update(r, x);
        y = mass.update(u); 
        t = t + P.Ts;
    end

    animation.update(mass.state);
    dataPlot.update(t, mass.state, u, r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;