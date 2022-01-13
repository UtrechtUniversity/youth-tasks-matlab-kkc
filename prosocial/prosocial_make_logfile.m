function [fileID, mf_log] = prosocial_make_logfile(logpath, logtag)

logfile_mat = [logpath logtag '.mat'];
mf_log = matfile(logfile_mat, 'Writable', true);
mf_log.trials = [];
mf_log.times = [];


logfile_csv = [logpath logtag '.csv'];
fileID = fopen(logfile_csv, 'w');

lbl = cell(1,5);
j=0;
j=j+1; lbl{j} = 'block';
j=j+1; lbl{j} = 'trial';
j=j+1; lbl{j} = 'from_player';
j=j+1; lbl{j} = 'to_player';
j=j+1; lbl{j} = 'reaction_time';

write_csv_header(fileID, lbl);


