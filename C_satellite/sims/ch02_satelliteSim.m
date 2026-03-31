function ch02_satelliteSim()
clc;
close all;
clear;

<<<<<<< HEAD
P = satelliteParams();
theta_sig = signalGenerator('amplitude', 2.0*pi, 'frequency', 0.1);
phi_sig   = signalGenerator('amplitude', 0.5,    'frequency', 0.1);
tau_sig   = signalGenerator('amplitude', 5.0,    'frequency', 0.5);

=======
% Add paths
this_dir = fileparts(mfilename('fullpath'));   % .../C_satellite/sims
sat_dir  = fileparts(this_dir);                % .../C_satellite
root_dir = fileparts(sat_dir);                 % project root

addpath(sat_dir);
addpath(fullfile(root_dir, 'tools'));

P = satelliteParams();

% Instantiate fake signal generators
theta_fakeValueGenerator = signalGenerator('amplitude', 2.0*pi, 'frequency', 0.1);
phi_fakeValueGenerator   = signalGenerator('amplitude', 0.5,    'frequency', 0.1);
tau_fakeValueGenerator   = signalGenerator('amplitude', 5.0,    'frequency', 0.5);

% Instantiate plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

t = P.t_start;
while t < P.t_end
<<<<<<< HEAD
    theta = theta_sig.sin(t);
    phi   = phi_sig.sin(t);
    tau   = tau_sig.sawtooth(t);
    state = [theta; phi; 0.0; 0.0];

    animation.update(state);
    dataPlot.update(t, state, tau);

=======
    % Set variables
    theta = theta_fakeValueGenerator.sin(t);
    phi   = phi_fakeValueGenerator.sin(t);
    tau   = tau_fakeValueGenerator.sawtooth(t);

    % State = [theta; phi; theta_dot; phi_dot]
    state = [theta; phi; 0.0; 0.0];

    % Update animation and plots
    animation.update(state);
    dataPlot.update(t, state, tau);

    % Advance time
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    t = t + P.t_plot;
    pause(0.02);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end