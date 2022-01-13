
bSpace = 0;
bBack = 0;
bSkip = 0;
bContinue = 0;
bQuit = 0;
bRestartTrial = 0;


% Find keycodes for number keys. Use both keys on the numpad (= just the
% number') AND the ones above the normal keyboard (= numbers plus symbol).
numberKeysNumpad = cellfun( @(k) KbName(k), {'1', '2', '3', '4', '5', '6', '7', '8', '9'} );
numberKeysQwerty = cellfun( @(k) KbName(k), {'1!', '2@', '3#', '4$', '5%', '6^', '7&', '8*', '9('} );


[pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck(keyDevice);
if (~pressed)
    return
end

keys = find(firstPress);

if find(keys == KbName('q')) % q
    
    Screen('PlayMovie', video, 0);
    
    if ((vid_log_diode == 1) && (en_diode == 1))
        send_code(t_box_handle, 122);
        send_code(t_box_handle, 0);
    end
    mf_log.events(end+1,1:4) = [trial, 1, 0, GetSecs];
    
    if (show_diode_square == 1)
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
    end
    Screen('Flip', hwnd);
    if (exist('tex_pauze', 'var') == 1)
        Screen('DrawTexture', hwnd, tex_pauze, rsrc_pauze, [0 0  scrW scrH]);
        if (show_diode_square == 1)
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        end
        Screen('Flip', hwnd);
    end
    
    c_kbqueue_stop(keyDevice);
    c_kbqueue_destroy(keyDevice);
    disp(' ');
    bQuit = c_cmd_ask_yesno('<strong>Are you sure you want to quit the experiment?</strong>');
    bRestartTrial = ~bQuit;
    c_kbqueue_init(keyDevice);
    c_kbqueue_start(keyDevice);
    
    mf_log.events(end+1,1:4) = [trial, 2, bQuit, GetSecs];
	if (bQuit == 0)
        if ((vid_log_diode == 1) && (en_diode == 1))
            send_code(t_box_handle, 123);
            send_code(t_box_handle, 0);
        end
	end
	
	if (bQuit == 0)
        Screen('PlayMovie', video, 1);
	end
    
elseif find(keys == KbName('p')) %p
    %disp('Pause not available');
    
    Screen('PlayMovie', video, 0);
    
    if ((vid_log_diode == 1) && (en_diode == 1))
        send_code(t_box_handle, 124);
        send_code(t_box_handle, 0);
    end
    mf_log.events(end+1,1:4) = [trial, 3, 0, GetSecs];
    
    if (show_diode_square == 1)
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
    end
    Screen('Flip', hwnd);
    if (exist('tex_pauze', 'var') == 1)
        Screen('DrawTexture', hwnd, tex_pauze, rsrc_pauze, [0 0  scrW scrH]);
        if (show_diode_square == 1)
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        end
        Screen('Flip', hwnd);
    end
    
    disp('Paused, press "tab" to continue');
    pause on
    bPause = 1;
    while (bPause)
        pause(0.2);
        [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck(keyDevice);
        if (pressed)
            keys = find(firstPress);
            if find(keys == KbName('tab')) %tab
                bPause = 0;
            end
        end
    end
    pause off
    %video_file = [script_path '/stimuli/video/Aquarium 2hr relax music.mp4'];
    
    %video_file = [common_media_path 'Aquarium 2hr relax music.mp4'];
    %continue_on_key = 1;
    %vid_rec = [0 0 scrW scrH];
    %c_play_video;
    
    if ((vid_log_diode == 1) && (en_diode == 1))
        send_code(t_box_handle, 125);
        send_code(t_box_handle, 0);
    end
    mf_log.events(end+1,1:4) = [trial, 4, 0, GetSecs];
    
    Screen('PlayMovie', video, 1);
    bRestartTrial = 1;
    
elseif find(keys == KbName('v')) %v
    disp('Attention grabber video is not available');
    mf_log.events(end+1,1:4) = [trial, 5, 0, GetSecs];
    
elseif ~isempty(keys) && ( any(ismember( keys, numberKeysNumpad )) || any(ismember( keys, numberKeysQwerty )) ) % number keys 1 t/m 9
	
% 	soundToPlay = [ find( numberKeysNumpad == keys ), find( numberKeysQwerty == keys ) ];
% 	soundToPlay = soundToPlay(1);
%     
%     if ((vid_log_diode == 1) && (en_diode == 1))
%         send_code(t_box_handle, 120);
%         send_code(t_box_handle, 0);
%     end
%     
%     mf_log.events(end+1,1:4) = [trial, 6, soundToPlay, GetSecs];
%     if (soundToPlay <= length(aud_att))
%         PsychPortAudio('Start', aud_att{soundToPlay}, 1, 0, 0);
%     end
%     disp(['Playing attention grabber ' num2str(soundToPlay)]);
%     bRestartTrial = 1;
	disp( 'Audio attention grabbers are disabled for now during video playback. <strong>Please tell Mark</strong> that you saw this message!' );
	
else
    mf_log.events(end+1,1:4) = [trial, 99, 0, GetSecs];
end



