if (en_diode == 1)
    for h = 1 : 0.2 * fps
        Screen('FillRect', hwnd, backcolor);
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        Screen('Flip', hwnd);
    end
    
    send_code(t_box_handle, 0);
    send_code(t_box_handle, startstop_code);
    
    for h = 1 : 0.3 * fps
        Screen('FillRect', hwnd, backcolor);
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        Screen('Flip', hwnd);
    end
    
    for h = 1 : 0.3 * fps
        Screen('FillRect', hwnd, backcolor);
        Screen('FillRect', hwnd, [255 255 255], [0 0 diodesize diodesize]);
        Screen('Flip', hwnd);
    end
    
    wait_for_code_back(t_box_handle, time_out_secs, startstop_code);
    send_code(t_box_handle, 0);
    
    for h = 1 : 0.2 * fps
        Screen('FillRect', hwnd, backcolor);
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        Screen('Flip', hwnd);
    end
     
end

