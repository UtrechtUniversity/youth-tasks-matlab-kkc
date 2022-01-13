function [reportpath] = c_init_report(logpath)

reportpath = [logpath '/report'];
if (~exist(reportpath, 'dir'))
    mkdir(reportpath);
end

