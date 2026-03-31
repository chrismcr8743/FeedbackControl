function ch03_armSim()
clc;
close all;
clear;

P = armParams();
arm = armDynamics();
reference = signalGenerator('amplitude', 0.01, 'frequency', 0.02);
torque = signalGenerator('amplitude', 0.2, 'frequency', 0.05);
dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.square(t);
        u = torque.square(t);
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
end