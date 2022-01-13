
%global changelog_path;
datum = datestr(now, 'yyyymmdd');
changelog = [changelog_path 'log_' datum '.txt'];
flog = fopen(changelog, 'a');
disp(['Logfile: ' changelog]);

lstData = dir(data_path);

inAllOK = 0;
while (inAllOK == 0)
    inOK = 0;
    while (inOK == 0)
        sPseudoFind = strtrim(input('Enter the incorrect pseudocode to fix: ', 's'));
        if (length(sPseudoFind) == 6)
            inOK = 1;
        else
            disp('Incorrect pseudocode format');
        end
    end
    
    inOK = 0;
    while (inOK == 0)
        sPseudoNew = strtrim(input('Enter the new corrected pseudocode: ', 's'));
        if (length(sPseudoNew) == 6)
            inOK = 1;
        else
            disp('Incorrect pseudocode format');
        end
    end
    
    disp(' ');
    disp(['Old incorrect pseudocode: ' sPseudoFind]);
    disp(['New corrected pseudocode: ' sPseudoNew]);
    inAllOK = c_cmd_ask_yesno('Is this correct?');
    disp(' ');
end


lstInfo = [];
ind = 0;

lstWaves = [];
lstTasks = [];

for i = 1 : length(lstData)
    
    sTag = lstData(i).name;
    if ((strcmp(sTag(1), '.') == 0) && (lstData(i).isdir == 1))
        %disp(sTag);
        
        C = strsplit(sTag, '_');
        if (length(C) > 5)
            sPseudo = upper(C(1));
            sWave = upper(C(2));
            sTask = upper(C(3));
            
            if (strcmp(sPseudo, sPseudoFind) == 1)
                ind=ind+1;
                lstInfo{ind, 1} = sPseudo;
                lstInfo{ind, 2} = sWave;
                lstInfo{ind, 3} = sTask;
                lstInfo{ind, 4} = sTag;
                
                bFnd = 0;
                for j = 1 : length(lstWaves)
                    if (strcmp(lstWaves{j}, sWave) == 1)
                        bFnd = 1;
                        break;
                    end
                end
                if (bFnd == 0)
                    lstWaves{end+1} = sWave;
                end
                
                bFnd = 0;
                for j = 1 : length(lstTasks)
                    if (strcmp(lstTasks{j}, sTask) == 1)
                        bFnd = 1;
                        break;
                    end
                end
                if (bFnd == 0)
                    lstTasks{end+1} = sTask;
                end
            end
        end
    end
end
cntInfo = ind;

if (ind == 0)
    disp(['No data found for ' sPseudoFind]);
