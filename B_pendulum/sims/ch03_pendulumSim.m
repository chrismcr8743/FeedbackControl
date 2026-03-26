function ch03_pendulumSim()
clc;
close all;
clear;

this_dir = fileparts(mfilename('fullpath'));     % .../B_pendulum/sims
pend_dir = fileparts(this_dir);                  % .../B_pendulum
root_dir = fileparts(pend_dir);                  % project root

addpath(pend_dir);
addpath(fullfile(root_dir, 'tools'));

P = pendulumParams();

% exact match to the Python script you pasted
pendulum = pendulumDynamics(0.0);
force = signalGenerator('amplitude', 1.0, 'frequency', 1.0);

dataPlot = pendulumDataPlotter();
animation = pendulumAnimation();

t = P.t_start;
while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        u = force.sin(t);
        y = pendulum.update(u); %#ok<NASGU>
        t = t + P.Ts;
    end

    animation.update(pendulum.state);
    dataPlot.update(t, pendulum.state, u);   % no reference input
    pause(0.01);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end