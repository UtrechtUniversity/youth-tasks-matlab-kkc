function [mf_log] = peabody_make_logfile(logpath, logtag, instap)

log_file = [logpath logtag '.mat'];
mf_log = matfile(log_file, 'Writable', true);

mf_log.instap = instap;

mf_log.result = [];
mf_log.reacts = [];
mf_log.start = [];
mf_log.afbreek = [];
mf_log.fouten = [];
mf_log.afbreekitem = [];
mf_log.ruwe_score = [];

%--------------------------------------------------------------------------
% 
% 
% logfile_csv = [logpath logtag '_answers.csv'];
% fileID = fopen(logfile_csv, 'w');
% 
% lbl = cell(1,34);
% j=0;
% for i = 1 : 17
%     j=j+1; lbl{j} = ['results_set_' num2str(i)];
% end
% for i = 1 : 17
%     j=j+1; lbl{j} = ['rtime_set_' num2str(i)];
% end
% 
% write_csv_header(fileID, lbl);

