clc;
close all;
clear;

<<<<<<< HEAD
P = armParams();
=======
% Load parameters
P = armParams();

% Instantiate arm, controller, and reference classes
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
arm = armDynamics(0.0);
controller = ch07_armPD();
reference = signalGenerator('amplitude', 30.0*pi/180.0, 'frequency', 0.05);

<<<<<<< HEAD
=======
% Instantiate simulation plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = armDataPlotter();
animation = armAnimation();

t = P.t_start;
<<<<<<< HEAD
y = arm.h(); 

while t < P.t_end
=======
y = arm.h(); %#ok<NASGU>

while t < P.t_end
    % Propagate dynamics between plot samples
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    t_next_plot = t + P.t_plot;

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

    % Update animation and plots
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    animation.update(arm.state);
    dataPlot.update(t, arm.state, u, r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;