function DrawLineDottedHorizontal_simple(hwnd, x1, x2, y, col, linew)
pos_from = [x1 y];
pos_to = [x2 y];

len = (pos_to(1) - pos_from(1));
dir = sign(len);
len = abs(len);
cnt = floor(len / 10);
V = pos_from(1) : dir*10 : pos_from(1)+dir*cnt*10;
V = [V; pos_from(2)*ones(1, length(V))];

Screen('DrawDots', hwnd, V, linew, col, [], 0);


