function [calib_savefile, calib_plotfile] = c_et_calib_filenames2(logpath, custom_logname)
%Here, the name is determined beforehand, whereas the regular naming function has different arguments

calib_savefile = [logpath custom_logname '.mat'];
calib_plotfile = [logpath '/report/' custom_logname '.jpg'];
