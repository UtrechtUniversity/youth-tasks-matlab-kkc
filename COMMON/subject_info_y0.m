

[keyDevice, barcodeKB] = c_find_keyboards();

getWaveFromBarcode = 0;
pre_subject = -1;
info_entered = 0;
while (info_entered == 0)
    
    if (barcodeKB == -1)
    
        sbj_inp_ok = 0;
        while (sbj_inp_ok == 0)
            s_subject_nr = input(['Voer pseudo code in (5 cijfers): ' prefix], 's');
            [sbj_inp_ok, subject_nr] = c_check_subject_nr(s_subject_nr, 0);
            if (sbj_inp_ok == 0)
                disp('Ongeldige pseudo code')
            end
        end
    
    else
        
        [subject_nr, s_bcYearNr, s_subject_nr] = c_subject_info_barcode(prefix, 'm');
        getWaveFromBarcode = 1;
        
    end
    
    subj_path = [script_path '/DATA/SUBJECTS/'];
    if (~exist(subj_path, 'dir'))
        mkdir(subj_path);
    end
    
    info_entered = 0;
    subject_filename = [subj_path 'sbj' num2str(subject_nr) '.mat'];
    if (exist(subject_filename, 'file') == 2)
        subject_file = matfile(subject_filename, 'writable', true);
        if (getWaveFromBarcode == 1)
            age_nr = str2num(s_bcYearNr);
        else
            age_nr = subject_file.age_nr;
        end
        %bd_y = subject_file.bd_year;
        %bd_m = subject_file.bd_month;
        %bd_d = subject_file.bd_day;
        %geslacht = subject_file.geslacht;
        if (pre_subject ~= subject_nr)
            info_entered = 1;
        end
    else
        subject_file = matfile(subject_filename, 'writable', true);
        subject_file.subject_nr = subject_nr;
        subject_file.age_nr = [];
        subject_file.bd_year = [];
        subject_file.bd_month = [];
        subject_file.bd_day = [];
        subject_file.geslacht = [];
    end
    pre_subject = subject_nr;
    
    disp(' ');
    if (info_entered == 0)
        wave_ok = 0;
        while (wave_ok == 0)
            if (getWaveFromBarcode == 1)
                getWaveFromBarcode = 0;
                age_nr = str2num(s_bcYearNr);
            else
                age_nr = input('Voer wave in (5 of 10) maanden: ');
            end
            disp(' ')
            
            wave_ok = 1;
            if (isempty(age_nr))
                wave_ok = 0;
                disp('Ongeldige wave')
            elseif (sum(age_nr == [5 10]) == 0)
                wave_ok = 0;
                disp('Ongeldige wave')
            end
        end
    end
    
    disp(' ');
    disp(sprintf('Pseudo code: %s%05d', prefix, subject_nr))
    disp(sprintf('Wave: %dm', age_nr))
    disp(' ')
    
    info_entered = 1;
    bInpYesNoOK = 0;
    while (bInpYesNoOK == 0)
        user_ok = input('Klopt dit? (y/n): ', 's');
        if (~isempty(user_ok))
            if ((user_ok == 'n') || (user_ok == 'N'))
                info_entered = 0;
                bInpYesNoOK = 1;
            elseif ((user_ok == 'y') || (user_ok == 'Y'))
                info_entered = 1;
                bInpYesNoOK = 1;
            end
        end
    end
    
end

subject_file.age_nr = age_nr;

