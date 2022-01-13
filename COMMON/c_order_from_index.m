function [order] = c_order_from_index(ind, N)

%total combinations = N! = N * (N-1) * (N-2) * ... * 1

order = zeros(1, N);
V = ind;
left = 1 : N;
for i = 1 : N
    M = length(left);
    C = mod(V, M);
    V = floor(V / M);
    order(i) = left(C+1);
    left(C+1) = [];
end

