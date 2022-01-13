

new_target = -1;
cur_sel = -1;

[keyDown, keySec, keyCode] = KbCheck(keyDevice);
time_react = round((GetSecs - time_zero) * 1000);

if (keyDown)
    if (keyCode(key_1))
        cur_sel = 1;
    end
    if (keyCode(key_2))
        cur_sel = 4;
    end
    if (keyCode(key_3))
        cur_sel = 3;
    end
    new_target = cur_sel;
end

