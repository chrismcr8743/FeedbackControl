% Transfer functions for the satellite system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch06_satelliteLin.m'));

% Laplace variable
syms s
I = sym(eye(size(A_lin, 1)));


% Output 1- theta, output 2- phi
C = sym([1 0 0 0;
         0 1 0 0]);

D = sym([0;
         0]);

% Transfer function matrix H(s)
H = simplify(C * ((s*I - A_lin) \ B_lin) + D);
disp('H(s) symbolic =')
pretty(H)

<<<<<<< HEAD
% Substitute numerical values 
=======
% Substitute numerical values from satelliteParams
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
Pnum = satelliteParams();
H_num = simplify(subs(H, ...
    {Js, Jp, k, b}, ...
    {Pnum.Js, Pnum.Jp, Pnum.k, Pnum.b}));

disp(' ')
disp('H(s) with numeric parameters =')
pretty(H_num)

<<<<<<< HEAD
=======
% Monic form for each transfer function entry
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
for i = 1:length(H_num)
    Hi = simplify(H_num(i));

    [num, den] = numden(Hi);
    expanded_den = expand(den);

    den_coeffs = coeffs(expanded_den, s, 'All');
    highest_order_term = den_coeffs(1);

    num_monic = simplify(num / highest_order_term);
    den_monic = collect(simplify(expanded_den / highest_order_term), s);

    Hi_monic = simplify(num_monic / den_monic);

    disp(' ')
    fprintf('Output %d monic transfer function:\n', i)
    pretty(Hi_monic)
end