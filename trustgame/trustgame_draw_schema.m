
lw = 6;

Screen('DrawLine', hwnd, color_line_p1_n1, line_p1_n1(1), line_p1_n1(2), line_p1_n1(3), line_p1_n1(4), lw);
Screen('DrawLine', hwnd, color_line_p1_n1, line_n1(1), line_n1(2), line_n1(3), line_n1(4), lw);
Screen('DrawLine', hwnd, color_line_p1_n1, line_n1_n1a(1), line_n1_n1a(2), line_n1_n1a(3), line_n1_n1a(4), lw);
Screen('DrawLine', hwnd, color_line_p1_n1, line_n1_n1b(1), line_n1_n1b(2), line_n1_n1b(3), line_n1_n1b(4), lw);

Screen('DrawLine', hwnd, color_line_p1_p2, line_p1_p2(1), line_p1_p2(2), line_p1_p2(3), line_p1_p2(4), lw);

if (hide_p2_choices == 0)
    Screen('DrawLine', hwnd, color_line_p2_t1, line_p2_t1(1), line_p2_t1(2), line_p2_t1(3), line_p2_t1(4), lw);
    Screen('DrawLine', hwnd, color_line_p2_t1, line_t1(1), line_t1(2), line_t1(3), line_t1(4), lw);
    Screen('DrawLine', hwnd, color_line_p2_t1, line_t1_t1a(1), line_t1_t1a(2), line_t1_t1a(3), line_t1_t1a(4), lw);
    Screen('DrawLine', hwnd, color_line_p2_t1, line_t1_t1b(1), line_t1_t1b(2), line_t1_t1b(3), line_t1_t1b(4), lw);
    
    Screen('DrawLine', hwnd, color_line_p2_t2, line_p2_t2(1), line_p2_t2(2), line_p2_t2(3), line_p2_t2(4), lw);
    Screen('DrawLine', hwnd, color_line_p2_t2, line_t2(1), line_t2(2), line_t2(3), line_t2(4), lw);
    Screen('DrawLine', hwnd, color_line_p2_t2, line_t2_t2a(1), line_t2_t2a(2), line_t2_t2a(3), line_t2_t2a(4), lw);
    Screen('DrawLine', hwnd, color_line_p2_t2, line_t2_t2b(1), line_t2_t2b(2), line_t2_t2b(3), line_t2_t2b(4), lw);
end

Screen('FillRect', hwnd, white, rec_p1, 1);
Screen('FillRect', hwnd, white, rec_n1a, 1);
Screen('FillRect', hwnd, white, rec_n1b, 1);
Screen('FillRect', hwnd, white, rec_p2, 1);
if (hide_p2_choices == 0)
    Screen('FillRect', hwnd, white, rec_t1a, 1);
    Screen('FillRect', hwnd, white, rec_t1b, 1);
    Screen('FillRect', hwnd, white, rec_t2a, 1);
    Screen('FillRect', hwnd, white, rec_t2b, 1);
end

Screen('FrameRect', hwnd, color_rec_p1, rec_p1, lw);
Screen('FrameRect', hwnd, color_rec_n1a, rec_n1a, lw);
Screen('FrameRect', hwnd, color_rec_n1b, rec_n1b, lw);
Screen('FrameRect', hwnd, color_rec_p2, rec_p2, lw);
if (hide_p2_choices == 0)
    Screen('FrameRect', hwnd, color_rec_t1a, rec_t1a, lw);
    Screen('FrameRect', hwnd, color_rec_t1b, rec_t1b, lw);
    Screen('FrameRect', hwnd, color_rec_t2a, rec_t2a, lw);
    Screen('FrameRect', hwnd, color_rec_t2b, rec_t2b, lw);
end

DrawFormattedText(hwnd, player1, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_p1);
DrawFormattedText(hwnd, player1, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_n1a);
DrawFormattedText(hwnd, player2, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_n1b);
DrawFormattedText(hwnd, player2, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_p2);
if (hide_p2_choices == 0)
    DrawFormattedText(hwnd, player1, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_t1a);
    DrawFormattedText(hwnd, player2, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_t1b);
    DrawFormattedText(hwnd, player1, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_t2a);
    DrawFormattedText(hwnd, player2, 'center', 'center', txt_clr, [], 0, 0, [], 0, rec_t2b);
