function c_endmsg_locked(hwnd, bMsgLock, font_color_instruction, font_size_instruction, wrap_chars_instruction, text_instruction, show_diode_square, diodesize)

scrW = evalin('base', 'scrW');
scrH = evalin('base', 'scrH');
key_esc = evalin('base', 'key_esc');
key_space = evalin('base', 'key_space');

rec_text_instruction = [scrW/4, 0, 3*scrW/4, scrH];

if (bMsgLock == 1)
    disp('<strong>Press space + esc to quit</strong>');
end

bRunning = 1;
while (bRunning)
    
    [keyDown, keySec, keyCode] = KbCheck(-1);
    if (keyDown)
        if (keyCode(key_esc) && keyCode(key_space))
            bRunning = 0;
        end
    end
    
    if (show_diode_square == 1)
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
    end
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_instruction, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_instruction);
    
    Screen('Flip', hwnd);
    
    if (bMsgLock == 0)
        break;
    end
end


