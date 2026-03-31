clc;
close all;
clear;

% mode = 'a'; % altitude step test
% mode = 'e'; % square wave
mode = 'f'; % square wave, rotor saturation turned on in controller

P = vtolParams();
vtol = vtolDynamics(0.0);
controller = ch08_vtolPD(mode);

% Reference signals
switch lower(mode)
    case 'a'
        z_ref_signal = signalGenerator('amplitude', 0.0, 'frequency', 0.0, ...
            'y_offset', P.z0);
        h_ref_signal = signalGenerator('amplitude', 1.0, 'frequency', 0.0, ...
            'y_offset', P.h0);
        ref_z_type = 'step';
        ref_h_type = 'step';
        sim_t_end = 60.0;

    case 'e'
        z_ref_signal = signalGenerator('amplitude', 2.5, 'frequency', 0.08, ...
            'y_offset', 3.0);
        h_ref_signal = signalGenerator('amplitude', 0.0, 'frequency', 0.0, ...
            'y_offset', P.h0);
        ref_z_type = 'square';
        ref_h_type = 'step';
        sim_t_end = P.t_end;

    case 'f'
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

fprintf('max rotor force magnitude = %f N\n', u_max);

disp('Press any key to close');
waitforbuttonpress;
close all;