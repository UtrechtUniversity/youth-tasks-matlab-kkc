
log_file = [logpath logtag '_' num2str(task) '.mat'];
mf_log = matfile(log_file, 'Writable', true);
mf_log.order = order;
mf_log.rep_cnt = rep_cnt;
mf_log.seq = seq;
mf_log.comb = comb;
mf_log.cond_val_female = cond_val_female;
mf_log.cond_val_male = cond_val_male;
mf_log.cond_val_house = cond_val_house;
mf_log.cond_val_happy = cond_val_happy;
mf_log.cond_val_fear = cond_val_fear;
mf_log.ISI = ISI;



all_trials = [order'; rep_cnt'; seq'];

filesave = [logpath logtag '_' num2str(task) '.csv'];

lbl = cell(1,3);
j=0;
j=j+1; lbl{j} = 'order';
j=j+1; lbl{j} = 'rep_cnt';
j=j+1; lbl{j} = 'seq';
%j=j+1; lbl{j} = 'comb';
%j=j+1; lbl{j} = 'cond_val_female';
%j=j+1; lbl{j} = 'cond_val_male';
%j=j+1; lbl{j} = 'cond_val_house';
%j=j+1; lbl{j} = 'cond_val_happy';
%j=j+1; lbl{j} = 'cond_val_fear';

header_string = lbl{1};
for i = 2:length(lbl)
    header_string = [header_string,',',lbl{i}];
end

fid = fopen(filesave,'w');
fprintf(fid,'%s\r\n',header_string);
fclose(fid);
dlmwrite(filesave, all_trials, '-append', 'delimiter', ',', 'newline', 'pc');


