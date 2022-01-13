function [amount] = MakeRandomAmount(OLL, OUL, step)

V = rand() * (OUL - OLL - 2 * step);
R = floor(V / step) * step;
amount = OLL + step + R;
