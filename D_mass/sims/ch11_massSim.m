clc;
close all;
clear;

P = massParams();

mass = massDynamics(0.0);
controller = ch11_massSF();
reference = signalGenerator('amplitude', 1.0, 'frequency', 0.0);

visualizer = massVisualizer();

t = P.t_start;
y = mass.h();
u = 0.0;

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.step(t);
        u = controller.update(r, y);
        y = mass.update(u);
        t = t + P.Ts;
    end

    visualizer.update(t, mass.state, u, r);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;