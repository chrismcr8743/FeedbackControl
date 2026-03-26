clc;
close all;
clear;

P              = massParams();
z_signal   = signalGenerator('amplitude', 2.0, 'frequency', 0.05, 'y_offset', 2.5);
animation = massAnimation();

t = P.t_start;
while t < P.t_end
    z = z_signal.sin(t);  
    animation.update([z]);
    t = t + P.t_plot;
    pause(0.01);
end

disp('Press any key to close');
waitforbuttonpress;
close all;