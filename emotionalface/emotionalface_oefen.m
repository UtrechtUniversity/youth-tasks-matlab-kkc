

practice = 1;

disp('<strong>Press "tab" to start the practice trials</strong>');
c_instruction_image(hwnd, tex_oefen_intro, rsrc_oefen_intro, [0, 0, scrW, scrH], 1, diodesize);

bRunOefen = 1;
while (bRunOefen)
    
    r_oefen_f = randperm(4);
    r_oefen_h = 4+randperm(3);
    order_oefen = [r_oefen_h(1) r_oefen_f(1) r_oefen_h(2) r_oefen_f(2) r_oefen_f(3) r_oefen_h(3)];
    
    for trial_oefen = 1 : length(order_oefen)
        
        cur_ind = order_oefen(trial_oefen);
        
        for h = 1 : ISI_max * fps
            Screen('FillRect', hwnd, backcolor);
            Screen('DrawTexture', hwnd, tex_isi);
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
            Screen('Flip', hwnd);
        end
        
        for h = 1 : stimtime * fps
            Screen('FillRect', hwnd, backcolor);
            Screen('DrawTexture', hwnd, tex_oefen_stim{cur_ind});
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
            Screen('Flip', hwnd);
        end
        
        if ((trial_oefen == 3) || (trial_oefen == 4))
            show_button = 1;
            emotionalface_attvid;
        end
    end
    
    disp('<strong>Press "tab" to start the task, or "p" to repeat the practice trials</strong>');
    [bRunOefen] = c_instruction_image(hwnd, tex_oefen_intro, rsrc_oefen_intro, [0, 0, scrW, scrH], 1, diodesize);
end

