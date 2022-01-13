
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

if find(keys == KbName('q')) %q
    c_kbqueue_stop(keyDevice);
    c_kbqueue_destroy(keyDevice);
    disp(' ');
    bQuit = c_cmd_ask_yesno('<strong>Are you sure you want to quit the experiment?</strong>');
    bRestartTrial = ~bQuit;
    c_kbqueue_init(keyDevice);
    c_kbqueue_start(keyDevice);
    
elseif find(keys == KbName('c')) %c
    if (eyetracking)
        c_kbqueue_stop(keyDevice);
        c_kbqueue_destroy(keyDevice);
        calib_count = calib_count + 1;
		
		[calib_savefile, calib_plotfile] = c_et_calib_filenames(logpath, logtag, calib_count, trial);
		c_et_calib( hwnd, hwnd_calib, fps, calib_savefile );
		
		saccade_loadsoundbuffers;
		
        c_kbqueue_init(keyDevice);
        c_kbqueue_start(keyDevice);
        bRestartTrial = 1;
    end
    
elseif find(keys == KbName('s')) %s
    disp('Skipping current trial');
    bSkip = 1;
elseif find(keys == KbName('t')) %t
    bBack = 1;
elseif find(keys == KbName('tab')) %tab
    bContinue = 1;
elseif find(keys == KbName('space')) %space
    bSpace = 1;
    
elseif find(keys == KbName('p')) %p
    %disp('Pause not available');
    
    if (exist('tex_pauze', 'var') == 1)
        Screen('DrawTexture', hwnd, tex_pauze, rsrc_pauze, [0 0  scrW scrH]);
        if (etrack_diode == 1)
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
    
    c_kbqueue_stop(keyDevice);
	c_kbqueue_destroy(keyDevice);
	calib_count = calib_count + 1;
	
	if eyetracking
		[calib_savefile, calib_plotfile] = c_et_calib_filenames(logpath, logtag, calib_count, trial);
		c_et_calib( hwnd, hwnd_calib, fps, calib_savefile );
		saccade_loadsoundbuffers;
	end
	
	c_kbqueue_init(keyDevice);
	c_kbqueue_start(keyDevice);
    
    bRestartTrial = 1;
    
elseif find(keys == KbName('v')) %v
    disp('Playing video, press "tab" to continue');
    
    cur_vid = att_last_vid;
    while (cur_vid == att_last_vid)
        cur_vid = randi(length(att_vids));
    end
    att_last_vid = cur_vid;
    video_file = att_vids{cur_vid};
    continue_on_key = 1;
    vid_rec = [scrW/4 scrH/4 3*scrW/4 3*scrH/4];
    show_diode_square = etrack_diode;
    trigger_diode = 0;
    c_play_video;
	saccade_loadsoundbuffers;
    bRestartTrial = 1;
    
elseif ~isempty(keys) && ( any(ismember( keys, numberKeysNumpad )) || any(ismember( keys, numberKeysQwerty )) ) % number keys 1 t/m 9
	% Only keep keys that are a number on either the keypad or the Querty part.
	keys = [intersect( keys, numberKeysQwerty ), intersect( keys, numberKeysNumpad )];
	
	% If there are more keys pressed simultaneously, pick the first one.
	keys = keys(1);
	
    soundToPlay = [ find( numberKeysNumpad == keys ), find( numberKeysQwerty == keys ) ];
	soundToPlay = soundToPlay(1);
    
	if (soundToPlay <= length(aud_att))
        PsychPortAudio('Start', aud_att{soundToPlay}, 1, 0, 0);
	end
	
    disp(['Playing attention grabber ' num2str(soundToPlay)]);
    
end



