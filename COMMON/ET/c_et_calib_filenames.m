function [calib_savefile, calib_plotfile] = c_et_calib_filenames(logpath, logtag, calib_count, trial)
%%%%%%%commit this fix, note the od typo (extra e)%%%%%%%%%%
calib_savefile = [logpath logtag '_calib_' datestr(datetime('now'),'yyyymmddTHHMMSS') '_' num2str(calib_count) '_trial_' num2str(trial) '.mat'];
%calib_plotfile = [logpath '/report/' logtag '_calib_' datestr(datetime('now'),'yyyymmddTHHMMSS') '_' num2str(calib_count) '_trial_' num2str(trial) '.jpg'];
calib_plotfile = [logpath logtag '_calib_' datestr(datetime('now'),'yyyymmddTHHMMSS') '_' num2str(calib_count) '_trial_' num2str(trial) '.jpg'];