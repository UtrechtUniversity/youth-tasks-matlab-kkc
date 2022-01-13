function c_endmsg_locked(hwnd, bMsgLock, font_color_instruction, font_size_instruction, wrap_chars_instruction, text_instruction, show_diode_square, diodesize)

scrW = evalin('base', 'scrW');
scrH = evalin('base', 'scrH');
fps = evalin('base', 'fps');
key_esc = evalin('base', 'key_esc');
key_space = evalin('base', 'key_space');
tex_end = evalin('base', 'tex_end');
rsrc_end = evalin('base', 'rsrc_end');

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
    
    Screen('DrawTexture', hwnd, tex_end, rsrc_end, [0 0 scrW scrH]);
    
    Screen('Flip', hwnd);
    
    if (bMsgLock == 0)
        break;
    end
end


