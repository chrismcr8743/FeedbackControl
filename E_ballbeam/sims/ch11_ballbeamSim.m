clc;
close all;
clear;

P = ballbeamParams();

ballbeam = ballbeamDynamics(0.0);
controller = ch11_ballbeamSF();
reference = signalGenerator('amplitude', 0.15, 'frequency', 0.01, 'y_offset', 0.25);

visualizer = ballbeamVisualizer();

t = P.t_start;
u = P.Fe;

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.square(t);

        x = ballbeam.state;
        u = controller.update(r, x);

        ballbeam.update(u);
        t = t + P.Ts;
    end

    visualizer.update(t, ballbeam.state, u, r);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;