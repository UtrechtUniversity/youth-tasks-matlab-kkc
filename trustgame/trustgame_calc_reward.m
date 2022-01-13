function [reward] = trustgame_calc_reward(subject_nr, age_nr)

N = 6;
maxN = factorial(N);
ind = mod(subject_nr, maxN);

j = 1;
seq = zeros(1, N);
choose = 1 : N;
for i = N : -1 : 1
    F = factorial(i - 1);
    x = floor(ind / F);
    ind = ind - x * F;
    seq(j) = choose(x+1);
    choose(x+1) = [];
    j=j+1;
end

vals = [1 2 3; 1 3 2; 2 1 3; 2 3 1; 3 1 2; 3 2 1];

x = mod(age_nr, 18);
y = floor(x / 3) + 1;
z = mod(x, 3) + 1;

v = vals(seq(y), z);

reward = 1.00 + 0.20 * v;


