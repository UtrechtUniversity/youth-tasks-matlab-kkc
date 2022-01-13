
answer = -1;
time0 = GetSecs;
time1 = time0;
while ((answer == -1) && ((time1-time0) < 15))
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    time1 = GetSecs;
    if (keyDown)
        if (keyCode(key_1))
            answer = 1;
        elseif (keyCode(key_0))
            answer = 0;
        end
    end
end

