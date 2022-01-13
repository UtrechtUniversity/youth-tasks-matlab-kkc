

rec_text_instruction = [scrW/4, 0, 3*scrW/4, scrH];

bRunning = 1;
bRepeat = 0;
while (bRunning)
    
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    if (keyDown)
        if (keyCode(key_space))
            bRunning = 0;
        end
        if (keyCode(key_repeat))
            bRunning = 0;
            bRepeat = 1;
        end
    end
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_instruction, 'center', 'center', black, wrap_chars_instruction, 0, 0, 2, 0, rec_text_instruction);
    
    Screen('Flip', hwnd);
end

[keyDown, keySec, keyCode] = KbCheck(keyDevice);
while (keyDown)
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
end

for i = 1 : 30
    Screen('Flip', hwnd);
end




