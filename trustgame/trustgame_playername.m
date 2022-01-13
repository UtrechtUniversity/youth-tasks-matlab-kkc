
bOK = 0;
while (bOK == 0)
    player_name = input('Wat is je naam? ', 's');
    disp(' ');
    disp(['Je naam is: ' player_name]);
    yn = input(['Klopt dit? (j voor ja, of n voor nee): '], 's');
    if (yn == 'j')
        bOK = 1;
    end
    disp(' ');
end
