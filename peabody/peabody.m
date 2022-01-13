

[keyDevice, barcodeKB] = c_find_keyboards();

peabody_init;
peabody_get_instapset;
if (age_calc_ok == 0)
    return;
end
peabody_load_words;
peabody_load_audio;

[mf_log] = peabody_make_logfile(logpath, logtag, instap);

%--------------------------------------------------------------------------

c_init;
bgColor = [255, 255, 255];
%c_setup_screen;
[hwnd, fps, scrW, scrH] = c_setup_screen(0, bgColor, 0);
fps = 60;
c_make_colors(hwnd);

if (task_type == 2)
    HideCursor;
end

c_keyboard_listen(2);

%--------------------------------------------------------------------------

title_rec = [0, 0, 32, 32];
c_init_instruction;
font_size_instruction = 18;
wrap_chars_instruction = 1.6 * (4*scrW/6) / font_size_instruction;

paebody_rec_init;
paebody_load_images;

%--- common images --------------------------------------------------------

[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);

%--------------------------------------------------------------------------

c_default_keys;

%--------------------------------------------------------------------------

clr_img_bg = [255, 255, 255]; %[ 247, 236, 208];
%clr_mod = [51, 70, 191];
%--------------------------------------------------------------------------

bQuit = 0;
if (task_type == 2)
    peabody_example_y3_1;
    if (bQuit == 0)
        peabody_example_y3_2;
    end
else
    peabody_example_y9_1;
    peabody_example_y9_2;
end

%--------------------------------------------------------------------------


stage = 1;  %1=zoek start; %2=zoek eind
afbreek_found = 0;

result = -1 * ones(size(M));
reacts = -1 * ones(size(M));

curset = instap;

if (bQuit == 0)
    while ((curset >= 1) && (curset <= length(ages)))
        
        disp(sprintf('set %d', curset))
        
        goed = 0;
        fout = 0;
        for i = 1 : 12
            answer = -1;
            selImg = -1;
            
            ind = (curset-1)*12 + i;
            player = audioplayer(audio_main{1,ind}, fs_main(1,ind));
            player2 = audioplayer(audio_main{2,ind}, fs_main(2,ind));
            bPlayedTwice = 0;
            bSelSound = 0;
            bEnableScnd = 0;
            
            %------------------------------------------------------------------
            
            if (task_type == 2)
                peabody_trial_y3;
            else
                peabody_trial_y9;
            end
            
            %------------------------------------------------------------------
            
            %disp(sprintf('plaatje %d', M(i,curset)))
            %answer = input('welk plaatje? ');
            
            if (bQuit == 1)
                break;
            end
            
            if (answer == M(i,curset))
                goed = goed + 1;
                result(i,curset) = 1;
            else
                fout = fout + 1;
                result(i,curset) = 0;
            end
            reacts(i,curset) = curreact;
        end
        
        if (bQuit == 1)
            break;
        end
        
        if (stage == 1)
            if (fout >= 5)
                curset = curset - 1;
                if (fout >= 9)
                    afbreek_found = 1;
                end
                if (curset == 0)
                    curset = instap + 1;
                    stage = 2;
                end
            else
                curset = instap + 1;
                stage = 2;
            end
            if ((stage == 2) && (afbreek_found == 1))
                break
            end
        else
            if (fout >= 9)
                break
            else
                curset = curset + 1;
                if (curset > length(ages))
                    break
                end
            end
        end
        
        if (task_type == 2)
            text_instruction = ['Druk op SPATIE om door te gaan'];
            use_mouse = 0;
        else
            text_instruction = ['Klik op OK om door te gaan'];
            use_mouse = 1;
        end
        c_instruction(hwnd, scrInd, use_mouse, 0, rec_btn_ok, rec_btn_ok_text, font_size_instruction, font_color_instruction, wrap_chars_instruction, text_instruction);
    end
end

% The start set is the first set without any -1.
start = max( 1, find( ~any(result == -1, 1), 1, 'first' ) );

% The afbreekset is the last set without any -1.
afbreek = min( size(result, 2), find( ~any(result == -1, 1), 1, 'last' ) );

% Calculate the number of finished sets (that is, sets without any -1).
nrFinishedSets = sum( ~any(result == -1, 1) );

% Calculate the number of errors. Only take into account the sets from
% 'startset' to 'afbreekset'.
if nrFinishedSets > 0
    fouten      = sum(sum(result(:, start:afbreek) == 0));
    afbreekitem = 12 * afbreek;
    ruwe_score  = afbreekitem - fouten;
else
    start       = -999;
    fouten      = -999;
    afbreek     = -999;
    afbreekitem = -999;
    ruwe_score  = -999;
end

%--------------------------------------------------------------------------

mf_log.result = result;
mf_log.reacts = reacts;

mf_log.start = start;
mf_log.afbreek = afbreek;
mf_log.fouten = fouten;
mf_log.afbreekitem = afbreekitem;
mf_log.ruwe_score = ruwe_score;

%--------------------------------------------------------------------------

csvM = [subject_nr Wave start instap afbreek afbreekitem fouten ruwe_score];

lbl = cell(1,8);
j=0;
j=j+1; lbl{j} = 'pseudocode';
j=j+1; lbl{j} = 'wave';
j=j+1; lbl{j} = 'start set';
j=j+1; lbl{j} = 'instap set';
j=j+1; lbl{j} = 'afbreek set';
j=j+1; lbl{j} = 'afbreek item';
j=j+1; lbl{j} = 'fouten';
j=j+1; lbl{j} = 'ruwe score';

csvfile = [logpath logtag '.csv'];
write_csv(csvfile, lbl, csvM);

%--------------------------------------------------------------------------

csvM = [result reacts];

lbl = cell(1,34);
j=0;
for i = 1 : 17
    j=j+1; lbl{j} = ['results_set_' num2str(i)];
end
for i = 1 : 17
    j=j+1; lbl{j} = ['rtime_set_' num2str(i)];
end

csvfile = [logpath logtag '_answers.csv'];
write_csv(csvfile, lbl, csvM);

%-------------------------------------------

ShowCursor;

%bMsgLock = 1;
%c_end_task;

disp('<strong>All done and all saved</strong>');
text_instruction = ['Dit is het einde van de taak\n\n' ...
    'Bedankt voor het meedoen'];
c_endmsg_locked_img(hwnd, 1, black, 28, 0, text_instruction, 0, []);
sca;


disp('klaar')
disp(sprintf('score: %d', ruwe_score))

c_keyboard_listen(0);


%-------------------------------





