function [bRepeat] = c_instruction(hwnd, scrInd, usemouse, AllowRepeat, rec_btn_ok, rec_btn_ok_text, font_size_instruction, font_color_instruction, wrap_chars_instruction, text_instruction)

scrW = evalin('base', 'scrW');
scrH = evalin('base', 'scrH');

key_space = evalin('base', 'key_space');
key_repeat = evalin('base', 'key_repeat');

black = evalin('base', 'black');
lightgray = evalin('base', 'lightgray');
gray = evalin('base', 'gray');

rec_text_instruction = [scrW/4, 0, 3*scrW/4, scrH];


%[keyDown, keySec, keyCode] = KbCheck(-1);
bRunning = 1;
bRepeat = 0;
while (bRunning) %(~keyDown & bRunning)
    %[keyDown, keySec, keyCode] = KbCheck(-1);
    
    if (usemouse == 0)
        [keyDown, keySec, keyCode] = KbCheck(-1);
        if (keyDown)
            if (keyCode(key_space))
                bRunning = 0;
            end
            if (AllowRepeat)
                if (keyCode(key_repeat))
                    bRunning = 0;
                    bRepeat = 1;
                end
            end
        end
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
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_instruction, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_instruction);
    
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


