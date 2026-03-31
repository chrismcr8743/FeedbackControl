clc;
close all;
clear;


<<<<<<< HEAD
% mode = 'f';  % 15 deg square wave, 0.015 Hz
mode = 'g'; % 30 deg step with torque saturation

=======
% mode = 'f';  % part (f): 15 deg square wave, 0.015 Hz
mode = 'g'; % part (g): 30 deg step with torque saturation

% Instantiate satellite and controller
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
satellite = satelliteDynamics(0.0);
controller = ch08_satellitePD(mode);

% Reference signal
switch lower(mode)
    case 'f'
<<<<<<< HEAD
=======
        % Book part (f)
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
        reference = signalGenerator('amplitude', 15.0*pi/180.0, ...
                                    'frequency', 0.015);
        ref_type = 'square';
    case 'g'
<<<<<<< HEAD
=======
        % Book part (g)
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
        reference = signalGenerator('amplitude', 30.0*pi/180.0, ...
                                    'frequency', 0.0);
        ref_type = 'step';
    otherwise
        error('Unknown mode. Use ''f'' or ''g''.');
end

<<<<<<< HEAD
=======
% Instantiate plots and animation
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

P = satelliteParams();
t = P.t_start;
<<<<<<< HEAD
y = satellite.h(); 
=======
y = satellite.h(); %#ok<NASGU>
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        switch ref_type
            case 'square'
                r = reference.square(t);
            case 'step'
                r = reference.step(t);
        end

        x = satellite.state;
        u = controller.update(r, x);
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