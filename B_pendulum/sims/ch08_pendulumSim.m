clc;
close all;
clear;

P = pendulumParams();
pendulum = pendulumDynamics(0.0);
controller = ch08_pendulumPD();

pendulum.state(2) = 10.0*pi/180.0;   % initial pendulum angle
sim_t_end = 10.0;                              
r = 0.0;                                               % zero cart position reference
d = 0.0;                                               % zero disturbance

dataPlot = pendulumDataPlotter();
animation = pendulumAnimation();

t = P.t_start;

while t < sim_t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        x = pendulum.state;
        u = controller.update(r, x);
        pendulum.update(u + d);
        t = t + P.Ts;
    end

    animation.update(pendulum.state);
    dataPlot.update(t, pendulum.state, u + d, r);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;