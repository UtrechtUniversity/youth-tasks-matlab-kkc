
for cur_frame = 1 : 8
    ballpos(1) = ball_x_from(cur_player,cur_target) + (cur_frame-1) * (ball_x_to(cur_player,cur_target) - ball_x_from(cur_player,cur_target)) / 7;
    ballpos(2) = ball_y_from(cur_player,cur_target) + (cur_frame-1) * (ball_y_to(cur_player,cur_target) - ball_y_from(cur_player,cur_target)) / 7;
    ballang = ballang + 20 + randi(60);
    if (ballang >= 360)
        ballang = ballang - 360;
    end
    
    if (cur_frame == 8)
        time_zero = GetSecs;
        new_target = -1;
    end
    
    for frame_step = 1 : 15
        Screen('DrawTexture', hwnd, img_tex{cur_player,cur_target,img_seq(cur_frame)}, rsrc_img{cur_player,cur_target,img_seq(cur_frame)}, draw_rec, 0);
        
        if ((cur_frame > 2) && (cur_frame < 7))
            Screen('glPushMatrix', hwnd);
            Screen('glTranslate', hwnd, ballpos(1)+ball_rec(3)/2, ballpos(2)+ball_rec(4)/2);
            Screen('glRotate', hwnd, ballang, 0, 0);
            Screen('glTranslate', hwnd, -(ballpos(1)+ball_rec(3)/2), -(ballpos(2)+ball_rec(4)/2));
            Screen('DrawTexture', hwnd, ball_tex, rsrc_ball, [ballpos(1), ballpos(2), ballpos(1)+ball_rec(3), ballpos(2)+ball_rec(4)], 0);
            Screen('glPopMatrix', hwnd);
        end
        
        if ((cur_frame == 8) && (cur_target == 2) && (new_target == -1))
            prosocial_input_nodraw;
        end
        
        Screen(hwnd, 'TextSize', 18);
        DrawFormattedText(hwnd, 'Speler 1', 'center', 'center', black, [], 0, 0, [], 0, rec_txt1);
        DrawFormattedText(hwnd, 'Speler 2', 'center', 'center', black, [], 0, 0, [], 0, rec_txt2);
        DrawFormattedText(hwnd, 'Speler 3', 'center', 'center', black, [], 0, 0, [], 0, rec_txt3);
        
        Screen('Flip', hwnd);
    end
end

