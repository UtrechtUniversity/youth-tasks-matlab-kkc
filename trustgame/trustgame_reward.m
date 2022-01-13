


rec_text_title = [scrW/4, 0, 3*scrW/4, rec_choice_brd(2)]; %scrH/4];

rec_text_cont = [scrW/4, rec_choice_brd(4), 3*scrW/4, scrH];

frame_cnt = 0;

bRunning = 1;
while (bRunning)
    
    if (frame_cnt > 600)
        %if (usemouse == 0)
            [keyDown, keySec, keyCode] = KbCheck(keyDevice);
            if (keyDown)
                if (keyCode(key_space))
                    bRunning = 0;
                end
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
    
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    if (frame_cnt > 600)
        DrawFormattedText(hwnd, text_instruction2, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_title);
    else
        DrawFormattedText(hwnd, text_instruction1, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_title);
    end
    
    Screen('Flip', hwnd);
    
    frame_cnt = frame_cnt + 1;
end


bRunning = 1;
while (bRunning)
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    if (keyDown)
        if (keyCode(key_esc) && keyCode(key_space))
            bRunning = 0;
        end
    end
end



% if (usemouse == 0)
%     [keyDown, keySec, keyCode] = KbCheck(keyDevice);
%     while (keyDown)
%         [keyDown, keySec, keyCode] = KbCheck(keyDevice);
%     end
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


