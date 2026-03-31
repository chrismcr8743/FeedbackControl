function ch03_satelliteSim()
clc;
close all;
clear;

<<<<<<< HEAD
P = satelliteParams();

=======
this_dir = fileparts(mfilename('fullpath'));   % .../C_satellite/sims
sat_dir  = fileparts(this_dir);                % .../C_satellite
root_dir = fileparts(sat_dir);                 % project root

addpath(sat_dir);
addpath(fullfile(root_dir, 'tools'));

P = satelliteParams();

% instantiate satellite and input generators
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
satellite = satelliteDynamics();
reference = signalGenerator('amplitude', 0.5, 'frequency', 0.1);
torque = signalGenerator('amplitude', 0.1, 'frequency', 0.1);

<<<<<<< HEAD
=======
% instantiate plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

t = P.t_start;
while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = 0;
        u = torque.sin(t);
<<<<<<< HEAD
        y = satellite.update(u); 
=======
        y = satellite.update(u); %#ok<NASGU>
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
        t = t + P.Ts;
    end

    animation.update(satellite.state);
    dataPlot.update(t, satellite.state, u, r);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end