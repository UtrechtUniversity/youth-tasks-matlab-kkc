
if ((en_diode == 1) && (practice ~= 1))
    send_code(t_box_handle, 121);
    send_code(t_box_handle, 0);
end

KbQueueFlush(buttonKB);

time0 = GetSecs();

Screen('DrawTexture', hwnd, tex_ball{ball_ind}) %, rsrc_ball{ball_ind}, [0 0 scrW scrH]);
Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
Screen('Flip', hwnd);

ball_ind = ball_ind + 1;
if (ball_ind > n_ball)
    ball_ind = 1;
    ball_order = Shuffle(1:n_ball);
end

react_button = -1;
buttonFound = 0;
while (~buttonFound)
    [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck(buttonKB);
    if (pressed)
        if (find(firstPress) == key_button)
            buttonFound = 1;
            react_button = firstPress(key_button) - time0;
            if ((en_diode == 1) && (practice ~= 1))
                send_code(t_box_handle, 126);
                send_code(t_box_handle, 0);
            end
        end
    end
end

react_times_button(end+1) = react_button;

