

bExampleDone = 0;
while (bExampleDone == 0)
    
    text_instruction = ['Kijk eens, hier zijn nog meer plaatjes.\n' ...
        'Nu hoor je weer een woord en dan mag jij op het goede plaatje klikken\n\n' ...
        'Druk op spatie om door te gaan\n' ...
        'Luister goed'];
    curset = 4;
    pract_snd_ind = 2;
    bChoose = 0;
    peabody_pratice;
    
    bPractDone = 0;
    try_cnt = 0;
    while ((bPractDone == 0) && (try_cnt < 4))
        bChoose = 1;
        bShowInstruction = 0;
        bPlayFirst = 1;
        peabody_practice_large;
        
        if (answer == pract_snd_ind)
            text_instruction = ['Goed zo! Nu gaan we beginnen.\n\n' ...
                                'Nu komen nog een heleboel plaatjes. We gaan beginnen met woorden die beter bij je leeftijd passen.\n' ...
                                'Langzamerhand wordt de test moeilijker. We gaan eens kijken hoeveel woorden je weet.\n\n' ...
                                'Klik op OK om te beginnen.'];
            c_instruction(hwnd, scrInd, 1, 0, rec_btn_ok, rec_btn_ok_text, font_size_instruction, font_color_instruction, wrap_chars_instruction, text_instruction);
            
            bPractDone = 1;
            bExampleDone = 1;
        else
            text_instruction = ['We proberen het nog eens. Luister goed'];
            c_instruction(hwnd, scrInd, 1, 0, rec_btn_ok, rec_btn_ok_text, font_size_instruction, font_color_instruction, wrap_chars_instruction, text_instruction);
            
            PractDone = 0;
            bExampleDone = 0;
        end
        
        try_cnt = try_cnt+1;
        pract_snd_ind = mod(pract_snd_ind,4) + 1;
    end
end

