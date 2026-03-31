clc;
close all;
clear;

P = armParams();
arm = armDynamics(0.0);
controller = ch07_armPD();
reference = signalGenerator('amplitude', 30.0*pi/180.0, 'frequency', 0.05);

dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;
y = arm.h(); 

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.square(t);
        x = arm.state;
        u = controller.update(r, x);
        y = arm.update(u); 
        t = t + P.Ts;
    end

    animation.update(arm.state);
    dataPlot.update(t, arm.state, u, r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;