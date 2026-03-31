clc;
close all;
clear;

pendulum = pendulumDynamics(0.2);   % 20 percent uncertainty
controller = ch10_pendulumPID();
reference = signalGenerator('amplitude', 0.5, 'frequency', 0.04);

dataPlot = pendulumDataPlotter();
animation = pendulumAnimation();

P = pendulumParams();
t = P.t_start;
y = pendulum.h();

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.square(t);   % reference input
        u = controller.update(r, y);
        y = pendulum.update(u);
        t = t + P.Ts;
    end

    animation.update(pendulum.state);
    dataPlot.update(t, pendulum.state, u, r);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;