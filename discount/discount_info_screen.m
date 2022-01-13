function discount_info_screen(hwnd, bMsgLock, imgTex, rsrc_tex, rdst_tex, text_message)

keyDevice = evalin('base', 'keyDevice');
key_esc = evalin('base', 'key_esc');
key_space = evalin('base', 'key_space');

% wait for space press
[keyDown, keySec, keyCode] = KbCheck(keyDevice);
while (~keyCode(key_space) || (~keyCode(key_esc) && (bMsgLock == 1)))

    Screen('DrawTexture', hwnd, imgTex, rsrc_tex, rdst_tex, 0);
    Screen('TextColor', hwnd, 0);
    Screen('TextFont', hwnd, 'Georgia');
    Screen(hwnd, 'TextSize', 24);
    DrawFormattedText(hwnd, text_message, 'center', 'center');
    Screen('Flip', hwnd);

    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    %if (keyCode(key_esc))
    %    fclose(fileID);
    %    %Screen(hwnd, 'Close');
    %    sca
    %    error('Program terminated by user')
    %end
    
    %pause(0.01)
end