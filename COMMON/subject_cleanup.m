
rmv_ok = input('Weet je zeker dat je alle participant bestanden wilt verwijderen? (y/n): ', 's');

disp(' ')
if ((rmv_ok ~= 'y') && (rmv_ok ~= 'Y'))
    disp('Er is niets verwijdert');
    return;
end

lstSubjects = dir([subject_path '/sbj*.mat']);


disp([num2str(length(lstSubjects)) ' participant info bestanden gevonden...'])
disp(' ')

for i = 1 : length(lstSubjects)
    sFile = lstSubjects(i).name;
    if (~strcmp(sFile, 'sbj12345.mat'))
        delete([subject_path '/' sFile]);
        disp([num2str(i) ') Verwijderd: ' sFile]);
    else
        disp([num2str(i) ') Participant bestand voor testen overgeslagen: ' sFile]);
    end
end

disp(' ');
disp('Voltooid');



