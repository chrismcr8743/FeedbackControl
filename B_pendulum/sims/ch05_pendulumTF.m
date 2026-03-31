<<<<<<< HEAD
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch06_pendulumLin.m'));

syms s
I = sym(eye(size(A_lin, 1)));

=======
%% ch05_pendulumTF
% MATLAB version of hw05_pendulum_transfer_function.py

this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch06_pendulumLin.m'));

% define s as symbolic Laplace variable
syms s
I = sym(eye(size(A_lin, 1)));

% define C and D
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
C = sym([1 0 0 0;
         0 1 0 0]);

D = sym([0;
         0]);

% calculate H(s)
<<<<<<< HEAD
=======
% using backslash instead of inv gives cleaner symbolic expressions
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
H = simplify(C * ((s*I - A_lin) \ B_lin) + D);

disp('H(s) symbolic =')
pretty(H)

<<<<<<< HEAD
% substitute numerical values 
=======
% substitute numerical values like the Python script
>>>>>>> bd8cd1f9744e740fe816fdff748360dcfde2e468
H_num = simplify(subs(H, ...
    {m1, m2, ell, b, g}, ...
    {0.25, 1, 1, 0.0, 9.8}));

disp(' ')
disp('H(s) with m1=0.25, m2=1, ell=1, b=0, g=9.8 =')
pretty(H_num)

<<<<<<< HEAD
=======
% monic form for each transfer function entry
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