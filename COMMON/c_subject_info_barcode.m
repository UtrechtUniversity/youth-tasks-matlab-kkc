function [subject_nr, s_bcYearNr, s_subject_nr] = c_subject_info_barcode(prefix, wave_postfix)

s_subject_nr = [];

sbj_inp_ok = 0;
while (sbj_inp_ok == 0)
    s_barcode = input('Scan barcode and press enter: ', 's');
    
    s_inf = strsplit(s_barcode, '_');
    
    barcodeErr = 0;
    if (length(s_inf) < 2)
        barcodeErr = 1;
    elseif (length(s_inf{1}) ~= 6)
        barcodeErr = 1;
    elseif (length(s_inf{2}) < 2)
        barcodeErr = 1;
    end
    
    waveErr = 0;
    if (barcodeErr == 0)
        s_bcPseudo = s_inf{1};
        s_bcRondom = s_bcPseudo(1);
        s_bcSubject = s_bcPseudo(2:end);
        s_subject_nr = s_bcSubject;
        
        [sbj_inp_ok, subject_nr] = c_check_subject_nr(s_bcSubject, 1);
        barcodeErr = ~sbj_inp_ok;
        
        if (upper(s_bcRondom) ~= upper(prefix))
            barcodeErr = 1;
            waveErr = 1;
        end
        
        s_bcWave = s_inf{2};
        s_bcY = s_bcWave(end);
        s_bcYearNr = s_bcWave(1:end-1);
        
        if (upper(s_bcY) ~= upper(wave_postfix))
            barcodeErr = 1;
            waveErr = 1;
        end
    end
    
    if (barcodeErr == 1)
        if (waveErr == 1)
            disp('Incorrect wave, please retry or close script and select different wave');
        else
            disp('Invalid barcode, please retry');
        end
        disp(' ');
    end
    
    sbj_inp_ok = ~barcodeErr;
end






