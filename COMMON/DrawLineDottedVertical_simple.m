function DrawLineDottedVertical_simple(hwnd, x, y1, y2, col, linew)
pos_from = [x y1];
pos_to = [x y2];

len = (pos_to(2) - pos_from(2));
dir = sign(len);
len = abs(len);
cnt = floor(len / 10);
V = pos_from(2) : dir*10 : pos_from(2)+dir*cnt*10;
V = [pos_from(1)*ones(1, length(V)); V];

Screen('DrawDots', hwnd, V, linew, col, [], 0);

