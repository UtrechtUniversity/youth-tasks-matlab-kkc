

[keyDevice, barcodeKB] = c_find_keyboards();

[fileID, mf_log] = prosocial_make_logfile(logpath, logtag);

%--------------------------------------------------------------------------

c_init;
c_default_keys;

[hwnd, fps, scrW, scrH] = c_setup_screen(0, [255 255 255], 0);
fps = 60;
c_make_colors(hwnd);

c_keyboard_listen(2);

%--- Load Pictures --------------------------------------------------------

rec_center = [scrW/2, scrH/2, scrW/2, scrH/2];
prosocial_load_images;

[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);

%--------------------------------------------------------------------------

title_rec = [0, 0, 32, 32];
c_init_instruction;

font_size_instruction = 18;
wrap_chars_instruction = 1.6 * (4*scrW/6) / font_size_instruction;

%--------------------------------------------------------------------------

prosocial_rec_init;

%--------------------------------------------------------------------------

text_instruction = ['Welkom bij Cyberball.\n\n' ...
                    'Dit is een computerspel waarbij je een bal gaat overgooien.\n\n' ....
                    'Als je de bal krijgt, kun je de bal naar een andere speler gooien.\n' ...
                    'Druk op "1" om de bal naar speler 1 te gooien.\n' ...
                    'Druk op "2" om de bal naar speler 2 te gooien.\n' ...
                    'Druk op "3" om de bal naar speler 3 te gooien.\n' ...
                    'Je mag zelf kiezen naar wie je gooit.\n\n' ...
                    'Probeer je voor te stellen dat je het spel echt speelt. Hoe zien de andere spelers eruit?  Waar ben je aan het spelen? Is het warm? Of is het koud en regent het?\n\n\n' ...
                    'Druk op spatie om verder te gaan'];
prosocial_instruction;

text_instruction = ['Je gaat de taak nu eerst even oefenen.\n\n' ...
                    'Ben je er klaar voor?\n\n\n' ...
                    'Druk op spatie om te beginnen'];
prosocial_instruction;

%--------------------------------------------------------------------------

bPractice = 1;
while (bPractice)
    prosocial_practice;
    
    text_instruction = ['Begrijp je het?\n\n' ...
                        'Wil je het nog eens proberen druk dan op "p"\n' ...
                        'Om te beginnen met het spel druk dan op spatie.'];
    prosocial_instruction;
    bPractice = bRepeat;
end
%--------------------------------------------------------------------------

ballang = 0;
jitter = [1000 1500 2000] * 60/1000;
view_target = [3, 4, 1, 2];

txt_clr = 0;

blocks = [48, 0; 20, 1; 48, 1];
n_blocks = 3;

cur_target = 1;

for b = 1 : n_blocks;
    
    counter = zeros(4,4);
    
    trials = blocks(b, 1);
    do_exclude = blocks(b, 2);
    
    cur_jit = Shuffle(repmat(jitter, 1, ceil(trials/length(jitter))));
    
    time_zero = 0;
    time_react = 0;
    
    cur_player = cur_target;
    if (cur_target == 2)
        cur_target = 3;
    else
        cur_target = 2;
    end
    time_zero = GetSecs;
    prosocial_first_frame;
    cur_target = cur_player;
    new_target = -1;
    
    for i = 1 : trials
        cur_player = cur_target;
        if (cur_player ~= 2)
            prosocial_comp_target;
        else
            if (new_target ~= -1)
                cur_target = new_target;
                new_target = -1;
            else
                prosocial_user_target;
            end
        end
        counter(cur_player,cur_target) = counter(cur_player,cur_target) + 1;
        
        prosocial_save_trial(fileID, mf_log, b, i, cur_player, cur_target, time_react);
        
        prosocial_anim;
        prosocial_draw_jitter;
    end
    
end

fclose(fileID);

%--------------------------------------------------------------------------

disp('<strong>All done and all saved</strong>');
text_instruction = ['Dit is het einde van de taak\n\n' ...
                    'Bedankt voor het meedoen'];
c_endmsg_locked_img(hwnd, 1, black, 28, 0, text_instruction, 0, []);
sca;

c_keyboard_listen(0);



