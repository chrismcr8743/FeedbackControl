clc;
close all;
clear;


P              = ballbeamParams();
animation = ballbeamAnimation();

t = P.t_start;
while t < P.t_end
    z = 0.25 + 0.15*sin(2*pi*0.05*t);     
    theta = (10*pi/180)*sin(2*pi*0.10*t);   

    state = [z; theta; 0; 0];
    animation.update(state);

    t = t + P.t_plot;
    pause(0.01);
end

disp('Press any key to close');
waitforbuttonpress;
close all;