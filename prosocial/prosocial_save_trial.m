function prosocial_save_trial(fileID, mf_log, b, i, cur_player, cur_target, time_react)

mf_log.trials(end+1,1:5) = [b, i, cur_player, cur_target, -1];
if (cur_player == 2)
    mf_log.trials(end,5) = time_react;
    mf_log.times(end+1,1:3) = [b, i, time_react];
else
    time_react = -1;
end

fprintf(fileID, '%d,%d,%d,%d,%g\r\n', [b, i, cur_player, cur_target, time_react]);

