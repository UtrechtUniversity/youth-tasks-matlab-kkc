function [fileID, logfile] = discount_makelogfile(logpath, logtag, NDelays)

logfile = [logpath logtag '.txt'];

disp(sprintf('The log file is: %s', logfile));
fileID = fopen(logfile, 'w');
% make log file header
fprintf(fileID, 'Trial\tDelayNr\tDelay\tChoice\tFlipBtn\tvarAmount\tfixAmount\t');
for i = 1 : NDelays
    fprintf(fileID, 'Converged%d\t', i);
end
for i = 1 : NDelays
    fprintf(fileID, 'OLL%d\t', i);
end
for i = 1 : NDelays
    fprintf(fileID, 'ILL%d\t', i);
end
for i = 1 : NDelays
    fprintf(fileID, 'IUL%d\t', i);
end
for i = 1 : NDelays
    fprintf(fileID, 'OUL%d\t', i);
end
for i = 1 : NDelays
    fprintf(fileID, 'Result%d\t', i);
end
fprintf(fileID, 'ResponseTime\tFakeTrial\r\n');
