

if (exist('usemouse', 'var') == 0)
    usemouse = 0;
end

rec_text_title = [scrW/4, 0, 3*scrW/4, rec_title_img(2)];

rec_text_cont = [scrW/4, rec_title_img(4), 3*scrW/4, scrH];

%[keyDown, keySec, keyCode] = KbCheck(-1);
bRunning = 1;
while (bRunning) %(~keyDown & bRunning)
    
    
    if (usemouse == 0)
        [keyDown, keySec, keyCode] = KbCheck(-1);
        if (keyDown)
            if (keyCode(key_space))
                bRunning = 0;
            end
        end
        
        Screen('TextFont', hwnd, 'Arial');
        Screen('TextSize', hwnd, font_size_instruction);
        DrawFormattedText(hwnd, 'Druk op spatie om verder te gaan', 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_cont);
    else
        [eX, eY, buttons] = GetMouse(scrInd);
        
        if ((eX >= rec_btn_ok(1)) && (eX <= rec_btn_ok(3)) && (eY >= rec_btn_ok(2)) && (eY <= rec_btn_ok(4)))
            Screen('FillRect', hwnd, gray, rec_btn_ok);
            Screen('FrameRect', hwnd, black, rec_btn_ok, 1);
            if (buttons(1))
                bRunning = 0;
            end
        else
            Screen('FillRect', hwnd, lightgray, rec_btn_ok);
            Screen('FrameRect', hwnd, gray, rec_btn_ok, 1);
        end
        Screen('TextFont', hwnd, 'Arial');
        Screen('TextSize', hwnd, 14);
        DrawFormattedText(hwnd, 'OK', 'center', 'center', black, [], [], [], [], [], rec_btn_ok_text);
    end
    
    Screen('DrawTexture', hwnd, title_tex, title_rec, rec_title_img);
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_title, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_title);
    
    Screen('Flip', hwnd);
end

if (usemouse == 0)
    [keyDown, keySec, keyCode] = KbCheck(-1);
    while (find(keyDown))
         [keyDown, keySec, keyCode] = KbCheck(-1);
    end
else
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, 14);
    [eX, eY, buttons] = GetMouse;
    while (buttons(1))
        [eX, eY, buttons] = GetMouse;
        Screen('FillRect', hwnd, lightgray, rec_btn_ok);
        Screen('FrameRect', hwnd, black, rec_btn_ok, 1);
        DrawFormattedText(hwnd, 'OK', 'center', 'center', black, [], [], [], [], [], rec_btn_ok_text);
        Screen('Flip', hwnd);
    end
end

for i = 1 : 30
    Screen('Flip', hwnd);
end

% [keyDown, keySec, keyCode] = KbCheck(-1);
% while (find(keyDown))
%     [keyDown, keySec, keyCode] = KbCheck(-1);
% end


