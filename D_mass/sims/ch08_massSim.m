clc;
close all;
clear;

% mode = 'a'; % tr = 2 s, zeta = 0.7, no saturation
mode = 'b'; % saturation on, tune tr for fastest non saturating response

P = massParams();
mass = massDynamics(0.0);
controller = ch08_massPD(mode);
reference = signalGenerator('amplitude', 1.0, 'frequency', 0.0);

visualizer = massVisualizer();

t = P.t_start;
u = 0.0;
u_max = 0.0;

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.step(t);
        x = mass.state;
        u = controller.update(r, x);
        mass.update(u);

        u_max = max(u_max, abs(u));
        t = t + P.Ts;
    end

    visualizer.update(t, mass.state, u, r);
    pause(0.0001);
end

fprintf('u_max = %f N\n', u_max);

disp('Press any key to close');
waitforbuttonpress;
close all;