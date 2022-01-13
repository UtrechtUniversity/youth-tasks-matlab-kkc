
bSpace = 0;
bBack = 0;
bSkip = 0;
bContinue = 0;
bQuit = 0;
bRestartTrial = 0;


KbName('UnifyKeyNames');


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
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
    Screen('Flip', hwnd);
    
    if (en_diode == 1)
        send_code(t_box_handle, 122);
        send_code(t_box_handle, 0);
    end
    
    c_kbqueue_stop(keyDevice);
    c_kbqueue_destroy(keyDevice);
    disp(' ');
    bQuit = c_cmd_ask_yesno('<strong>Are you sure you want to quit the experiment?</strong>');
    bRestartTrial = ~bQuit;
    c_kbqueue_init(keyDevice);
    c_kbqueue_start(keyDevice);
    
    if (bQuit == 0)
        if (en_diode == 1)
            send_code(t_box_handle, 123);
            send_code(t_box_handle, 0);
        end
    end
    
%elseif find(keys == KbName('s')) %s
%    disp('Skipping current trial');
%    bSkip = 1;
elseif find(keys == KbName('t')) %t
    bBack = 1;
elseif find(keys == KbName('tab')) %tab
    bContinue = 1;
elseif find(keys == KbName('space')) %space
    bSpace = 1;
    
elseif find(keys == KbName('p')) %p
    %disp('Pause not available');
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
    Screen('Flip', hwnd);
    
    if (en_diode == 1)
        send_code(t_box_handle, 124);
        send_code(t_box_handle, 0);
    end
    
    disp('Paused, press "tab" to continue');
    %pause on
    %bPause = 1;
    %while (bPause)
    %    pause(0.2);
    %    [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck(keyDevice);
    %    if (pressed)
    %        keys = find(firstPress);
    %        if find(keys == KbName('tab')) %tab
    %            bPause = 0;
    %        end
    %    end
    %end
    %pause off
    %video_file = [script_path '/stimuli/video/Aquarium 2hr relax music.mp4'];
    video_file = [common_media_path 'Aquarium 2hr relax music.mp4'];
    continue_on_key = 1;
    vid_rec = [0 0 scrW scrH];
    c_play_video;
	emotionalface_loadsoundbuffers;
    
    if (en_diode == 1)
        send_code(t_box_handle, 125);
        send_code(t_box_handle, 0);
    end
    
    bRestartTrial = 1;
    
elseif find(keys == KbName('v')) % v
    emotionalface_attvid;
    
elseif ~isempty(keys) && ( any(ismember( keys, numberKeysNumpad )) || any(ismember( keys, numberKeysQwerty )) ) % number keys 1 t/m 9
	% Only keep keys that are a number on either the keypad or the Querty part.
	keys = [intersect( keys, numberKeysQwerty ), intersect( keys, numberKeysNumpad )];
	
	% If there are more keys pressed simultaneously, pick the first one.
	keys = keys(1);
	
    soundToPlay = [ find( numberKeysNumpad == keys ), find( numberKeysQwerty == keys ) ];
	soundToPlay = soundToPlay(1);
    
    if (en_diode == 1)
        send_code(t_box_handle, 120);
        send_code(t_box_handle, 0);
    end
    
    if (soundToPlay <= length(aud_att))
        PsychPortAudio('Start', aud_att{soundToPlay}, 1, 0, 0);
    end
    disp(['Playing attention grabber ' num2str(soundToPlay)]);
    bRestartTrial = 1;
    
end



