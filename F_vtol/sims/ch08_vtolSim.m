clc;
close all;
clear;

% mode:
%   'a' -> altitude step test
%   'e' -> lateral square-wave test from the book
%   'f' -> same as e, but rotor saturation turned on in controller
mode = 'f';


% Load parameters
P = vtolParams();

% Instantiate plant and controller
vtol = vtolDynamics(0.0);
controller = ch08_vtolPD(mode);

% Reference signals
switch lower(mode)
    case 'a'
        % altitude step for F.8(a)
        z_ref_signal = signalGenerator('amplitude', 0.0, 'frequency', 0.0, ...
            'y_offset', P.z0);
        h_ref_signal = signalGenerator('amplitude', 1.0, 'frequency', 0.0, ...
            'y_offset', P.h0);
        ref_z_type = 'step';
        ref_h_type = 'step';
        sim_t_end = 60.0;

    case 'e'
        % lateral square wave from F.8(e)
        z_ref_signal = signalGenerator('amplitude', 2.5, 'frequency', 0.08, ...
            'y_offset', 3.0);
        h_ref_signal = signalGenerator('amplitude', 0.0, 'frequency', 0.0, ...
            'y_offset', P.h0);
        ref_z_type = 'square';
        ref_h_type = 'step';
        sim_t_end = P.t_end;

    case 'f'
        % same lateral command as (e), but with rotor saturation enabled
        % and tr_h / tr_z used as tuning parameters
        z_ref_signal = signalGenerator('amplitude', 2.5, 'frequency', 0.08, ...
            'y_offset', 3.0);
        h_ref_signal = signalGenerator('amplitude', 0.0, 'frequency', 0.0, ...
            'y_offset', P.h0);
        ref_z_type = 'square';
        ref_h_type = 'step';
        sim_t_end = P.t_end;

    otherwise
        error('Unknown mode. Use ''a'', ''e'', or ''f''.');
end

% Instantiate plots and animation
dataPlot = vtolDataPlotter();
animation = vtolAnimation();

t = P.t_start;
u = [P.Fe/2; P.Fe/2];
u_max = 0.0;

while t < sim_t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        switch ref_z_type
            case 'square'
                zr = z_ref_signal.square(t);
            case 'step'
                zr = z_ref_signal.step(t);
        end

        switch ref_h_type
            case 'step'
                hr = h_ref_signal.step(t);
            otherwise
                hr = P.h0;
        end

        x = vtol.state;
        u = controller.update(zr, hr, x);
        vtol.update(u);

        u_max = max(u_max, max(abs(u)));
        t = t + P.Ts;
    end

    animation.update(vtol.state, zr);
    dataPlot.update(t, vtol.state, u, zr, hr);
    pause(0.0001);
end

fprintf('Maximum rotor force magnitude = %f N\n', u_max);

disp('Press any key to close');
waitforbuttonpress;
close all;