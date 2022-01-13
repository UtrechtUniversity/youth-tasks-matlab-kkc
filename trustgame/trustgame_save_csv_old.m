

disp('Saving to csv file...')

csv_failed = 0;


%if (exist('condition') == 0)
%    csv_failed = 1;
%else
%    curcond = mf_log.condition;
%end

tmp_trials_o1 = mf_log.trials_o1;
tmp_trials_o2 = mf_log.trials_o2;
tmp_trials_p1 = mf_log.trials_p1;
tmp_trials_p2 = mf_log.trials_p2;

s_trials_o1 = size(tmp_trials_o1);
s_trials_o2 = size(tmp_trials_o2);
s_trials_p1 = size(tmp_trials_p1);
s_trials_p2 = size(tmp_trials_p2);

if ((s_trials_o1(1) ~= 3) || (s_trials_o2(1) ~= 2) || (s_trials_p1(1) ~= 24) || (s_trials_p2(1) ~= 24))
    csv_failed = 1;
else
    
    tmp_trials_o1(1:3,1:5) = [tmp_trials_o1(:,1) (1*ones(1,3))' tmp_trials_o1(:,2:4)];
    
    tmp_trials_o1(1,6:11) = mf_log.oefen1_coin_count(tmp_trials_o1(1,2),:);
    tmp_trials_o1(2,6:11) = mf_log.oefen1_coin_count(tmp_trials_o1(2,2),:);
    tmp_trials_o1(3,6:11) = mf_log.oefen1b_coin_count;
    
    tmp_trials_o1(1,12:14) = mf_log.oefen1_params(tmp_trials_o1(1,2),:);
    tmp_trials_o1(2,12:14) = mf_log.oefen1_params(tmp_trials_o1(2,2),:);
    tmp_trials_o1(3,12:14) = mf_log.oefen1b_params;
    
    tmp_trials_o2(1:2,1:5) = [tmp_trials_o2(1:2,1) (2*ones(1,2))' tmp_trials_o2(1:2,2:4)];
    
    tmp_trials_o2(1,6:11) = mf_log.oefen2_coin_count(tmp_trials_o2(1,2),:);
    tmp_trials_o2(2,6:11) = mf_log.oefen2_coin_count(tmp_trials_o2(2,2),:);
    
    tmp_trials_o2(1,12:14) = mf_log.oefen2_params(tmp_trials_o2(1,2),:);
    tmp_trials_o2(2,12:14) = mf_log.oefen2_params(tmp_trials_o2(2,2),:);
    
    cond1 = 1 * ones(1, length(tmp_trials_p1));
    %trials_p1(:,5) = cond1;
    tmp_trials_p1(:,1:5) = [tmp_trials_p1(:,1) cond1' tmp_trials_p1(:,2:4)];
    for i = 1 : length(tmp_trials_p1)
        %cond = 1 * ones(1, length(trials_p1));
        tmp_trials_p1(i,6:11) = mf_log.block2_coin_count(tmp_trials_p1(i,3),:);
        tmp_trials_p1(i,12:14) = mf_log.block2_params(tmp_trials_p1(i,3),:);
    end
    
    cond2 = 2 * ones(1, length(tmp_trials_p2));
    %trials_p2(:,5) = cond2;
    tmp_trials_p2(:,1:5) = [tmp_trials_p2(:,1) cond2' tmp_trials_p2(:,2:4)];
    for i = 1 : length(tmp_trials_p2)
        tmp_trials_p2(i,6:11) = mf_log.block1_coin_count(tmp_trials_p2(i,3),:);
        tmp_trials_p2(i,12:14) = mf_log.block1_params(tmp_trials_p2(i,3),:);
        if (tmp_trials_p2(i,13) == 1) %notrust
            tmp_trials_p2(i,4) = -1;
        end
    end
    
    if (mf_log.condition == 1)
        M = [tmp_trials_o1; tmp_trials_o2; tmp_trials_p1; tmp_trials_p2];
    else
        M = [tmp_trials_o1; tmp_trials_o2; tmp_trials_p2; tmp_trials_p1];
    end
    
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
    
end

if (csv_failed == 1)
    disp('<strong>ERROR: saving to csv failed</strong>')
else
    disp('Saved')
end

