

rec_text_instruction = [scrW/4, 0, 3*scrW/4, scrH];

bYesNo = 0;

bRunning = 1;
bRepeat = 0;
while (bRunning)
    
    
    [keyDown, keySec, keyCode] = KbCheck(-1);
    if (keyDown)
        if (keyCode(key_yes))
            bRunning = 0;
            bYesNo = 1;
        elseif (keyCode(key_no))
            bRunning = 0;
            bYesNo = 0;
        end
    end
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_instruction, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_instruction);
    
    Screen('Flip', hwnd);
end


[keyDown, keySec, keyCode] = KbCheck(-1);
while (find(keyDown))
    [keyDown, keySec, keyCode] = KbCheck(-1);
end


for i = 1 : 30
    Screen('Flip', hwnd);
end


