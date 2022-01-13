function [stack, N] = pseudo_rename(curTag, oldpath, newpath, sPseudoFind, sPseudoNew, flog, datum)

disp(['Indexing ' curTag '...']);

stack = [];
stack{1,1} = curTag;      %oldname
stack{1,2} = '';          %newname
stack{1,3} = 1;           %isdir
stack{1,4} = oldpath;     %olddir
stack{1,5} = newpath;     %newdir

k = 1;
N = 1;
while (k <= N)
    curItem = stack{k,1};
    
    [stack{k,2}] = pseudo_replace(curItem, sPseudoFind, sPseudoNew);
    
    if (stack{k,3} == 1)
        curDir = [stack{k,4} stack{k,1} '/'];
        tmpDir = dir(curDir);
        for j = 1 : length(tmpDir)
            curFile = tmpDir(j).name;
            if (strcmp(curFile(1), '.') == 0)
                stack{N+1,1} = curFile;
                stack{N+1,2} = '';
                stack{N+1,3} = tmpDir(j).isdir;
                stack{N+1,4} = curDir;
                stack{N+1,5} = [stack{k,5} stack{k,2} '/'];
                
                if (tmpDir(j).isdir == 0)
                    [~, ~, ext] = fileparts(curFile);
                    if (strcmpi(ext, '.zip') == 1)
                        stack{N+1,3} = 2;
                    end
                end
                
                N=N+1;
            end
        end
    end
    
    k=k+1;
end

disp(['Creating directory structure for ' curTag '...']);
for k = 1 : N
    if (stack{k,3} == 1)
        sDirCreate = [stack{k,5}, stack{k,2}];
        for f = 1 : length(flog)
            fprintf(flog(f), '%s: Creating directory %s\r\n', datum, sDirCreate);
        end
        mkdir(sDirCreate);
    end
end

disp(['Copying files for ' curTag '...']);
for k = 1 : N
    if (stack{k,3} == 0)
        sFileSrc = [stack{k,4}, stack{k,1}];
        sFileDst = [stack{k,5}, stack{k,2}];
        for f = 1 : length(flog)
            fprintf(flog(f), '%s: Copying file %s to %s\r\n', datum, sFileSrc, sFileDst);
        end
        copyfile(sFileSrc, sFileDst);
    end
end



