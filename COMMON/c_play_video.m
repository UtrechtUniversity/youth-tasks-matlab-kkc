

if (exist('vid_rec', 'var') ~= 1)
    vid_rec = [0 0 scrW scrH];
end

if (exist('att_keycheck', 'var') == 0)
    att_keycheck = 0;
end

if (exist('vid_log_diode', 'var') == 0)
    vid_log_diode = 0;
end

if (exist('show_diode_square', 'var') == 0)
    show_diode_square = 0;
end

if (exist('trigger_diode', 'var') == 0)
    trigger_diode = 0;
end

if (exist('en_go_back', 'var') == 0)
    en_go_back = 0;
end
    
%video_file = '';
%continue_on_key = 1;


% Close audio master. This also closes the audio slaves, so everything
% will be opened again at the end of this script.
global hAudioMaster
PsychPortAudio( 'Close', hAudioMaster );


% Stop eyetracker data acquisition during video playback, because
% otherwise, the buffer gets full and it will take longer to read data from
% the tracker.
if exist( 'eyetracking', 'var' ) && eyetracking && exist( 'eyeTracker', 'var' ) && isa( eyeTracker, 'EyeTracker' )
	eyeTracker.stop_gaze_data;
end


% Low or high sound volume.
if exist('lowVolume', 'var') && lowVolume
    soundVolume = .15;
else
    soundVolume = 1;
end


[video, fps_vid, dur, movw, movh] = Screen('OpenMovie', hwnd, video_file);
Screen('SetMovieTimeIndex', video, 0);
Screen('PlayMovie', video, 1, [], soundVolume);

while (1)
    videoframe = Screen('GetMovieImage', hwnd, video);
    if ((videoframe == -1) && (continue_on_key == 0))
        break;
    elseif videoframe <= 0
        Screen('SetMovieTimeIndex', video, 0);
        videoframe = Screen('GetMovieImage', hwnd, video);
    end
    Screen('DrawTexture', hwnd, videoframe, [0 0 movw movh], vid_rec);
    if (show_diode_square == 1)
        if (trigger_diode == 0)
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        else
            Screen('FillRect', hwnd, [255 255 255], [0 0 diodesize diodesize]);
            trigger_diode = trigger_diode + 1;
            if (trigger_diode > fps_vid)
                trigger_diode = 0;
            end
        end
    end
    Screen('Flip', hwnd);
    
    Screen('Close', videoframe);
    
    if (continue_on_key == 1)
        [keyIsDown, ~, keyCode] = KbCheck(-1);
        if keyIsDown
            pressedkeys = find(keyCode);
            if pressedkeys(1) == KbName('Tab')
                break;
            elseif ((en_go_back == 1) && (pressedkeys(1) == KbName('t')))
                bBack = 1;
                break;
            end
        end
    end
    
    if (att_keycheck == 1)
        bQuit = 0;
        c_video_keycheck;
        if (bQuit == 1)
            break;
        end
    end
end

Screen('PlayMovie', video, 0);
if (show_diode_square == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end
Screen('Flip', hwnd);


[keyIsDown, ~, keyCode] = KbCheck(-1);
while keyIsDown
    [keyIsDown, ~, keyCode] = KbCheck(-1);
end       


% Re-open and re-start the audio master handle.
hAudioMaster = PsychPortAudio( 'Open', [], 1+8 );
PsychPortAudio('Start', hAudioMaster, 0, 0, 1);


% Restart eyetracker data acquisition.
if exist( 'eyetracking', 'var' ) && eyetracking && exist( 'eyeTracker', 'var' ) && isa( eyeTracker, 'EyeTracker' )
	eyeTracker.get_gaze_data;
end