else
    iW = 1;
    if (length(lstWaves) > 1)
        disp(' ');
        for j = 1 : length(lstWaves)
            disp([num2str(j) ') ' char(lstWaves{j})]);
        end
        disp(' ');
        
        inOK = 0;
        while (inOK == 0)
            iW = input('Select a wave to fix the pseudocode for: ');
            if ((iW < 1) || (iW > length(lstWaves)))
                disp('Incorrect wave selected');
            else
                inOK = 1;
            end
        end
    end
    sWaveFix = char(lstWaves{iW});
    disp(['Wave: ' sWaveFix]);
    
    lstFix = [];
    for j = 1 :  cntInfo
        if (strcmp(lstInfo{j,2}, sWaveFix) == 1)
            lstFix{end+1,1} = j;
            lstFix{end,2} = lstInfo{j,4};
        end
    end
    
    disp(' ');
    disp('0) ALL');
    for j = 1 : length(lstFix)
        disp([num2str(j) ') ' char(lstFix{j,2})]);
    end
    disp(' ');
    
    inOK = 0;
    while (inOK == 0)
        iFix = str2num(input('Select one or more (space separated) tasks to fix the pseudocode for: ', 's'));
        inOK = ~isempty(iFix);
        if ((length(iFix) == 1) && (iFix(1) == 0))
            iFix = 1 : length(lstFix);
        end
        
        for j = 1 : length(iFix)
            if ((iFix(j) < 1) || (iFix(j) > length(lstFix)))
                disp(['invalid input: ' num2str(iFix(j))]);
                inOK = 0;
                break;
            end
        end
    end
    
    disp(' ');
    
    %--- ACTUAL FIXING ----------------------------------------------------
    
    old_path = [data_path 'OLD_INCORRECT/'];
    new_path = [data_path 'NEW_CORRECTED/'];
    
    if (exist(old_path, 'dir') == 0)
        disp(['Creating directory ' old_path]);
        mkdir(old_path)
    end
    
    if (exist(new_path, 'dir') == 0)
        disp(['Creating directory ' new_path]);
        mkdir(new_path)
    end
    
    for i = 1 : length(iFix)
        curTag = lstFix{iFix(i), 2};
        
        tmplog = [changelog_path 'log_tmp.txt'];
        if (exist(tmplog, 'file') > 0)
            delete(tmplog);
        end
        ftmp = fopen(tmplog, 'a');
        
        fprintf(flog, '%s: Correcting pseudocode %s to %s for %s\r\n', datum, sPseudoFind, sPseudoNew, curTag);
        fprintf(ftmp, '%s: Correcting pseudocode %s to %s for %s\r\n', datum, sPseudoFind, sPseudoNew, curTag);
        
        [stack, N] = pseudo_rename(curTag, data_path, new_path, sPseudoFind, sPseudoNew, [flog, ftmp], datum);
        
        disp(['Fixing zip files for ' curTag '...']);
        for k = 1 : N
            if (stack{k,3} == 2)
                disp(['unzipping: ' stack{k,1}]);
                oldzippath = [stack{k,4} stack{k,1}];
                [~, zipfile, ~] = fileparts(oldzippath);
                oldZipDir = [stack{k,5} zipfile '_zip'];
                fprintf(flog, '%s: Unzipped %s to %s\r\n', datum, oldzippath, oldZipDir);
                fprintf(ftmp, '%s: Unzipped %s to %s\r\n', datum, oldzippath, oldZipDir);
                unzip(oldzippath, oldZipDir);
                
                [stack_zip, N_zip] = pseudo_rename([zipfile '_zip'], stack{k,5}, stack{k,5}, sPseudoFind, sPseudoNew, [flog, ftmp], datum);
                
                newZipFile = [stack{k,5} pseudo_replace(zipfile, sPseudoFind, sPseudoNew) '.zip'];
                newZipDir = [stack_zip{1,5} stack_zip{1,2}];
                disp(['Zipping ' stack{1,2} '...']);
                fprintf(flog, '%s: Zipped %s to %s\r\n', datum, newZipDir, newZipFile);
                fprintf(ftmp, '%s: Zipped %s to %s\r\n', datum, newZipDir, newZipFile);
                zip(newZipFile, newZipDir, newZipDir);
                
                disp('Removing old files...');
                fprintf(flog, '%s: Removed %s\r\n', datum, newZipDir);
                fprintf(ftmp, '%s: Removed %s\r\n', datum, newZipDir);
                rmdir(newZipDir, 's');
                fprintf(flog, '%s: Removed %s\r\n', datum, oldZipDir);
                fprintf(ftmp, '%s: Removed %s\r\n', datum, oldZipDir);
                rmdir(oldZipDir, 's');
            end
        end
        
        disp(['Moving old files for ' curTag '...']);
        oldPathMove = [stack{1,4}, stack{1,1}];
        newPathMove = [old_path, stack{1,1}];
        fprintf(flog, '%s: Moving folder including files and subfolders %s to %s\r\n', datum, oldPathMove, newPathMove);
        fprintf(ftmp, '%s: Moving folder including files and subfolders %s to %s\r\n', datum, oldPathMove, newPathMove);
        movefile(oldPathMove, newPathMove, 'f');
        
        disp(['Modifying settings file for ' curTag '...']);
        C = strsplit(stack{1,2}, '_');
        C{end} = 'settings.txt';
        curSett = [stack{1,5} stack{1,2} '/' strjoin(C, '_')];
        tmpSett = [stack{1,5} stack{1,2} '/tmp_' strjoin(C, '_')];
        if (exist(curSett, 'file') == 0)
            disp(['<strong>ERROR: Could not find settings file for ' curTag '</strong>']);
        else
            %disp(['settings file ' curSett]);
            movefile(curSett, tmpSett, 'f');
            
            fidR = fopen(tmpSett, 'r');
            fidW = fopen(curSett, 'w');
            sLine = fgetl(fidR);
            while (sLine ~= -1)
                C = strsplit(sLine, ',');
                if (strcmpi(strtrim(C(1)), 'pseudocode') == 1)
                    fprintf(fidW, 'pseudocode,''%s''\r\n', sPseudoNew);
                    fprintf(flog, '%s: Modifying pseudocode to %s in settings file %s\r\n', datum, sPseudoNew, curSett);
                    fprintf(ftmp, '%s: Modifying pseudocode to %s in settings file %s\r\n', datum, sPseudoNew, curSett);
                else
                    fprintf(fidW, '%s\r\n', sLine);
                end
                sLine = fgetl(fidR);
            end
            fclose(fidW);
            fclose(fidR);
            
            delete(tmpSett);
        end
        
        fclose(ftmp);
        
        %%copy tmplog
        copyfile(tmplog, [stack{1,5} stack{1,2} '/' stack{1,2} '_changelog.txt']);
        
        disp(' ');
        
    end
    %----------------------------------------------------------------------
    
    disp('All actions completed');
end

fclose(flog);


