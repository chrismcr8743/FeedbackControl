clc;
close all;
clear;

P = ballbeamParams();
ballbeam = ballbeamDynamics(0.2);
controller = ch10_ballbeamPID();
reference = signalGenerator('amplitude', 0.15, 'frequency', 0.0, 'y_offset', 0.25);
dataPlot = ballbeamDataPlotter();
animation = ballbeamAnimation();

t = P.t_start;
y = ballbeam.h();
u = 0.0;
sim_t_end = 40.0;

% history for ss error
z_hist = [];
r_hist = [];

while t < sim_t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.step(t);
        u = controller.update(r, y);
        y = ballbeam.update(u);
        t = t + P.Ts;

        z_hist(end+1) = y(1);
        r_hist(end+1) = r;
    end

    animation.update(ballbeam.state);
    dataPlot.update(t, ballbeam.state, u, r);
    pause(0.0001);
end

% % final ss error estimate
% e_final = r_hist(end) - z_hist(end);
% fprintf('Final ss error estimate: %f\n', e_final);
% 
% % average over last 100 samples
% N = min(100, length(z_hist));
% e_ss = mean(r_hist(end-N+1:end) - z_hist(end-N+1:end));
% fprintf('avg ss error over last %d samples: %f\n', N, e_ss);

disp('Press any key to close');
waitforbuttonpress;
close all;