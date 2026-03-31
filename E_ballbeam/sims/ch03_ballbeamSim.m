<<<<<<< HEAD
=======
% Ballbeam dynamics with a variable force input
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
clc;
close all;
clear;

P              = ballbeamParams();
ballbeam  = ballbeamDynamics(0.0);
force         = signalGenerator('amplitude', 2.0, 'frequency', 0.05, 'y_offset', P.Fe);
animation = ballbeamAnimation();
dataPlot   = ballbeamDataPlotter();

t = P.t_start;
while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        u = force.sin(t);
<<<<<<< HEAD
        y = ballbeam.update(u); 
=======
        y = ballbeam.update(u); %#ok<NASGU>
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
        t = t + P.Ts;
    end

    animation.update(ballbeam.state);
    dataPlot.update(t, ballbeam.state, u);
    pause(0.0001);
end

disp('Press any key to close');
waitforbuttonpress;
close all;