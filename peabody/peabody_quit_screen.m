

[keyDown, keySec, keyCode] = KbCheck(keyDevice);
while (keyDown)
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
end

bQuit = 0;
while (1)
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, 18);
    DrawFormattedText(hwnd, 'Press Q to quit the task or SPACE to continue', 'center', 'center', black, [], [], [], [], [], [0, 0, scrW, scrH]);
    Screen('Flip', hwnd);        
    
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    if (keyDown)
        if (keyCode(key_quit))
            bQuit = 1;
            break;
        elseif (keyCode(key_space))
            bQuit = 0;
            break;
        end
    end
    
end


