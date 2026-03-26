% PD control simulation for msd system
clc;
close all;
clear;

% Add paths
this_dir = fileparts(mfilename('fullpath'));   % .../D_mass/sims
mass_dir = fileparts(this_dir);                % .../D_mass
root_dir = fileparts(mass_dir);                % project root

addpath(mass_dir);
addpath(fullfile(root_dir, 'tools'));

% Load parameters
P = massParams();

% Instantiate plant, controller, and reference
mass = massDynamics(0.0);
controller = ch07_massPD();
reference = signalGenerator('amplitude', 1.0, 'frequency', 0.0);

% Instantiate plots and animation
dataPlot = massDataPlotter();
animation = massAnimation();

t = P.t_start;
y = mass.h(); %#ok<NASGU>

while t < P.t_end
    % Propagate dynamics between plot updates
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.step(t);   % 1 meter step input
        x = mass.state;
        u = controller.update(r, x);
        y = mass.update(u); %#ok<NASGU>
        t = t + P.Ts;
    end

    % Update animation and plots
    animation.update(mass.state);
    dataPlot.update(t, mass.state, u, r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;