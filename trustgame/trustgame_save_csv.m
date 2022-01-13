

disp('Saving to csv file...')

M = [mf_log.pract_trials, mf_log.pract_coin_count, mf_log.pract_params; mf_log.task_trials, mf_log.task_coin_count, mf_log.task_params];

lbl = cell(1,14);
j=0;
j=j+1; lbl{j} = 'block';
j=j+1; lbl{j} = 'player';
j=j+1; lbl{j} = 'trial';
j=j+1; lbl{j} = 'answer';
j=j+1; lbl{j} = 'reaction time';
j=j+1; lbl{j} = 'Coin P1 T1 option1';
j=j+1; lbl{j} = 'Coin P2 T1 option1';
j=j+1; lbl{j} = 'Coin P1 T2 option1';
j=j+1; lbl{j} = 'Coin P2 T2 option1';
j=j+1; lbl{j} = 'Coin P1 T2 option0';
j=j+1; lbl{j} = 'Coin P2 T2 option0';
j=j+1; lbl{j} = 'trial type';
j=j+1; lbl{j} = 'comp choice';
j=j+1; lbl{j} = 'jitter';

csvfile = [logpath logtag '.csv'];
write_csv(csvfile, lbl, M);

disp('Saved')

