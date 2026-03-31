clc;
close all;
clear;

<<<<<<< HEAD
P = armParams();
arm = armDynamics();
controller = ch08_armPD();
reference = signalGenerator('amplitude', 50.0*pi/180.0, 'frequency', 0.05);
disturbance = signalGenerator('amplitude', 0.0); 

=======
% load parameters
P = armParams();

% instantiate arm, controller, and reference classes
arm = armDynamics();
controller = ch08_armPD();
reference = signalGenerator( ...
    'amplitude', 50.0*pi/180.0, ...
    'frequency', 0.05);

disturbance = signalGenerator('amplitude', 0.0); %#ok<NASGU>

% instantiate the simulation plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;
<<<<<<< HEAD
y = arm.h(); 

while t < P.t_end
    t_next_plot = t + P.t_plot;

=======
y = arm.h(); %#ok<NASGU>

while t < P.t_end
    % propagate dynamics in between plot samples
    t_next_plot = t + P.t_plot;

    % update control and dynamics at faster simulation rate
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    while t < t_next_plot
        r = reference.square(t);
        x = arm.state;
        u = controller.update(r, x);
<<<<<<< HEAD
        y = arm.update(u); 
        t = t + P.Ts;
    end

=======
        y = arm.update(u); %#ok<NASGU>
        t = t + P.Ts;
    end

    % update animation and data plots
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    animation.update(arm.state);
    dataPlot.update(t, arm.state, u, r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;