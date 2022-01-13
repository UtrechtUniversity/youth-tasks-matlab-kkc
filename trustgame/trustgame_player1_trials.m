
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
    %time0 = GetSecs;
    %for t = 1 : fps * 15
        trustgame_draw_schema;
        Screen('Flip', hwnd);
        trustgame_user_input;
        %if (answer ~= -1)
        %    break;
        %end
    %end
    if (answer ~= -1)
        curreact = (time1 - time0) * 1000;
    else
        curreact = 0;
        
        for t = 1 : fps * 4
            Screen('TextFont', hwnd, 'Arial');
            Screen('TextSize', hwnd, font_size_instruction);
            DrawFormattedText(hwnd, 'Wacht niet te lang met je keuze', 'center', 'center', font_color_instruction, [], 0, 0, 1.5, 0, []);
            Screen('Flip', hwnd);
        end
    end
    
    if (answer == 1)
        state = state_player1_notrust;
        trustgame_draw_state;
        for t = 1 : fps * 2
            trustgame_draw_schema;
            Screen('Flip', hwnd);
        end
    elseif (answer == 0)
        state = state_player2_input;
        trustgame_draw_state;
        for t = 1 : fps * params(trial,3) / 1000
            trustgame_draw_schema;
            Screen('Flip', hwnd);
        end
        
        if (params(trial,2) == 0)
            state = state_player2_trust;
        else
            state = state_player2_notrust;
        end
        trustgame_draw_state;
        for t = 1 : fps * 2
            trustgame_draw_schema;
            Screen('Flip', hwnd);
        end
    end
    
    if (is_oefen_trial == 1)
        mf_log.pract_coin_count(end+1,1:6) = coin_count(trial,1:6);
        mf_log.pract_params(end+1,1:3) = params(trial,1:3);
        mf_log.pract_names = [mf_log.pract_names names(trial)];
        mf_log.pract_trials(end+1,1:5) = [cur_block, player_choice, trial, answer, curreact];
    else
        mf_log.task_coin_count(end+1,1:6) = coin_count(trial,1:6);
        mf_log.task_params(end+1,1:3) = params(trial,1:3);
        mf_log.task_names = [mf_log.task_names names(trial)];
        mf_log.task_trials(end+1,1:5) = [cur_block, player_choice, trial, answer, curreact];
    end
        
    for t = 1 : fps * 0.3
        Screen('Flip', hwnd);
    end
end


