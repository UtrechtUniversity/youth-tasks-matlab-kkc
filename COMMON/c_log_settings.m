

sett_head = cell(1,2);
sett_head{1} = 'setting';
sett_head{2} = 'value';

sett_log = cell(10,2);
sett_log{1,1} = 'computerID';       sett_log{1,2} = computerID;
sett_log{2,1} = 'ScreenWidthCm';    sett_log{2,2} = scrW_cm;
sett_log{3,1} = 'ScreenHeightCm';   sett_log{3,2} = scrH_cm;
sett_log{4,1} = 'trackerID';        sett_log{4,2} = trackerID;
sett_log{5,1} = 'pseudocode';       sett_log{5,2} = s_subject_nr;
sett_log{6,1} = 'wave';             sett_log{6,2} = wave;
sett_log{7,1} = 'logtag';           sett_log{7,2} = logtag;
sett_log{8,1} = 'en_eyetracking';   sett_log{8,2} = eyetracking;
sett_log{9,1} = 'en_photodiode';    sett_log{9,2} = en_diode;
%sett_log{,1} = 'R9_counter_trustgame';  sett_log{,2} = R9_counter_trustgame;
%sett_log{,1} = 'R0_counter_restingstate';  sett_log{,2} = R0_counter_restingstate;
sett_log{10,1} = 'R0_counter_etframerate';  sett_log{10,2} = R0_counter_etframerate;
sett_log{11,1} = 'SVN_revision';    sett_log{11,2} = shortRevisionString;

write_csv_cell([logpath logtag '_settings.txt'], sett_head, sett_log);

