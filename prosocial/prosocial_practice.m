


ballang = 0;
cur_jit = 90 * ones(1,7);
view_target = [3, 4, 1, 2];

cur_player = 1;
cur_target = 1;
for i = 1 : 7
    time_zero = GetSecs;
    
    cur_player = cur_target;
    switch i
        case 1
            cur_target = 3;
        case 2
            cur_target = 4;
        case 3
            cur_target = 2;
        case 4
            prosocial_user_target;
        case 5
            cur_target = 2;
        case 6
            prosocial_user_target;
        case 7
            if (cur_player == 1)
                cur_target = 3;
            else
                cur_target = 1;
            end
    end
    
    prosocial_anim;
    prosocial_draw_jitter;
end


