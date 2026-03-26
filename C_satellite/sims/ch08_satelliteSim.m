clc;
close all;
clear;


% mode = 'f';  % part (f): 15 deg square wave, 0.015 Hz
mode = 'g'; % part (g): 30 deg step with torque saturation

% Instantiate satellite and controller
satellite = satelliteDynamics(0.0);
controller = ch08_satellitePD(mode);

% Reference signal
switch lower(mode)
    case 'f'
        % Book part (f)
        reference = signalGenerator('amplitude', 15.0*pi/180.0, ...
                                    'frequency', 0.015);
        ref_type = 'square';
    case 'g'
        % Book part (g)
        reference = signalGenerator('amplitude', 30.0*pi/180.0, ...
                                    'frequency', 0.0);
        ref_type = 'step';
    otherwise
        error('Unknown mode. Use ''f'' or ''g''.');
end

% Instantiate plots and animation
dataPlot = satelliteDataPlotter();
animation = satelliteAnimation();

P = satelliteParams();
t = P.t_start;
y = satellite.h(); %#ok<NASGU>

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
        y = satellite.update(u); %#ok<NASGU>
        t = t + P.Ts;
    end

    animation.update(satellite.state);
    dataPlot.update(t, satellite.state, u, r);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;