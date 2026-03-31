clc;
close all;
clear;

% mode = 'e';  
mode = 'f';    

P = ballbeamParams(); 
ballbeam = ballbeamDynamics(0.0); 
controller = ch08_ballbeamPD(mode); 

% Reference signal
switch lower(mode)
    case 'e'
        reference = signalGenerator('amplitude', 0.15, 'frequency', 0.01, 'y_offset', 0.25);
        ref_type = 'square';
        sim_t_end = 100.0;

    case 'f'
        reference  = signalGenerator('amplitude', 0.25, 'frequency', 0.0, 'y_offset', P.length/2);
        ref_type    = 'step';
        sim_t_end = 20.0;

    otherwise
        error('Unknown mode. Use ''e'' or ''f''.');
end

dataPlot = ballbeamDataPlotter(); 
animation = ballbeamAnimation(); 

t = P.t_start;
u = 0.0;
u_max = 0.0;

while t < sim_t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        switch ref_type
            case 'square'
                r = reference.square(t);
            case 'step'
                r = reference.step(t);
        end

        x = ballbeam.state;
        u = controller.update(r, x);
        ballbeam.update(u);

        u_max = max(u_max, abs(u));
        t = t + P.Ts;
    end

    animation.update(ballbeam.state);
    dataPlot.update(t, ballbeam.state, u, r);
    pause(0.0001);
end

fprintf('max commanded force magnitude = %f N\n', u_max);

disp('Press any key to close');
waitforbuttonpress;
close all;