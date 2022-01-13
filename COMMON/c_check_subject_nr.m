function [sbj_inp_ok, subject_nr] = c_check_subject_nr(s_subject_nr, allow_12345)

sbj_inp_ok = 1;
if (s_subject_nr == 't')
    subject_nr = 12345;
else
    subject_nr = str2num(s_subject_nr);
    if (isempty(subject_nr))
        sbj_inp_ok = 0;
    elseif (length(s_subject_nr) ~= 5)
        sbj_inp_ok = 0;
    elseif (subject_nr == 12345)
        if (allow_12345 == 0)
            sbj_inp_ok = 0;
            disp('Pseudo code 12345 wordt gebruikt voor testen');
            disp('Voer t in als pseudo code om een test sessie te starten');
        end
    elseif ((subject_nr < 0) || (subject_nr > 99999))
        sbj_inp_ok = 0;
    end
end
