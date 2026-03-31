<<<<<<< HEAD
=======
% Longitudinal altitude PD control
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
clc;
close all;
clear;

<<<<<<< HEAD
P = vtolParams();
vtol = vtolDynamics(0.0);
controller = ch07_vtolPD();
reference = signalGenerator('amplitude', 1.0, 'frequency', 0.0, 'y_offset', P.h0);

% keep lateral target fixed
z_target = P.target0;
tau_cmd = 0.0;

=======
% Add paths
this_dir = fileparts(mfilename('fullpath'));   % .../F_vtol/sims
vtol_dir = fileparts(this_dir);                % .../F_vtol
root_dir = fileparts(vtol_dir);                % project root

addpath(vtol_dir);
addpath(fullfile(root_dir, 'tools'));

% Load parameters
P = vtolParams();

% Instantiate plant and controller
vtol = vtolDynamics(0.0);
controller = ch07_vtolPD();

% 1 meter altitude step about the initial altitude
reference = signalGenerator('amplitude', 1.0, ...
                            'frequency', 0.0, ...
                            'y_offset', P.h0);

% Keep lateral target fixed
z_target = P.target0;
tau_cmd = 0.0;

% Instantiate plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = vtolDataPlotter();
animation = vtolAnimation();

t = P.t_start;
<<<<<<< HEAD
y = vtol.h(); 
=======
y = vtol.h(); %#ok<NASGU>
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
<<<<<<< HEAD
        h_r = reference.step(t);
        F_cmd = controller.update(h_r, vtol.state);
        motor_thrusts = P.mixing * [F_cmd; tau_cmd];

        y = vtol.update(motor_thrusts); 
        t = t + P.Ts;
    end

=======
        % altitude reference
        h_r = reference.step(t);

        % controller computes total force
        F_cmd = controller.update(h_r, vtol.state);

        % convert [F; tau] to [fr; fl]
        motor_thrusts = P.mixing * [F_cmd; tau_cmd];

        % propagate plant
        y = vtol.update(motor_thrusts); %#ok<NASGU>
        t = t + P.Ts;
    end

    % update animation and plots
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    animation.update(vtol.state, z_target);
    dataPlot.update(t, vtol.state, motor_thrusts, z_target, h_r);

    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;