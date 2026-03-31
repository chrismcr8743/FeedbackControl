% Transfer functions for ballbeam system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch06_ballbeamLin.m'));

syms s
I = sym(eye(size(A_lin, 1)));

% Outputs- z and theta
C = sym([1 0 0 0;
         0 1 0 0]);

D = sym([0;
         0]);

% Transfer function matrix
H = simplify(C * ((s*I - A_lin) \ B_lin) + D);

disp('H(s) symbolic =')
pretty(H)

beam_dir = fileparts(this_dir);
addpath(beam_dir);

Pnum = ballbeamParams();

H_num = simplify(subs(H, ...
    {m1, m2, ell, g, ze}, ...
    {Pnum.m1, Pnum.m2, Pnum.length, Pnum.g, Pnum.length/2}));

disp(' ')
disp('H(s) with numeric parameters at ze = ell/2 =')
pretty(H_num)

% Monic form for each output
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