%clc; clear; close all

%commandwindow;

%[script_path, script_name, script_ext] = fileparts(mfilename('fullpath'));
%cd(script_path)
%addpath([script_path '/../COMMON'])

%--------------------------------------------------------------------------

[keyDevice, barcodeKB] = c_find_keyboards();
[buttonKB] = c_find_redbutton();


% Open master audio handle. For the playback of the individual attention
% grabbers, 'slaves' are opened from this master.
global hAudioMaster
hAudioMaster = PsychPortAudio( 'Open', [], 1+8 );
PsychPortAudio('Start', hAudioMaster, 0, 0, 1);


global color_calib;
color_calib = 1;

backcolor = color_calib * [108 108 108];
diodesize = 75;
fixcross  = 24;
fixwidth  = 5;

stimtime  = 1;
ISI_min   = 0.7;
ISI_max   = 1;

time_out_secs = 10;

if (exist('en_diode', 'var') ~= 1)
    en_diode = 1;
end

task_button = bitand(task_type-1, 2) / 2;
show_button = 0;

%--------------------------------------------------------------------------

if (en_diode == 1)
    diode_ok = 0;
    while (diode_ok == 0)
        try
            t_box_handle = init_photodiode();
            diode_ok = 1;
        catch exp_diode
            disp('<strong>The photodiode was not found, please check if it is plugged in.</strong>');
            exp_diode_cont = c_cmd_ask_yesno('Do you want to retry?');
            if (exp_diode_cont == 0)
                return;
            end
        end
    end
end

[vt_enabled, tcpc, vt_cmd, vt_settings] = c_vid_trig_init(vt_enabled);
c_vid_trig_start;

%--------------------------------------------------------------------------

c_default_keys;

if (eeg_autopilot == 0)
    [hwnd, fps, scrW, scrH] = c_setup_screen(1, backcolor, 0);
end
c_make_colors(hwnd);
fps = 60;

%--- COMMON TEXTURES ------------------------------------------------------

[tex_isi, rsrc_isi] = c_load_image([media_path 'emotionalface/ISI.bmp'], hwnd);
[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);


%--- SHOW SAILBOAT AND CAPPING MOVIES -------------------------------------
if (eeg_autopilot == 0)
	c_kkc_show_sailboat_and_cappingmovies;
end


%--- LOAD AUDIO -----------------------------------------------------------
disp('Loading audio...');
emotionalface_loadsoundbuffers;


%--- ATT VIDEOS -----------------------------------------------------------
disp('Loading video...');
[att_vids] = c_kkc_load_attention_video();
att_last_vid = 0;

%--------------------------------------------------------------------------

if (eeg_autopilot == 0)
    %video_file = [script_path '/stimuli/video/Vera de Bree - Dikkie Dik.mp4'];
    %video_file = [script_path '/stimuli/video/Aquarium 2hr relax music.mp4'];
    video_file = [common_media_path 'Aquarium 2hr relax music.mp4'];
    continue_on_key = 1;
    disp('<strong>Press tab to start the task</strong>');
    c_play_video;
end
emotionalface_loadsoundbuffers;

%--------------------------------------------------------------------------

% Start video recording.
c_vid_trig_startvideorecording;

%--------------------------------------------------------------------------

disp('Initializing keyboard...')
c_kbqueue_init(keyDevice);
c_kbqueue_start(keyDevice);
if (task_button == 1)
    KbQueueCreate(buttonKB);
    KbQueueStart(buttonKB);
end

%ListenChar(0);
%KbQueueCreate(barcodeKB);
%KbQueueStart(barcodeKB);
%KbQueueCreate(keyDevice);
%KbQueueStart(keyDevice);
%warning('off','all');
%ListenChar(2);
%warning('on','all');



%--------------------------------------------------------------------------

%if (Wave == 5)
%    task_types = [1];
%else
%    task_types = [1 2];
%end

