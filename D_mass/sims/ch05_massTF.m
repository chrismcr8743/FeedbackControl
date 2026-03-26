% Transfer function for the msd system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch06_massLin.m'));

% Laplace variable
syms s
I = sym(eye(size(A_lin, 1)));

% output matrices
C = sym([1 0]);
D = sym(0);

% transfer function
H = simplify(C * ((s*I - A_lin) \ B_lin) + D);
H = simplify(H(1));

disp('H(s) symbolic =')
pretty(H)

% substitute numeric values from massParams
Pnum = massParams();
H_num = simplify(subs(H, ...
    {m, b, k}, ...
    {Pnum.m, Pnum.b, Pnum.k}));

disp(' ')
disp('H(s) with numeric parameters =')
pretty(H_num)

% monic form
[num, den] = numden(H_num);
expanded_den = expand(den);

den_coeffs = coeffs(expanded_den, s, 'All');
highest_order_term = den_coeffs(1);

num_monic = simplify(num / highest_order_term);
den_monic = collect(simplify(expanded_den / highest_order_term), s);

H_monic = simplify(num_monic / den_monic);

disp(' ')
disp('Monic transfer function =')
pretty(H_monic)

disp(' ')
disp('Monic numerator =')
pretty(num_monic)

disp('Monic denominator =')
pretty(den_monic)