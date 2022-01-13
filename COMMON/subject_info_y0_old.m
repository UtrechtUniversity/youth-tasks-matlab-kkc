
inp_ok = 0;
while (inp_ok == 0)
    s_subject_nr = input(['Voer pseudo code in (5 cijfers): ' prefix], 's');
    
    inp_ok = 1;
    if (strcmp(s_subject_nr, 'clean'))
        stopped = 1;
        subject_cleanup;
        return;
    elseif (s_subject_nr == 't')
        subject_nr = 12345;
    else
        subject_nr = str2num(s_subject_nr);
        if (isempty(subject_nr))
            inp_ok = 0;
        elseif (length(s_subject_nr) ~= 5)
            inp_ok = 0;
        elseif (subject_nr == 12345)
            inp_ok = 0;
            disp('Pseudo code 12345 wordt gebruikt voor testen');
            disp('Voer t in als pseudo code om een test sessie te starten');
        elseif ((subject_nr < 0) || (subject_nr > 99999))
            inp_ok = 0;
        end
    end
    
    if (inp_ok == 0)
        disp('Ongeldige pseudo code')
    end
end

info_entered = 0;

subj_path = [script_path '/DATA/SUBJECTS/'];
if (~exist(subj_path, 'dir'))
    mkdir(subj_path);
end

subject_filename = [subj_path 'sbj' num2str(subject_nr) '.mat'];
if (exist(subject_filename, 'file') == 2)
    subject_file = matfile(subject_filename, 'writable', true);
    age_nr = subject_file.age_nr;
    info_entered = 1;
else
    subject_file = matfile(subject_filename, 'writable', true);
    subject_file.subject_nr = subject_nr;
    subject_file.age_nr = [];
end

if (info_entered == 1)
    disp(' ')
end

inp_ok = 0;
while (inp_ok == 0)
    
    if (info_entered == 1)
        disp(sprintf('Pseudo code: %s%d', prefix, subject_nr))
        disp(sprintf('Wave: %dm', age_nr))
        disp(' ')
        
        inp_ok = 1;
        bInpYesNoOK = 0;
        while (bInpYesNoOK == 0)
            user_ok = input('Klopt dit? (y/n): ', 's');
            if (~isempty(user_ok))
                if ((user_ok == 'n') || (user_ok == 'N'))
                    inp_ok = 0;
                    bInpYesNoOK = 1;
                elseif ((user_ok == 'y') || (user_ok == 'Y'))
                    inp_ok = 1;
                    bInpYesNoOK = 1;
                end
            end
        end
    end
        
    if (inp_ok == 0)
        disp(' ');
        age_nr = input('Voer wave in (5 of 10) maanden: ');
        
        disp(' ')
        
        info_entered = 1;
        if (isempty(age_nr))
            info_entered = 0;
            disp('Ongeldige wave')
        elseif (sum(age_nr == [5 10]) == 0)
            info_entered = 0;
            disp('Ongeldige wave')
        end
        
    end
end

subject_file.age_nr = age_nr;

