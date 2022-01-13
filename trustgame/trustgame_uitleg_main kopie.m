

old_wrap_chars_instruction = wrap_chars_instruction;
wrap_chars_instruction = 110; % 1.6 * (4*scrW/6) / font_size_instruction;


uitleg = cell(1,18);

i = 0;
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_instruction = [
'In dit spel ga je samen met andere kinderen in Nederland spelen. Jullie gaan muntjes van 10 cent verdelen.\n\n' ...
'Elke keer dat je muntjes verdeelt noemen we een ronde. Elke ronde speel je met een ander kind. ' ...
'Je kan dus nooit met hetzelfde kind nog eens spelen. Aan het einde van het hele spel kiest de computer vier rondes uit. Het geld dat in die rondes voor jou was, krijg je van ons. Ook de andere kinderen krijgen het geld dat in die rondes voor hen was. ' ...
'Wat jij kiest in elke ronde heeft dus invloed op het geld dat jij en de andere kinderen aan het eind van het spel krijgen.\n\n' ...
'Het kind dat begint maakt de eerste keuze. We spelen het spel in 2 delen. Het ene deel ben je speler 1, het andere deel ben je speler 2.  Het kind dat de eerste keuze maakt  is speler 1. Het andere kind is speler 2. De computer bepaalt zometeen of je begint als speler 1 of als speler 2.\n\n' ...
'We gaan het spel nu uitleggen.  (druk op spatie om door te gaan)'];

uitleg{i}.schema = 0;
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Jullie beginnen altijd met 20 of 40 cent. Speler 1 kiest eerst:\n' ...
'- Met de 1-toets kiest speler 1 om zelf meteen het geld te verdelen.\n' ...
'In dit voorbeeld krijgen beide spelers dus 20 cent.\n' ...
'- Met de 0-toets kiest speler 1 om speler 2 het geld te laten verdelen.\n' ...
'Let op: Speler 2 mag dan drie keer zoveel geld verdelen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_both_inputs;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Speler 2 kiest dan in dit voorbeeld:\n' ...
'- Met de 1-toets krijgt speler 1: 0 cent en speler 2: 120 cent.\n' ...
'Of\n' ...
'- Met de 0-toets krijgt speler 1: 60 cent en speler 2: 60 cent.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_both_inputs;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
    
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_instruction = ['Nu volgt een voorbeeld. Jij bent hier speler 1.'];

uitleg{i}.schema = 0;
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier ben je speler 1. Het gele vak om je naam geeft aan dat je een keuze moet maken.\n' ...
'Als je gedrukt hebt ziet het andere kind je keuze. Deze wordt geel.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player1_input;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier heb je gedrukt op 1: je verdeelt zelf het geld.\n' ...
'Jij krijgt 20 cent en speler 2 krijgt 20 cent.\n' ...
'De ronde is nu afgelopen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player1_notrust;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier heb je gedrukt op 0: je laat speler 2 kiezen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_input;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Speler 2 is nu aan de beurt en verdeelt het geld.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_input;
uitleg{i}.isplayer = 2;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier heeft speler 2 gedrukt op 1:\n' ...
'Jij krijgt 0 cent en speler 2 krijgt 120 cent.\n' ...
'De ronde is nu afgelopen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_notrust;
uitleg{i}.isplayer = 2;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier heeft speler 2 gedrukt op 0:\n' ...
'Jij krijgt 60 cent en speler 2 krijgt 60 cent.\n' ...
'De ronde is nu afgelopen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_trust;
uitleg{i}.isplayer = 2;
uitleg{i}.player1 = 'Jij';
uitleg{i}.player2 = 'Speler 2';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_instruction = [
'Nu volgt weer een voorbeeld. Jij bent hier speler 2.'];

uitleg{i}.schema = 0;
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier ben je speler 2. Speler 1 kiest nu eerst.\n' ...
'Als speler 1 gedrukt heeft , zie je dit. De keuze wordt geel.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player1_input;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Speler 1';
uitleg{i}.player2 = 'Jij';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier heeft speler 1 gedrukt op 1: speler 1 verdeelt zelf het geld.\n' ...
'Speler 1 krijgt 20 cent en jij krijgt 20 cent.\n' ...
'De ronde is nu afgelopen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player1_notrust;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Speler 1';
uitleg{i}.player2 = 'Jij';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = ['Hier heeft speler 1 gedrukt op 0: jij mag kiezen'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_input;
uitleg{i}.isplayer = 1;
uitleg{i}.player1 = 'Speler 1';
uitleg{i}.player2 = 'Jij';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = ['Jij bent nu aan de beurt en verdeelt het geld.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_input;
uitleg{i}.isplayer = 2;
uitleg{i}.player1 = 'Speler 1';
uitleg{i}.player2 = 'Jij';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier heb jij gedrukt op 1:\n' ...
'Speler 1 krijgt 0 cent en jij krijgt 120 cent.\n' ...
'De ronde is nu afgelopen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_notrust;
uitleg{i}.isplayer = 2;
uitleg{i}.player1 = 'Speler 1';
uitleg{i}.player2 = 'Jij';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_uitleg = [
'Hier heb jij gedrukt op 0:\n' ...
'Speler 1 krijgt 60 cent en jij krijgt 60 cent.\n' ...
'De ronde is nu afgelopen.'];

uitleg{i}.schema = 1;
uitleg{i}.state = state_player2_trust;
uitleg{i}.isplayer = 2;
uitleg{i}.player1 = 'Speler 1';
uitleg{i}.player2 = 'Jij';
%--------------------------------------------------------------------------

i=i+1;
uitleg{i}.text_instruction = ['Kort samengevat\n\n' ...
    '- Je speelt elke ronde met een ander kind\n' ...
    '- Je kiest door op de 1-toets of op de 0-toets te drukken\n' ...
    '- Denk niet te lang na\n' ...
    '- Beide spelers zien meteen wat er is gekozen\n\n' ...
    'We gaan nu oefenen met de computer.\n\n' ...
    'Druk op spatie om verder te gaan of op T om terug te gaan'];

uitleg{i}.schema = 0;
%--------------------------------------------------------------------------


text_verder = ['Druk op spatie om verder te gaan, en op t om Terug te gaan'];

trial = 1;

always_show_input = 1;
%for i = 1 : length(uitleg)
Ind = 1;
while (Ind <= length(uitleg))
    goBack = 0;

    if (uitleg{Ind}.schema == 1)
        text_uitleg = uitleg{Ind}.text_uitleg;
        state = uitleg{Ind}.state;
        isplayer = uitleg{Ind}.isplayer;
        player1 = uitleg{Ind}.player1;
        player2 = uitleg{Ind}.player2;
        
        trustgame_uitleg_draw;
    else
        text_instruction = uitleg{Ind}.text_instruction;
        
        c_instruction(hwnd, scrInd, 0, AllowRepeat, [], [], font_size_instruction, font_color_instruction, wrap_chars_instruction, text_instruction);
    end
    
    if (goBack == 0)
        Ind=Ind+1;
    elseif (i > 1)
        Ind=Ind-1;
    end
end
always_show_input = 0;


wrap_chars_instruction = old_wrap_chars_instruction;


