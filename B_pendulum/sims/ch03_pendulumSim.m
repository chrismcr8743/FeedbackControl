function ch03_pendulumSim()
clc;
close all;
clear;

<<<<<<< HEAD

P = pendulumParams();
=======
this_dir = fileparts(mfilename('fullpath'));     % .../B_pendulum/sims
pend_dir = fileparts(this_dir);                  % .../B_pendulum
root_dir = fileparts(pend_dir);                  % project root

addpath(pend_dir);
addpath(fullfile(root_dir, 'tools'));

P = pendulumParams();

% exact match to the Python script you pasted
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
pendulum = pendulumDynamics(0.0);
force = signalGenerator('amplitude', 1.0, 'frequency', 1.0);

dataPlot = pendulumDataPlotter();
animation = pendulumAnimation();

t = P.t_start;
while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        u = force.sin(t);
<<<<<<< HEAD
        y = pendulum.update(u); 
=======
        y = pendulum.update(u); %#ok<NASGU>
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
        t = t + P.Ts;
    end

    animation.update(pendulum.state);
<<<<<<< HEAD
    dataPlot.update(t, pendulum.state, u);   
=======
    dataPlot.update(t, pendulum.state, u);   % no reference input
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    pause(0.01);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end