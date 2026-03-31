clc;
close all;
clear;

P = vtolParams();
vtol = vtolDynamics(0.0);
controller = ch07_vtolPD();
reference = signalGenerator('amplitude', 1.0, 'frequency', 0.0, 'y_offset', P.h0);

% keep lateral target fixed
z_target = P.target0;
tau_cmd = 0.0;

dataPlot = vtolDataPlotter();
animation = vtolAnimation();

t = P.t_start;
y = vtol.h(); 

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        h_r = reference.step(t);
        F_cmd = controller.update(h_r, vtol.state);
        motor_thrusts = P.mixing * [F_cmd; tau_cmd];

        y = vtol.update(motor_thrusts); 
        t = t + P.Ts;
    end

    animation.update(vtol.state, z_target);
    dataPlot.update(t, vtol.state, motor_thrusts, z_target, h_r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;