end

%if (usemouse == 0)
    if (showP1_input == 1) %((AllowPlayer1 == 1) && ((state == 0) || (state == 1)))
        DrawFormattedText(hwnd, '1', 'center', 'center', white, [], 0, 0, [], 0, rec_ch_p1_0);
        DrawFormattedText(hwnd, '0', 'center', 'center', white, [], 0, 0, [], 0, rec_ch_p1_1);
    end
    if (hide_p2_choices == 0)
        if (showP2_input == 1) %((AllowPlayer1 == 0) && (state == 2))
            DrawFormattedText(hwnd, '1', 'center', 'center', white, [], 0, 0, [], 0, rec_ch_p2_0);
            DrawFormattedText(hwnd, '0', 'center', 'center', white, [], 0, 0, [], 0, rec_ch_p2_1);
        end
    end
%end

for i = 1 : coin_count(trial,1)
    [x, y] = coin_pos(i);
    Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_n1a(1)+coin_size*x, coin_pos_n1a(2)+coin_size*y, coin_pos_n1a(1)+20*(x+1), coin_pos_n1a(2)+20*(y+1)]);
end
%n = randi(20);
for i = 1 : coin_count(trial,2)
    [x, y] = coin_pos(i);
    Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_n1b(1)+coin_size*x, coin_pos_n1b(2)+coin_size*y, coin_pos_n1b(1)+20*(x+1), coin_pos_n1b(2)+20*(y+1)]);
end
if (cur_draw_coins_total_p1 > 0)
    for i = 1 : draw_coins_total_p1
        [x, y] = coin_pos(i);
        Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_p1(1)+coin_size*x, coin_pos_p1(2)+coin_size*y, coin_pos_p1(1)+20*(x+1), coin_pos_p1(2)+20*(y+1)]);
    end
end
if (cur_draw_coins_total_p2 > 0)
    for i = 1 : draw_coins_total_p2
        [x, y] = coin_pos(i);
        Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_p2(1)+coin_size*x, coin_pos_p2(2)+coin_size*y, coin_pos_p2(1)+20*(x+1), coin_pos_p2(2)+20*(y+1)]);
    end
end

%if (state > 0)
if (hide_p2_choices == 0)
    %n = randi(20);
    for i = 1 : coin_count(trial,3)
        [x, y] = coin_pos(i);
        Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_t1a(1)+coin_size*x, coin_pos_t1a(2)+coin_size*y, coin_pos_t1a(1)+20*(x+1), coin_pos_t1a(2)+20*(y+1)]);
    end
    %n = randi(20);
    for i = 1 : coin_count(trial,4)
        [x, y] = coin_pos(i);
        Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_t1b(1)+coin_size*x, coin_pos_t1b(2)+coin_size*y, coin_pos_t1b(1)+20*(x+1), coin_pos_t1b(2)+20*(y+1)]);
    end
    
    %n = randi(20);
    for i = 1 : coin_count(trial,5)
        [x, y] = coin_pos(i);
        Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_t2a(1)+coin_size*x, coin_pos_t2a(2)+coin_size*y, coin_pos_t2a(1)+20*(x+1), coin_pos_t2a(2)+20*(y+1)]);
    end
    %n = randi(20);
    for i = 1 : coin_count(trial,6)
        [x, y] = coin_pos(i);
        Screen('DrawTexture', hwnd, coin_tex, coin_rec, [coin_pos_t2b(1)+coin_size*x, coin_pos_t2b(2)+coin_size*y, coin_pos_t2b(1)+20*(x+1), coin_pos_t2b(2)+20*(y+1)]);
    end
end

if (selNT == 1)
    Screen('FrameRect', hwnd, color_rec_selnt, rec_nt, lw);
end
if (hide_p2_choices == 0)
    if (selT1 == 1)
        Screen('FrameRect', hwnd, color_rec_selt1, rec_t1, lw);
    end
    if (selT2 == 1)
        Screen('FrameRect', hwnd, color_rec_selt2, rec_t2, lw);
    end
end

%Screen('Flip', hwnd);


