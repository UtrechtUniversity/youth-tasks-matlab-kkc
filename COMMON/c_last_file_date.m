function [lastdate] = c_last_file_date(tools_paths)

maxdate = 0;

for i = 1 : length(tools_paths)
    lstFiles = dir([tools_paths{i} '/*.m']);
    
    for j = 1 : length(lstFiles)
        if (maxdate < lstFiles(j).datenum)
            maxdate = lstFiles(j).datenum;
        end
    end
end

lastdate = maxdate;

