clc;
close all;
clear;

P = vtolParams();
vtol = vtolDynamics(0.2); % 20% uncertainty
controller = ch10_vtolPID();

z_reference = signalGenerator('amplitude', 2.5, 'frequency', 0.08, 'y_offset', 3.0);
h_reference = signalGenerator('amplitude', 0.0, 'frequency', 0.0, 'y_offset', P.h0);

dataPlot = vtolDataPlotter();
animation = vtolAnimation();

t = P.t_start;
y = vtol.h();
u = [P.Fe/2; P.Fe/2];


while t < P.t_end
    t_next_plot = t + P.t_plot;

    while t < t_next_plot
        zr = z_reference.square(t);
        hr = h_reference.step(t);

        u = controller.update(zr, hr, y);
        y = vtol.update(u);

        t = t + P.Ts;

    end

    animation.update(vtol.state, zr);
    dataPlot.update(t, vtol.state, u, zr, hr);
    pause(0.0001);
end


disp('Press any key to close');
waitforbuttonpress;
close all;

