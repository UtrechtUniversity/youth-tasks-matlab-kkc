

bExampleDone = 0;
while (bExampleDone == 0)
    
    text_instruction = ['Bij deze taak krijg je een heleboel plaatjes te zien, steeds vier per scherm.\n' ...
        'Kijk hier zijn bijvoorbeeld een vlieger, een bank, een kip en een jurk. Nu hoor je een woord en dan mag jij het goede plaatje aanklikken.\n' ...
        'Als je het woord nog eens wilt horen, klik dan op de luidspreker linksboven.\n\n' ...
        'Druk op de spatiebalk om het eens proberen. Luister goed.'];
    curset = 3;
    pract_snd_ind = 3;
    bChoose = 0;
    peabody_pratice;
    
    bPractDone = 0;
    try_cnt = 0;
    while ((bPractDone == 0) && (try_cnt < 4))
        bChoose = 1;
        bShowInstruction = 0;
        bPlayFirst = 1;
        peabody_practice_large;
        
        if (bPlayedTwice == 0)
            text_instruction = 'Als je het woord nog eens wilt horen, klik je op de luidspreker. Klik op de luidspreker.';
            bShowInstruction = 1;
            bPlayFirst = 0;
            peabody_practice_large;
        end
        
        text_instruction = ['Begrijp je het?\n\nDruk op "j" voor ja, of op "n" voor nee'];
        c_ask_yesno;
        bPractDone = bYesNo;
        bExampleDone = bYesNo;
        try_cnt = try_cnt+1;
        pract_snd_ind = mod(pract_snd_ind,4) + 1;
    end
end

