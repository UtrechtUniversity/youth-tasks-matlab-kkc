

if (exist('confirm_extra_info', 'var') == 0)
    confirm_extra_info = 1;
end

info_entered = 0;

subject_filename = [subj_path 'sbj' num2str(subject_nr) '.mat'];
if (exist(subject_filename, 'file') == 2)
    subject_file = matfile(subject_filename, 'writable', true);
    age_nr = subject_file.age_nr;
    bd_y = subject_file.bd_year;
    bd_m = subject_file.bd_month;
    bd_d = subject_file.bd_day;
    geslacht = subject_file.geslacht;
    
    if (isempty(bd_y) || isempty(bd_m) || isempty(bd_d) || isempty(geslacht))
        info_entered = 0;
        confirm_extra_info = 1;
    else
        info_entered = 1;
    end
else
    error('Subject file not found');
end

if (info_entered == 1)
    disp(' ')
end

inp_ok = 0;
while (inp_ok == 0)
    
    if (info_entered == 1)
        
        bd = datenum(bd_y, bd_m, bd_d);
        nu = now;
        %[Y, M, D, H, MN, S] = datevec(nu - bd);
        %age_y = Y;
        %age_m = M;
        [Y_bd, M_bd, D_bd, ~, ~, ~] = datevec(bd);
        [Y_nu, M_nu, D_nu, ~, ~, ~] = datevec(nu);
        age_y = Y_nu - Y_bd;
        age_m = M_nu - M_bd;
        age_d = D_nu - D_bd;
        if (age_d < 0)
            age_m = age_m - 1;
            age_d = age_d + 30;
        end
        if (age_m < 0)
            age_y = age_y - 1;
            age_m = age_m + 12;
        end
        
        disp(sprintf('Pseudo code: %s%d', prefix, subject_nr))
        disp(sprintf('Wave: %dy', age_nr))
        disp(sprintf('Geboorte datum: %d-%d-%d', bd_d, bd_m, bd_y))
        disp(sprintf('Leeftijd: %d jaar en %d maanden', age_y, age_m))
        if (geslacht == 0)
            disp('Geslacht: vrouw');
        elseif (geslacht == 1)
            disp('Geslacht: man');
        else
            disp('Geslacht: ?');
        end
        disp(' ')
        
        inp_ok = 1;
        if (confirm_extra_info == 1)
            bInpYesNoOK = 0;
            while (bInpYesNoOK == 0)
                user_ok = input('Klopt dit? (y/n): ', 's');
                if (~isempty(user_ok))
                    %if ((user_ok == 'n') || (user_ok == 'N'))
                    if (strcmp(user_ok, 'N') || strcmp(user_ok, 'n'))
                        inp_ok = 0;
                        bInpYesNoOK = 1;
                        %elseif ((user_ok == 'y') || (user_ok == 'Y'))
                    elseif (strcmp(user_ok, 'Y') || strcmp(user_ok, 'y'))
                        inp_ok = 1;
                        bInpYesNoOK = 1;
                    end
                end
            end
        end
    end
        
    if (inp_ok == 0)
        disp(' ');
        
        disp('Voer geboorte datum in')
        bd_y = input(' jaar: ');
        bd_m = input(' maand: ');
        bd_d = input(' dag: ');
        
        s_geslacht = input('geslacht (m/v): ', 's');
        
        disp(' ')
        
        info_entered = 1;
        
        if (isempty(bd_m))
            info_entered = 0;
            disp('Ongeldige maand')
        elseif ((bd_m < 0) || (bd_m > 12))
            info_entered = 0;
            disp('Maand moet een getal zijn tussen 1 en 12');
        end
        
        if (isempty(bd_d))
            info_entered = 0;
            disp('Ongeldige dag')
        elseif ((bd_d < 0) || (bd_d > 31))
            info_entered = 0;
            disp('Dag moet een getal zijn tussen 1 en 31');
        end
        
        if (isempty(s_geslacht))
            info_entered = 0;
            disp('Geslacht moet "m" of "v" zijn');
        elseif ((s_geslacht == 'm') || (s_geslacht == 'M'))
            geslacht = 1;
        elseif ((s_geslacht == 'v') || (s_geslacht == 'V'))
            geslacht = 0;
        else
            info_entered = 0;
            disp('Geslacht moet "m" of "v" zijn');
        end
    end
end

subject_file.bd_year = bd_y;
subject_file.bd_month = bd_m;
subject_file.bd_day = bd_d;

subject_file.geslacht = geslacht;