%for task_ind = 1 : length(task_types)

    
    task = 1 + bitand(task_type-1, 1); % task_types(task_ind);
    
    if (task_button == 1)
        n_ball = 10;
        tex_ball = cell(1, n_ball);
        rsrc_ball = cell(1, n_ball);
        
        for i = 1 : n_ball
            %[tex_ball{i}, rsrc_ball{i}] = c_load_image_grayalpha([media_path 'emotionalface/imgball/ball' num2str(i) '.png'], hwnd, 70, 82);
            [tex_ball{i}, rsrc_ball{i}] = c_load_image([media_path 'emotionalface/imgball/ball' num2str(i) '.png'], hwnd);
        end
        
        ball_order = Shuffle(1:n_ball);
        ball_ind = 1;
    end
    
    if (task == 1)
        blocks = 1;
        
        conditions = [3];
        n_pics_per_cond = [6 6 12];
        n_cond = prod(conditions);
        %n_stim = n_pics_per_cond * n_cond;
        n_stim = 24;
        
        %--------------------------------------------------------------------------
        
        tex_stim = cell(1, n_stim);
        rsrc_stim = cell(1, n_stim);
        
        for i = 1 : 6
            [tex_stim{i}, rsrc_stim{i}] = c_load_image([media_path 'emotionalface/F' num2str(i) '_n.jpg'], hwnd);
        end
        for i = 1 : 6
            [tex_stim{6+i}, rsrc_stim{6+i}] = c_load_image([media_path 'emotionalface/M' num2str(i) '_n.jpg'], hwnd);
        end
        for i = 1 : 12
            [tex_stim{12+i}, rsrc_stim{12+i}] = c_load_image([media_path 'emotionalface/H' num2str(i,'%02i') '.jpg'], hwnd);
        end
        %--------------------------------------------------------------------------
    else
        blocks = 1;
        
        conditions = [2 2];
        n_pics_per_cond = [6 6 6 6];
        n_cond = prod(conditions);
        n_stim = 24;
        
        tex_stim = cell(1, n_stim);
        rsrc_stim = cell(1, n_stim);
        
        for i = 1 : 6
            [tex_stim{i}, rsrc_stim{i}] = c_load_image([media_path 'emotionalface/F' num2str(i) '_h.jpg'], hwnd);
        end
        for i = 1 : 6
            [tex_stim{6+i}, rsrc_stim{6+i}] = c_load_image([media_path 'emotionalface/F' num2str(i) '_f.jpg'], hwnd);
        end
        for i = 1 : 6
            [tex_stim{12+i}, rsrc_stim{12+i}] = c_load_image([media_path 'emotionalface/M' num2str(i) '_h.jpg'], hwnd);
        end
        for i = 1 : 6
            [tex_stim{18+i}, rsrc_stim{18+i}] = c_load_image([media_path 'emotionalface/M' num2str(i) '_f.jpg'], hwnd);
        end
    end
    
    n_rep = 4;
    n_trials = n_stim * n_rep;
    
    cn = length(conditions);
    comb = zeros(cn, n_cond);
    cons = sort(conditions, 'descend');
    for i = 1 : cn
        cmax = prod(cons(1:i-1));
        for j = 1 : n_cond
            comb(i,j) = mod(floor((j-1)/cmax), cons(i)) + 1;
        end
    end
    
    seq = c_randomise_conditions(comb, n_rep*n_pics_per_cond);
    
    ipics = cell(1, n_cond);
    npics = 0;
    for i = 1 : n_cond
        %ipics{i} = npics + randperm(n_pics_per_cond(i));
        ipics{i} = npics + randperm_norep(n_pics_per_cond(i), n_rep);
        %ipics{i} = npics + Shuffle(repmat(1 : n_pics_per_cond(i), 1, n_rep));
        npics = npics + n_pics_per_cond(i);
    end
    
    %ipics = reshape(1:n_stim, n_cond, n_pics_per_cond);
    %ipics = Shuffle(ipics')';
    curpic = ones(1, n_cond);
    order = zeros(1, length(seq)); %n_stim);
    tmp_cnt = zeros(1, npics);
    rep_cnt = zeros(1, length(seq)); %length(ipics));
    for i = 1 : length(seq)
        order(i) = ipics{seq(i)}(curpic(seq(i)));
        rep_cnt(i) = tmp_cnt(order(i));
        tmp_cnt(order(i)) = tmp_cnt(order(i)) + 1;
        curpic(seq(i)) = curpic(seq(i)) + 1;
    end
    
    cond_row_fmh = 1;
    cond_row_fm = 2;
    cond_row_hf = 1;
    
    cond_val_female = 1;
    cond_val_male = 2;
    cond_val_house = 3;
    cond_val_happy = 1;
    cond_val_fear = 2;
    
    
    pic_ind = order;
    pic_ind(pic_ind > 6) = pic_ind(pic_ind > 6) - 6;
    pic_ind(pic_ind > 6) = pic_ind(pic_ind > 6) - 6;
    if (task ~= 1)
        pic_ind(pic_ind > 6) = pic_ind(pic_ind > 6) - 6;
    end
    
    lstCodes = 130 + (pic_ind - 1) * 10;
    
    %if (task == 1)
    %    lstCodes = 128 + 4 * comb + 3;
    %else
    %    lstCodes = 128 + sum(repmat([1; 4], 1, n_cond) .* comb, 1);
    %end
    
    %--------------------------------------------------------------------------
    
    [tex_oefen_intro, rsrc_oefen_intro] = c_load_image([media_path 'emotionalface/oefen/facehouseintroscherm.png'], hwnd);
    
    [tex_oefen_ball, rsrc_oefen_ball] = c_load_image([media_path 'emotionalface/oefen/example_ball.png'], hwnd);
    
    tex_oefen_stim = cell(1, 7);
    rsrc_oefen_stim = cell(1, 7);
    
    for i = 1 : 4
        [tex_oefen_stim{i}, rsrc_oefen_stim{i}] = c_load_image([media_path 'emotionalface/oefen/example_f' num2str(i) '.png'], hwnd);
    end
    for i = 1 : 3
        [tex_oefen_stim{i+4}, rsrc_oefen_stim{i+4}] = c_load_image([media_path 'emotionalface/oefen/example_h' num2str(i) '.png'], hwnd);
    end
    
