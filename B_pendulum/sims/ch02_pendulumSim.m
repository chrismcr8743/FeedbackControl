function ch02_pendulumSim()
clc;
close all;
clear;

<<<<<<< HEAD
P = pendulumParams();

z_sig= signalGenerator('amplitude', 0.5, 'frequency', 0.1);
theta_sig = signalGenerator('amplitude', 0.25*pi, 'frequency', 0.5);
f_sig = signalGenerator('amplitude', 5.0, 'frequency', 0.5);

=======
% Add paths
this_dir = fileparts(mfilename('fullpath'));      % .../B_pendulum/sims
pend_dir = fileparts(this_dir);                   % .../B_pendulum
root_dir = fileparts(pend_dir);                   % project root

addpath(pend_dir);
addpath(fullfile(root_dir, 'tools'));

P = pendulumParams();

% Instantiate fake signal generators
z_fakeValueGenerator = signalGenerator('amplitude', 0.5, 'frequency', 0.1);
theta_fakeValueGenerator = signalGenerator('amplitude', 0.25*pi, 'frequency', 0.5);
f_fakeValueGenerator = signalGenerator('amplitude', 5.0, 'frequency', 0.5);

% Instantiate plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = pendulumDataPlotter();
animation = pendulumAnimation();

t = P.t_start;
while t < P.t_end
<<<<<<< HEAD
    z = z_sig.sin(t);
    theta = theta_sig.square(t);
    f = f_sig.sawtooth(t);

    state = [z; theta; 0.0; 0.0];

    animation.update(state);
    dataPlot.update(t, state, f);

=======
    % Set variables
    z = z_fakeValueGenerator.sin(t);
    theta = theta_fakeValueGenerator.square(t);
    f = f_fakeValueGenerator.sawtooth(t);

    % State = [z; theta; zdot; thetadot]
    state = [z; theta; 0.0; 0.0];

    % Update animation and plots
    animation.update(state);
    dataPlot.update(t, state, f);

    % Advance time
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
    t = t + P.t_plot;
    pause(0.02);
end

disp('Press any key to close');
waitforbuttonpress;
close all;
end