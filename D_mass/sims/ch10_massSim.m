clc;
close all;
clear;

P = massParams();

mass = massDynamics(0.2);
controller = ch10_massPID();

reference = signalGenerator('amplitude', 1.0, 'frequency', 0.0);

dataPlot = massDataPlotter();
animation = massAnimation();

t = P.t_start;
y = mass.h();
u = 0.0;

% history for steady state error check
z_hist = [];
r_hist = [];

while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        r = reference.step(t);
        u = controller.update(r, y);
        y = mass.update(u);
        t = t + P.Ts;

        z_hist(end+1) = y(1);
        r_hist(end+1) = r;
    end

    animation.update(mass.state);
    dataPlot.update(t, mass.state, u, r);
    pause(0.0001);
end

% final error
e_final = r_hist(end) - z_hist(end);
fprintf('final ss error: %f\n', e_final);

% average over last 100 samples
N = min(100, length(z_hist));
e_ss = mean(r_hist(end-N+1:end) - z_hist(end-N+1:end));
fprintf('avg ss error over last %d samples: %f\n', N, e_ss);

disp('Press any key to close');
waitforbuttonpress;
close all;