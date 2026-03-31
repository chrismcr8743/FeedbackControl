this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch06_armLin.m'));

syms s
I = sym(eye(size(A_lin, 1)));

C = sym([1 0]);
D = sym(0);

% transfer function H(s)
H = simplify(C * inv(s*I - A_lin) * B_lin + D);
H = simplify(H(1));

disp('Transfer function H(s) =')
pretty(H)

[num, den] = numden(H);
expanded_den = expand(den);

den_coeffs = coeffs(expanded_den, s, 'All');
highest_order_term = den_coeffs(1);

num_monic = simplify(num / highest_order_term);
den_monic = collect(simplify(expanded_den / highest_order_term), s);

disp(' ')
disp('Monic transfer function numerator =')
pretty(num_monic)

disp('Monic transfer function denominator =')
pretty(den_monic)