%     r_oefen_f = randperm(4);
%     r_oefen_h = 4+randperm(3);
%     order_oefen = [r_oefen_h(1) r_oefen_f(1) r_oefen_h(2) r_oefen_f(2) r_oefen_f(3) r_oefen_h(3)];
    
    %--------------------------------------------------------------------------
    
    ISI = round(fps*ISI_min) : round(fps*ISI_max);
    ISI = repmat(ISI, 1, ceil(n_rep * n_stim / length(ISI)));
    ISI = Shuffle(ISI);
    
    %--------------------------------------------------------------------------
    
    emotionalface_save;
    
    %--------------------------------------------------------------------------
    
    onsets_stim = -1 * ones(blocks, n_trials);
    onsets_isi = -1 * ones(blocks, n_trials);
    
    react_times_button = [];
    
    bQuit = 0;
    
    %if (task == 1)
        startstop_code = 250;
    %else
    %    startstop_code = 252;
    %end
    c_diode_startstop_code;
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, startstop_code);
    onset_startcode = int64(GetSecs * 1000000);
    mf_log.onset_startcode = onset_startcode;
    
    
    if (task_button == 1)
        if (task_type == 3)
            emotionalface_oefen;
        else
            %show_button = 1;
            %emotionalface_attvid;
            %show_button = 1;
            %emotionalface_attvid;
        end
    end
    practice = 0;
    
    for i = 1 : blocks
        
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        
        % disp ISI + black square
        for h = 1 : ISI(1)
            Screen('FillRect', hwnd, backcolor);
            Screen('DrawTexture', hwnd, tex_isi);
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
            Screen('Flip', hwnd);
        end
        
        [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
        
        for j = 1 : n_trials
            
            if ((j > 1) && (mod(j,24) == 1))
                show_button = task_button;
                emotionalface_attvid;
            end
            
            
            trialok = 0;
            while (trialok == 0)
                
                bRestartTrial = 0;
                emotionalface_keycheck;
                if (bQuit == 1)
                    break;
                end
                
                trialok = 0;
                if (bRestartTrial == 0)
                    trialok = 1;
                    
                    disp(['Starting trial: ' num2str(j)]);
                    
                    cur_ind = order(j);
                    if (task == 1)
                        cur_hfn = 0;
                        cur_fmh = comb(cond_row_fmh, seq(j));
                    else
                        cur_hfn = comb(cond_row_hf, seq(j));
                        cur_fmh = comb(cond_row_fm, seq(j));
                    end
                    
                    cur_code = lstCodes(j) + 3 * cur_hfn + cur_fmh;
                    if (en_diode == 1)
                        send_code(t_box_handle, j);
                        send_code(t_box_handle, 0);
                        %send_code(t_box_handle, codes_hl(cur_hl));
                        %send_code(t_box_handle, codes_fn(cur_fn));
                        %cur_rep = rep_cnt(j);
                        %cur_code = lstCodes(seq(j)) + 3 * cur_hfn + cur_fmh;  %16 * cur_rep;
                        send_code(t_box_handle, cur_code);
                        %if (task == 1)
                        %    send_code(t_box_handle, 192 + cur_ind);
                        %else
                        %    send_code(t_box_handle, 192 + 24 + cur_ind);
                        %end
                    end
                    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, j);
                    %[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
                    %[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, cur_code);
                    
                    
                    %--- SEND TRIAL NUMMER AND RESET CODE TO BIOSEMI ------------------
                    %220 FEARFUL HIGH SF
                    %210 FEARFUL LOW SF
                    %240 NEUTRAL HIGH SF
                    %230 NEUTRAL LOW SF
                    %250 HAPPY HIGH SF
                    %200 HAPPY LOW SF
                    %lstCodes = [220 210 240 230]; %250 200];
                    %iCode = lstCodes(mod(order(j),5));
                    %send_code(t_box_handle,j);
                    %send_code(t_box_handle,0);
                    %send_code(t_box_handle,iCode);
                    %------------------------------------------------------------------
                    
                    
                    % display stimulus + white square
                    for h = 1 : stimtime * fps
                        Screen('FillRect', hwnd, backcolor);
                        Screen('DrawTexture', hwnd, tex_stim{cur_ind});
                        Screen('FillRect', hwnd, [255 255 255], [0 0 diodesize diodesize]);
                        %Screen('DrawLine', hwnd, [255 0 0], scrW/2, scrH/2-fixcross/2, scrW/2, scrH/2+fixcross/2, fixwidth);
                        %Screen('DrawLine', hwnd, [255 0 0], scrW/2-fixcross/2, scrH/2, scrW/2+fixcross/2, scrH/2, fixwidth);
                        
                        if h == 1
                            [StartFlip,~,EndFlip] = Screen('Flip', hwnd);
                            onsets_stim(i, j) = int64(StartFlip * 1000000);
                        else
                            Screen('Flip', hwnd);
                        end
                    end
                    
                end
                
                % disp ISI + black square
                for h = 1 : ISI(j)
                    Screen('FillRect', hwnd, backcolor);
                    Screen('DrawTexture', hwnd, tex_isi);
                    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
                    
                    if h == 1 % FIRST FLIP OF EACH ISI
                        [StartFlip,~,EndFlip] = Screen('Flip', hwnd);
                        onsets_isi(i, j) = int64(StartFlip * 1000000);
                        
                        if ((en_diode == 1) && (bRestartTrial == 0))
                            wait_for_code_back(t_box_handle, time_out_secs, cur_code);
                            send_code(t_box_handle, 0);
                        end
                        if (bRestartTrial == 0)
                            [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
                        end
                    else
                        Screen('Flip', hwnd);
                    end
                end
            end
            
            if (bQuit == 1)
                break;
            end
        end
        
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        Screen('FillRect', hwnd, 127);
        Screen('Flip', hwnd);
        
        if (bQuit == 1)
            break;
        end
    end
    
    if ((task_button == 1) && (bQuit == 0))
        show_button = 1;
        emotionalface_attvid;
    end
    
    mf_log.onsets_stim = onsets_stim;
    mf_log.onsets_isi = onsets_isi;
    mf_log.reacts_button = react_times_button;
    
%--------------------------------------------------------------------------

%if (task == 1)
    startstop_code = 251;
%else
%    startstop_code = 253;
%end
c_diode_startstop_code;
[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, startstop_code);
onset_stopcode = int64(GetSecs * 1000000);
mf_log.onset_stopcode = onset_stopcode;

%if (bQuit == 1)
%    break;
%end

if (en_diode == 1)
    close_photodiode(t_box_handle);
end
%c_vid_trig_close;


% Close audio master.
PsychPortAudio( 'Close', hAudioMaster );


if (task_button == 1)
    KbQueueStop(buttonKB);
    KbQueueFlush(buttonKB);
    KbQueueRelease(buttonKB);
end
if ((task_button == 0) || (buttonKB ~= -1))
    c_kbqueue_stop(keyDevice);
    c_kbqueue_destroy(keyDevice);
else
    ListenChar(0);
end

%--------------------------------------------------------------------------

%run face emo after face house if...
%rondom 0 and wave is 10 months (not 5 months) (tasktype = 1)
%OR rondom 3 any wave (task_type = 3)
if (((task_type == 1) && (age_nr ~= 5)) || (task_type == 3))
    skip_eeg_user_interaction = 1;
    auto_select_next_task = 2;
end

%--------------------------------------------------------------------------

disp('<strong>All done and all saved</strong>');

c_vid_trig_close;

if (skip_eeg_user_interaction == 0)
    disp('<strong>Please stop the biosemi recording and close biosemi</strong>');
    text_instruction = ['Dit is het einde van de taak\n\n' ...
                        'Bedankt voor het meedoen'];
    c_endmsg_locked_img(hwnd, 1, black, 28, 0, text_instruction, 1, diodesize);
end

if (skip_eeg_user_interaction == 0)
    sca;
end
