% Transfer functions for VTOL system
this_dir = fileparts(mfilename('fullpath'));
run(fullfile(this_dir, 'ch06_vtolLin.m'));

syms s
I = sym(eye(size(A_lin, 1)));

% Outputs: zv, h, theta
C = sym([1 0 0 0 0 0;
               0 1 0 0 0 0;
               0 0 1 0 0 0]);

D = sym(zeros(3,2));

% Transfer function matrix
H = simplify(C * ((s*I - A_lin) \ B_lin) + D);

disp('H(s) symbolic =')
pretty(H)

% Numeric substitution using vtolParams
vtol_dir = fileparts(this_dir);
addpath(vtol_dir);

Pnum = vtolParams();

H_num = simplify(subs(H, ...
    {mc, mr, ml, Jc, d, mu, g, ze, he}, ...
    {Pnum.mc, Pnum.mr, Pnum.ml, Pnum.Jc, Pnum.d, Pnum.mu, Pnum.g, 0, 0}));

disp(' ')
disp('H(s) with numeric parameters =')
pretty(H_num)

% Monic form for each entry
[nr, nc] = size(H_num);
for r = 1:nr
    for c = 1:nc
        Hij = simplify(H_num(r,c));

        disp(' ')
        fprintf('Entry H(%d,%d):\n', r, c)

        if isequal(Hij, sym(0))
            disp('0')
        else
            [num, den] = numden(Hij);
            expanded_den = expand(den);

            den_coeffs = coeffs(expanded_den, s, 'All');
            highest_order_term = den_coeffs(1);

            num_monic = simplify(num / highest_order_term);
            den_monic = collect(simplify(expanded_den / highest_order_term), s);

            Hij_monic = simplify(num_monic / den_monic);
            pretty(Hij_monic)
        end
    end
end