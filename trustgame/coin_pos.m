function [x, y] = coin_pos(n)

%--- groups of 5 ---
% g = floor((n-1)/5);
% r = mod(n,5);
% 
% if (r == 0)
%     x = 2*g + 0.5;
%     y = 0.5;
% else
%     x = 2*g + 1-mod(r,2);
%     y = floor((r-1)/2);
% end
    
%--- groups of 2 ---
x = floor((n-1) / 2);
y = mod(n-1, 2);


