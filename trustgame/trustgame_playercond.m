
bOK = 0;
while (bOK == 0)
    player_cond = input('Geef conditie op (1, 2): ');
    if ((player_cond == 1) || (player_cond == 2))
        disp(' ');
        disp(['De conditie is: ' num2str(player_cond)]);
        yn = input(['Klopt dit? (j voor ja, of n voor nee): '], 's');
        if (yn == 'j')
            bOK = 1;
        end
        disp(' ');
    else
        disp('Ongeldige conditie');
    end
end
