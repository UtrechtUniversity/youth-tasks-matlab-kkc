function [bRepeat] = c_instruction_image(hwnd, tex_img, rsrc_img, rdst_img, diode_square, diodesize)

%scrW = evalin('base', 'scrW');
%scrH = evalin('base', 'scrH');

key_continue = KbName('Tab');
key_repeat = evalin('base', 'key_repeat');

bRepeat = 0;
bRunning = 1;
while (bRunning)
    
    [keyDown, keySec, keyCode] = KbCheck(-1);
    if (keyDown)
        if (keyCode(key_continue))
            bRunning = 0;
        end
        if (keyCode(key_repeat))
            bRunning = 0;
            bRepeat = 1;
        end
    end
    
    Screen('DrawTexture', hwnd, tex_img, rsrc_img, rdst_img);
    if (diode_square == 1)
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
    end
    Screen('Flip', hwnd);
end


[keyDown, keySec, keyCode] = KbCheck(-1);
while (find(keyDown))
    [keyDown, keySec, keyCode] = KbCheck(-1);
end




