<<<<<<< HEAD
=======
% Animation of the ball on beam system. 
%   - Inputs: z, theta.

>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
clc;
close all;
clear;


P              = ballbeamParams();
animation = ballbeamAnimation();

t = P.t_start;
while t < P.t_end
<<<<<<< HEAD
    z = 0.25 + 0.15*sin(2*pi*0.05*t);     
    theta = (10*pi/180)*sin(2*pi*0.10*t);   
=======
    % Example animation inputs
    z = 0.25 + 0.15*sin(2*pi*0.05*t);          % m
    theta = (10*pi/180)*sin(2*pi*0.10*t);      % rad
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468

    state = [z; theta; 0; 0];
    animation.update(state);

    t = t + P.t_plot;
    pause(0.01);
end

disp('Press any key to close');
waitforbuttonpress;
close all;