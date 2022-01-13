%clc; clear; close all

commandwindow;

[cur_script_path, cur_script_name, cur_script_ext] = fileparts(mfilename('fullpath'));
%cd(script_path)
%addpath([script_path '/../COMMON'])
%addpath([script_path '/../COMMON/photodiode'])

[keyDevice, barcodeKB] = c_find_keyboards();


cbalance = R0_counter_restingstate; % mod(subject_nr, 2);

%--------------------------------------------------------------------------


% Open master audio handle. For the playback of the individual attention
% grabbers, 'slaves' are opened from this master.
global hAudioMaster
hAudioMaster = PsychPortAudio( 'Open', [], 1+8 );
PsychPortAudio('Start', hAudioMaster, 0, 0, 1);


global color_calib;
color_calib = 1;

backcolor = color_calib * [131 131 131]; %[0 0 0]; %
diodesize = 75;
time_out_secs = 10;

if (exist('en_diode', 'var') ~= 1)
    en_diode = 1;
end

restingstate_makelogfile;

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

[hwnd, fps, scrW, scrH] = c_setup_screen(1, backcolor, 0);
c_make_colors(hwnd);
fps = 60;

%--- LOAD IMAGES ----------------------------------------------------------

[tex_pauze rsrc_pauze] = c_load_image([common_media_path 'pauzescreen.jpg'], hwnd);

[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);


%--- SHOW SAILBOAT AND CAPPING MOVIES -------------------------------------
c_kkc_show_sailboat_and_cappingmovies;


%--- LOAD AUDIO -----------------------------------------------------------
disp('Loading audio...');
restingstate_loadsoundbuffers;

%--- AUDIO BUFFERS --------------------------------------------------------
%disp('Creating audio buffers...')

%aud_att = cell(1, length(snd_att));
%for i = 1 : length(snd_att)
%    aud_att{i} = PsychPortAudio('Open', [], [], 0, fs_att(i), nchan_att(i));
%    PsychPortAudio('FillBuffer', aud_att{i}, snd_att{i}');
%end

%--- ATT VIDEOS -----------------------------------------------------------

disp('Loading video...');

[att_vids] = c_kkc_load_attention_video();

% att_vids = cell(1, 8);
% att_vids{1} = [common_media_path '/babytv1.mp4'];
% att_vids{2} = [common_media_path '/babytv2.mp4'];
% att_vids{3} = [common_media_path '/babytv3.mp4'];
% att_vids{4} = [common_media_path '/bumba2.mp4'];
% att_vids{5} = [common_media_path '/bumba3.mp4'];
% att_vids{6} = [common_media_path '/bumba4.mp4'];
% att_vids{7} = [common_media_path '/bumba5.mp4'];
% att_vids{8} = [common_media_path '/bumba6.mp4'];
att_last_vid = 0;

%--------------------------------------------------------------------------

%if (en_diode == 1)
%    send_code(t_box_handle, 1);
%    send_code(t_box_handle, 0);
%end

startstop_code = 250; % 254;
c_diode_startstop_code;
[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, startstop_code);
onset_startcode = int64(GetSecs * 1000000);
mf_log.onset_startcode = onset_startcode;

continue_on_key = 1;
%video_file = [script_path '/stimuli/video/Aquarium 2hr relax music.mp4'];
video_file = [common_media_path 'Aquarium 2hr relax music.mp4'];
disp('<strong>Press tab to start the task</strong>');
show_diode_square = 1;
c_play_video;
restingstate_loadsoundbuffers;

%--------------------------------------------------------------------------

% Start video recording.
c_vid_trig_startvideorecording;

%--------------------------------------------------------------------------

disp('Initializing keyboard...')
c_kbqueue_init(keyDevice);
c_kbqueue_start(keyDevice);

%--------------------------------------------------------------------------
bQuit = 0;
for trial = 1 : 6
    
    if (mod(trial,2) == 1)
        block = 1 + floor(trial / 2);
        disp(['Block ' num2str(block)]);
        %curcode = 20 + block;
        %if (en_diode == 1)
        %    send_code(t_box_handle, curcode);
        %    send_code(t_box_handle, 0);
        %end
        %[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, curcode);
        %[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
    end
    
    disp(['Starting trial ' num2str(trial)]);
    
    trial_type = mod(cbalance+trial, 2);
    
    curcode = 129 + 10 * trial_type; % + 1) + trial;
    if (en_diode == 1)
        send_code(t_box_handle, curcode);
        %send_code(t_box_handle, 0);
    end
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, curcode);
    %[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
    
    T = GetSecs;
    mf_log.trials(end+1,1:4) = [trial, block, trial_type, T];
    
    if (trial_type == 1)
        continue_on_key = 0;
        att_keycheck = 1;
        vid_log_diode = 1;
        show_diode_square = 1;
        trigger_diode = 1;
        video_file = [media_path 'restingstate/video/SOCIAL_NL.mp4']; %[cur_script_path '/stimuli/video/SOCIAL_NL.mp4'];
        c_play_video;
		restingstate_loadsoundbuffers;
    else
        continue_on_key = 0;
        att_keycheck = 1;
        vid_log_diode = 1;
        show_diode_square = 1;
        trigger_diode = 1;
        video_file = [media_path 'restingstate/video/TOY_EN.mp4']; %[cur_script_path '/stimuli/video/TOY_EN.mp4'];
        %video_file = [cur_script_path '/stimuli/video/SOCIAL_NL.mp4']; %TODO !!!! enable correct one !!!!
        c_play_video;
		restingstate_loadsoundbuffers;
    end
    
    if (en_diode == 1)
        wait_for_code_back(t_box_handle, time_out_secs, curcode);
        send_code(t_box_handle, 0);
    end
    
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
    
    if (bQuit == 1)
        break;
    end
end

%--------------------------------------------------------------------------

%if (en_diode == 1)
%    send_code(t_box_handle, 2);
%    send_code(t_box_handle, 0);
%end

startstop_code = 251; % 255;
c_diode_startstop_code;
[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, startstop_code);
onset_stopcode = int64(GetSecs * 1000000);
mf_log.onset_stopcode = onset_stopcode;

if (en_diode == 1)
    close_photodiode(t_box_handle);
end
%c_vid_trig_close;

% Close audio master.
PsychPortAudio( 'Close', hAudioMaster );

c_kbqueue_stop(keyDevice);
c_kbqueue_destroy(keyDevice);

c_vid_trig_close;


%--------------------------------------------------------------------------

disp('<strong>All done and all saved</strong>');
disp('<strong>Please stop the biosemi recording and close biosemi</strong>');
text_instruction = ['Dit is het einde van de taak\n\n' ...
                    'Bedankt voor het meedoen'];
c_endmsg_locked_img(hwnd, 1, black, 28, 0, text_instruction, 1, diodesize);


sca;



