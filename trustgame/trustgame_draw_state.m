
trustgame_trial_reset;

if (always_show_input == 1)
    if (isplayer == 1)
        showP1_input = 1;
    end
    if (isplayer == 2)
        showP2_input = 1;
    end
end

switch (state)
    case state_none
        showP1_input = 0;
        showP2_input = 0;
        
    case state_both_inputs
        showP1_input = 1;
        showP2_input = 1;
        
    case state_player1_input
        color_rec_p1 = yellow;
        if (isplayer == 1)
            showP1_input = 1;
        end
        
    case state_player2_input
        color_rec_p1 = yellow;
        color_line_p1_p2 = yellow;
        color_rec_p2 = yellow;
        if (isplayer == 2)
            showP2_input = 1;
        end
        
    case state_player1_notrust
        color_rec_p1 = yellow;
        color_line_p1_n1 = yellow;
        color_rec_selnt = yellow;
        selNT = 1;

    case state_player2_trust
        color_rec_p1 = yellow;
        color_line_p1_p2 = yellow;
        color_rec_p2 = yellow;
        color_line_p2_t2 = yellow;
        color_rec_selt2 = yellow;
        selT2 = 1;
        
    case state_player2_notrust
        color_rec_p1 = yellow;
        color_line_p1_p2 = yellow;
        color_rec_p2 = yellow;
        color_line_p2_t1 = yellow;
        color_rec_selt1 = yellow;
        selT1 = 1;
        
end
