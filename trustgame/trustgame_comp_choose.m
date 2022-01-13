

rec_text_title = [scrW/4, 0, 3*scrW/4, rec_choice_brd(2)]; %scrH/4];

rec_text_cont = [scrW/4, rec_choice_brd(4), 3*scrW/4, scrH];

frame_cnt = 0;

%[keyDown, keySec, keyCode] = KbCheck(keyDevice);
bRunning = 1;
while (bRunning) %(~keyDown & bRunning)
    %[keyDown, keySec, keyCode] = KbCheck(keyDevice);
    
    if ((frame_cnt > 240) || (do_choose == 0))
        %if (usemouse == 0)
            [keyDown, keySec, keyCode] = KbCheck(keyDevice);
            if (keyDown)
                if (keyCode(key_space))
                    bRunning = 0;
                end
            end
            
            if ((frame_cnt > 240) || (do_choose == 0))
                Screen('TextFont', hwnd, 'Arial');
                Screen('TextSize', hwnd, font_size_instruction);
                DrawFormattedText(hwnd, 'Druk op spatie om verder te gaan', 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_cont);
            end
%         else
%             [eX, eY, buttons] = GetMouse(scrInd);
%             if ((eX >= rec_btn_ok(1)) && (eX <= rec_btn_ok(3)) && (eY >= rec_btn_ok(2)) && (eY <= rec_btn_ok(4)))
%                 Screen('FillRect', hwnd, gray, rec_btn_ok);
%                 Screen('FrameRect', hwnd, black, rec_btn_ok, 1);
%                 if (buttons(1))
%                     bRunning = 0;
%                 end
%             else
%                 Screen('FillRect', hwnd, lightgray, rec_btn_ok);
%                 Screen('FrameRect', hwnd, gray, rec_btn_ok, 1);
%             end
%             Screen('TextFont', hwnd, 'Arial');
%             Screen('TextSize', hwnd, 14);
%             DrawFormattedText(hwnd, 'OK', 'center', 'center', black, [], [], [], [], [], rec_btn_ok_text);
%         end
    end
    
    Screen('FillRect', hwnd, white, rec_choice_brd);
    if (geslacht == 1)
        Screen('DrawTexture', hwnd, m1_tex, m1_rec, rec_choice1);
        Screen('DrawTexture', hwnd, m2_tex, m2_rec, rec_choice2);
    else
        Screen('DrawTexture', hwnd, v1_tex, v1_rec, rec_choice1);
        Screen('DrawTexture', hwnd, v2_tex, v2_rec, rec_choice2);
    end
    Screen('FrameRect', hwnd, black, rec_choice_brd, 4);
    %if ((frame_cnt > 240) || (do_choose == 0))
    %    Screen('FrameRect', hwnd, yellow, rec_choice2, 4);
    %end
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, 16);
    DrawFormattedText(hwnd, 'Speler 1', 'center', 'center', black, [], [], [], [], [], rec_choice_p1t);
    DrawFormattedText(hwnd, 'Speler 2', 'center', 'center', black, [], [], [], [], [], rec_choice_p2t);
    if ((frame_cnt > 240) || (do_choose == 0))
        DrawFormattedText(hwnd, player1, 'center', 'center', black, [], [], [], [], [], rec_choice_p1b);
        DrawFormattedText(hwnd, player2, 'center', 'center', black, [], [], [], [], [], rec_choice_p2b);
        if (player_choice == 1)
            Screen('FrameRect', hwnd, yellow, rec_choice1, 4);
        else
            Screen('FrameRect', hwnd, yellow, rec_choice2, 4);
        end
    end
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_title, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_title);
    
    Screen('Flip', hwnd);
    
    frame_cnt = frame_cnt + 1;
end


%if (usemouse == 0)
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    while (keyDown)
        [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    end
% else
%     
%     Screen('TextFont', hwnd, 'Arial');
%     Screen('TextSize', hwnd, 14);
%     [eX, eY, buttons] = GetMouse;
%     while (buttons(1))
%         [eX, eY, buttons] = GetMouse;
%         Screen('FillRect', hwnd, lightgray, rec_btn_ok);
%         Screen('FrameRect', hwnd, black, rec_btn_ok, 1);
%         DrawFormattedText(hwnd, 'OK', 'center', 'center', black, [], [], [], [], [], rec_btn_ok_text);
%         Screen('Flip', hwnd);
%     end
% end

for i = 1 : 30
    Screen('Flip', hwnd);
end

% [keyDown, keySec, keyCode] = KbCheck(keyDevice);
% while (find(keyDown))
%     [keyDown, keySec, keyCode] = KbCheck(keyDevice);
% end


