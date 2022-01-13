
[keyDevice, barcodeKB] = c_find_keyboards();

%trustgame_playercond;
player_cond = 1 + R9_counter_trustgame;

trustgame_playername;
trustgame_make_logfile;

%usemouse = 0;

c_default_keys;
c_init;
bgColor = [128, 0, 0];
%c_setup_screen;
[hwnd, fps, scrW, scrH] = c_setup_screen(0, bgColor, 0);
fps = 60;
c_make_colors(hwnd);

c_keyboard_listen(2);

rec_center = [scrW/2, scrH/2, scrW/2, scrH/2];

trustgame_load_images;
scale = scrH / 480;
trustgame_rec_init;

c_init_instruction;
font_color_instruction = yellow;

font_size = 20;
txt_clr = black;
Screen('TextFont', hwnd, 'Arial');
Screen('TextSize', hwnd, font_size);

AllowRepeat = 0;

%--------------------------------------------------------------------------

%player1 = 'Roy';
%player2 = 'Computer';

state_none = 0;
state_both_inputs = 1;
state_player1_input = 2;
%state_player1_wait = 2;
state_player2_input = 3;
%state_player2_wait = 3;
state_player1_notrust = 4;
state_player2_trust = 5;
state_player2_notrust = 6;

%--------------------------------------------------------------------------

%trial = 1;
%isplayer = 1;
%state = 0;

text_title = 'Welkom bij het munten-verdeel spel';
c_title_screen;

scale = 1 + (scrH-480)/(3*480);
trustgame_rec_init;
trustgame_params_uitleg;
trustgame_uitleg_main;

%--------------------------------------------------------------------------

fps = 60;
%mf_log.blocks = []; %cell(1,4);

%--------------------------------------------------------------------------

doeOefen = 1;
while (doeOefen == 1)

    text_title = 'We gaan nu oefenen dat je mag beginnen';
    do_choose = 0;
    player_choice = 1;
    player1 = player_name;
    player2 = 'Computer';
    trustgame_comp_choose;
    
    scale = scrH / 480;
    trustgame_rec_init;
    trustgame_params_oefen;
    cur_block = 1;
    
    %mf_log.pract_coin_count = [mf_log.pract_coin_count; coin_count];
    %mf_log.pract_params = [mf_log.pract_params; params];
    %mf_log.pract_names = [mf_log.pract_names names];
    
    is_oefen_trial = 1;
    trustgame_player1_trials;
    
    %--------------------------------------------------------------------------
    
    text_title = 'We gaan nu oefenen wat er gebeurt als je te lang wacht';
    do_choose = 0;
    player_choice = 1;
    player1 = player_name;
    player2 = 'Computer';
    trustgame_comp_choose;
    
    scale = scrH / 480;
    trustgame_rec_init;
    trustgame_params_oefen_wacht;
    cur_block = 1;
    
    %mf_log.pract_coin_count = [mf_log.pract_coin_count; coin_count];
    %mf_log.pract_params = [mf_log.pract_params; params];
    %mf_log.pract_names = [mf_log.pract_names names];
    
    is_oefen_trial = 1;
    trustgame_player1_dummy_trials;
    
    %--------------------------------------------------------------------------
    
    text_title = 'We gaan nu oefenen dat je speler 2 bent';
    do_choose = 0;
    player_choice = 2;
    player1 = 'Computer';
    player2 = player_name;
    trustgame_comp_choose;
    
    scale = scrH / 480;
    trustgame_rec_init;
    trustgame_params_oefen;
    cur_block = 2;
    
    %mf_log.pract_coin_count = [mf_log.pract_coin_count; coin_count];
    %mf_log.pract_params = [mf_log.pract_params; params];
    %mf_log.pract_names = [mf_log.pract_names names];
    
    is_oefen_trial = 1;
    trustgame_player2_trials;
    
    %--------------------------------------------------------------------------
    
    wrap_chars_instruction = 110;
    AllowRepeat = 1;
    
    KbName('UnifyKeyNames');
    key_repeat = KbName('t');
    
    text_instruction = ['Dit waren de oefenrondes\n' ...
        'Wil je dit nog een keer oefenen druk op T van Terug.\n' ...
        'Vragen?\n\n' ...
        'Als alles duidelijk is kun je beginnen.\n' ...
        'Denk goed na over elke keuze, maar niet te lang\n\n' ...
        'Weet je nog? Aan het einde van het hele spel kiest de computer vier rondes uit.\n' ...
        'Het geld dat in die rondes voor jou was, krijg je van ons.\n' ...
        'Ook de andere kinderen krijgen het geld dat in die rondes voor hen was.\n' ...
        'Wat jij kiest in elke ronde heeft dus invloed op het geld dat jij en de andere kinderen aan het eind van het spel krijgen.\n\n' ...
        'Veel plezier!\n' ...
        'Druk op de spatie om verder te gaan\n'];
    [bRepeat] = c_instruction(hwnd, scrInd, 0, AllowRepeat, [], [], font_size_instruction, font_color_instruction, wrap_chars_instruction, text_instruction);
    
    AllowRepeat = 0;
    doeOefen = bRepeat;
end

%--------------------------------------------------------------------------

trustgame_connection;

%--------------------------------------------------------------------------

fps = 60;

scale = scrH / 480;
trustgame_rec_init;

title_comp_choose = cell(1, 2);
title_comp_choose{1} = 'De computer bepaalt of je speler 1 of speler 2 bent...';
if (player_cond == 1)      %conditie 1 begint met block 1 = speler 1 eerst
    order_block = [1, 2];
    title_comp_choose{2} = 'Nu wissel je van rol. Je bent dus nu speler 2';
else                       %conditie 2 begint met block 2 = speler 2 eerst
    order_block = [2, 1];
    title_comp_choose{2} = 'Nu wissel je van rol. Je bent dus nu speler 1';
end
mf_log.condition = player_cond;
mf_log.orderblock = order_block;

%mf_log.block1isstartplayer = 1;
%mf_log.block2isstartplayer = 2;

for ind_block = 1 : 2   %do not change number of blocks, saving will go wrong
    block = order_block(ind_block);
    cur_block = 2 + ind_block;
    
    text_title = title_comp_choose{ind_block}; %'De computer bepaalt of je speler 1 of speler 2 bent...';
    do_choose = 1;
    
    if (mod(block,2) == 0)
        player_choice = 2;
        player1 = 'Andere kinderen';
        player2 = player_name;
        trustgame_comp_choose;
        trustgame_params_player2;
    else
        player_choice = 1;
        player1 = player_name;
        player2 = 'Andere kinderen';
        trustgame_comp_choose;
        trustgame_params_player1;
    end
    
    %mf_log.task_coin_count = [mf_log.task_coin_count; coin_count];
    %mf_log.task_params = [mf_log.task_params; params];
    %mf_log.task_names = [mf_log.task_names names];
    
    is_oefen_trial = 0;
    
    if (mod(block,2) == 0)
        trustgame_player2_trials;
    else
        trustgame_player1_trials;
    end
end

%--------------------------------------------------------------------------

[reward] = trustgame_calc_reward(subject_nr, age_nr);
text_instruction1 = 'De computer berekent nu je beloning...';
text_instruction2 = ['Je beloning is: ' num2str(reward, '%.2f') '\n\nJe bent nu klaar met dit spel.\nRoep nu de proefleider.'];
trustgame_reward;

%--------------------------------------------------------------------------

sca

trustgame_save_csv;

c_keyboard_listen(0);

%--------------------------------------------------------------------------


