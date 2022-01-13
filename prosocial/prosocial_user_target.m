
%click_player1 = 0;
%click_player2 = 0;
%click_player3 = 0;

cur_target = -1;
cur_sel = -1;
while (cur_target == -1)
    %if (usemouse == 0)
        [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    %else
    %    [eX, eY, buttons] = GetMouse;
    %end    
    time_react = round((GetSecs - time_zero) * 1000);
    
    %Screen('DrawTexture', hwnd, img_tex{cur_player,view_target(cur_player),img_seq(1)}, [0, 0, img1_w, img1_h], draw_rec, 0);
    Screen('DrawTexture', hwnd, img_tex{cur_player,view_target(cur_player),img_seq(1)}, rsrc_img{cur_player,view_target(cur_player),img_seq(1)}, draw_rec, 0);
    
    %if (usemouse == 0)
        if (keyDown)
            if (keyCode(key_1))
                cur_sel = 1;
            end
            if (keyCode(key_2))
                cur_sel = 4;
            end
            if (keyCode(key_3))
                cur_sel = 3;
            end
            cur_target = cur_sel;
        end
    %else
    %    if ((eX >= rec_player1(1)) && (eX <= rec_player1(3)) && (eY >= rec_player1(2)) && (eY <= rec_player1(4)))
    %        cur_sel = 1;
    %        Screen('FrameOval', hwnd , black, rec_sel1 , 1);
    %    end
    %    if ((eX >= rec_player2(1)) && (eX <= rec_player2(3)) && (eY >= rec_player2(2)) && (eY <= rec_player2(4)))
    %        cur_sel = 4;
    %        Screen('FrameOval', hwnd , black, rec_sel2 , 1);
    %    end
    %    if ((eX >= rec_player3(1)) && (eX <= rec_player3(3)) && (eY >= rec_player3(2)) && (eY <= rec_player3(4)))
    %        cur_sel = 3;
    %        Screen('FrameOval', hwnd , black, rec_sel3 , 1);
    %    end
    %    
    %    if (buttons(1))
    %        cur_target = cur_sel;
    %    end
    %end
    
    Screen(hwnd, 'TextSize', 18);
    DrawFormattedText(hwnd, 'Speler 1', 'center', 'center', black, [], 0, 0, [], 0, rec_txt1);
    DrawFormattedText(hwnd, 'Speler 2', 'center', 'center', black, [], 0, 0, [], 0, rec_txt2);
    DrawFormattedText(hwnd, 'Speler 3', 'center', 'center', black, [], 0, 0, [], 0, rec_txt3);
    
    Screen('Flip', hwnd);
end



%             [keyDown, keySec, keyCode] = KbCheck(keyDevice);
%             while (~keyCode(key_1) && ~keyCode(key_2) && ~keyCode(key_3))
%                 [keyDown, keySec, keyCode] = KbCheck(keyDevice);
%             end
%
%             if (keyCode(key_1))
%                 cur_target = 1;
%             elseif (keyCode(key_2))
%                 cur_target = 4;
%             elseif (keyCode(key_3))
%                 cur_target = 3;
%             end


