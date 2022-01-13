
isplayer = 1;
%trustgame_params_player1;

[N_trials, M_trials] = size(coin_count);
trial_order = Shuffle(1 : N_trials);

for trial_ind = 1 : N_trials %length(coin_count)
    trial = trial_order(trial_ind);
    
    player1 = player_name;
    player2 = names{trial};
    
    state = state_none;
    trustgame_draw_state;
    for t = 1 : fps * 2
        trustgame_draw_schema;
        Screen('Flip', hwnd);
    end
    
    state = state_player1_input;
    trustgame_draw_state;
    answer = -1;
    
    trustgame_draw_schema;
    Screen('Flip', hwnd);
    
    answer = -1;
    time0 = GetSecs;
    time1 = time0;
    while ((time1-time0) < 15)
        time1 = GetSecs;
    end
    
    curreact = 0;
    
    for t = 1 : fps * 4
        Screen('TextFont', hwnd, 'Arial');
        Screen('TextSize', hwnd, font_size_instruction);
        DrawFormattedText(hwnd, 'Wacht niet te lang met je keuze', 'center', 'center', font_color_instruction, [], 0, 0, 1.5, 0, []);
        Screen('Flip', hwnd);
    end
    
    if (is_oefen_trial == 1)
        mf_log.pract_coin_count(end+1,1:6) = coin_count(trial,1:6);
        mf_log.pract_params(end+1,1:3) = params(trial,1:3);
        mf_log.pract_names = [mf_log.pract_names names(trial)];
        mf_log.pract_trials(end+1,1:5) = [cur_block, player_choice, trial, answer, curreact];
    end
        
    for t = 1 : fps * 0.3
        Screen('Flip', hwnd);
    end
end


