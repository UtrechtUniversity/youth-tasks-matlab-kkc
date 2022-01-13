
%fix_min_frames = floor(0.6 * fps);
fix_min_frames = floor(minFixDuration * fps);
fix_gaze_frames = floor(minFixGaze * fps);


% Collect all gaze data for this trial in an array.
gazeDataTrial = GazeData.empty;


% Array for storing PTB and Tobii time stamps.
timestampsPtbStimulusOnset  = [];
timestampsTobiiSystem       = [];
timestampsPtbGetSecs        = [];


%--------------------------------------------------------------------------

%synchronize screen flips
%when several vsync's are missed, psychtoolbox seems to get out of sync
%so we flip several times and then try to keep things fast during stimuli
%presentation. Then we save everything and may miss some flips because
%saving takes a lot of time. Next trial we first sync again.
%
%During tests, flip misses appeared mostly at the beginning of each trial,
%after several misses due saving. This syncing seemed to reduce misses.
switch trial
	case 1
		nrPreFlips = 20;
	otherwise
		nrPreflips = 5;
end

for sync = 1 : nrPreFlips
    if (etrack_diode == 1)
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
    end
    Screen('Flip', hwnd);
end

%--------------------------------------------------------------------------
%vars to hold data for saving. Reserve memory in order to speed things up

flip_onsets = zeros(1,3);
flip_breaks = zeros(1,2);
flip_counts = zeros(1,2);


%--------------------------
%extra flip after get_gaze, keep time between flips short
if (etrack_diode == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end
Screen('Flip', hwnd);

set_first = 1;
cnt_frames = 0;
cnt_gaze = 0;
gazed_cent = 0;
%while (1)
for i = 1 : fps * maxFixDuration
    
    Screen('DrawTexture', hwnd, tex_fix, [], fixationPosition, 0);
	if (etrack_diode == 1)
		if (cnt_frames < 6)
            Screen('FillRect', hwnd, [255 255 255], [0 0 diodesize diodesize]);
		else
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
		end
    end
	
    
    % Flip screen and obtain several timestamps (PTB stimulus onset, Tobii,
    % and GetSecs).
    [~, ptbStimulusOnset ] = Screen('Flip', hwnd);
	timeStamp = double(eyeTrackingOperations.get_system_time_stamp) / 1e6;
    ptbGetSecs = GetSecs;
    
    % Store timestamps.
    timestampsPtbStimulusOnset( end+1 ) = ptbStimulusOnset; %#ok<*SAGROW>
    timestampsTobiiSystem( end+1 )      = timeStamp;
    timestampsPtbGetSecs( end+1 )       = ptbGetSecs;
    
    flip_counts(1) = flip_counts(1) + 1;
    
	if (set_first)
        set_first = 0;
        first = timeStamp;
        flip_onsets(1) = timeStamp;
	end
    
    cnt_frames = cnt_frames + 1;
    
    looklisten_keycheck;
	
	if (bQuit || bRestartTrial)
        return;
	end
	
	if (bSkip)
        break;
	end
	
	
	% Get gaze data from eyetracker.
    [gazeData, gazePoints] = get_gaze( hwnd, eyetracking );
	
	
	% Add gazeData to array.
	gazeDataTrial = [ gazeDataTrial, gazeData ]; %#ok<*AGROW>
	
	
	% Take the mean of a number of samples to get a more stable result.
	samplesToTake = min( size(gazePoints,1), numSamples );
	meanGazePoint = nanmean( gazePoints( end-samplesToTake+1 : end, : ), 1 );
	
	% Convert from relative to screen coordinates.
	meanGazePointOnScreen = meanGazePoint .* [scrW, scrH];
	
	if ~isempty( meanGazePoint ) && all( isfinite( meanGazePointOnScreen ) )
		draw_gaze_aoi( hwnd, hwnd_calib, lstAOI, meanGazePointOnScreen(1), meanGazePointOnScreen(2), false );
	
	
		% Continue as soon as the gaze is at the fixation area.
		if ((meanGazePointOnScreen(1) >= rgaze_cent_stim(1)) && ...
			(meanGazePointOnScreen(1) <= rgaze_cent_stim(3)) && ...
			(meanGazePointOnScreen(2) >= rgaze_cent_stim(2)) && ...
			(meanGazePointOnScreen(2) <= rgaze_cent_stim(4)))
			
			if (cnt_gaze >= fix_gaze_frames)
				gazed_cent = 1;
			end
		else
			cnt_gaze = 0;
		end
	end
	
    
%     get_gaze;
%     %draw_gaze_lr;
%     draw_gaze_aoi;
%     if ((eyeXnSamples >= rgaze_cent_stim(1)) && ...
%         (eyeXnSamples <= rgaze_cent_stim(3)) && ...
%         (eyeYnSamples >= rgaze_cent_stim(2)) && ...
%         (eyeYnSamples <= rgaze_cent_stim(4)))
%         %gazed_cent = 1;
%         cnt_gaze = cnt_gaze + 1;
%         if (cnt_gaze >= fix_gaze_frames)
%             gazed_cent = 1;
%             %break;
%         end
%     else
%         cnt_gaze = 0;
% 
%     end
    
    if ((cnt_frames >= fix_min_frames) && (gazed_cent == 1))
        break;
    end
end

PsychPortAudio('Start', aud_sent{word_nr, sent_nr}, 1, 0, 0);
% write_logfile(['    ' datestr(datetime('now')) ' Starting audio file'])

set_first = 1;
cnt_frames = 0;

%write_logfile(['    ' datestr(datetime('now')) ' Starting visual presentation.'])

for i = 1 : fps * maxTrialDuration
    
    %Screen('DrawTexture', hwnd, tex_stim{tex_nr, vari_nr}, rsrc_stim{tex_nr, vari_nr}, rdst_stim{tex_nr, vari_nr}, 0);
    Screen('DrawTexture', hwnd, tex_stim{tex_nr}, rsrc_stim{tex_nr}, rdst_stim{tex_nr}, 0);
    
	if (etrack_diode == 1)
        if (cnt_frames < 6)
            Screen('FillRect', hwnd, [255 255 255], [0 0 diodesize diodesize]);
        else
            Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        end
    end
	
    
    % Flip screen and obtain several timestamps (PTB stimulus onset, Tobii,
    % and GetSecs).
    [~, ptbStimulusOnset ] = Screen('Flip', hwnd);
	timeStamp = double(eyeTrackingOperations.get_system_time_stamp) / 1e6;
    ptbGetSecs = GetSecs;
    
    % Store timestamps.
    timestampsPtbStimulusOnset( end+1 ) = ptbStimulusOnset; %#ok<*SAGROW>
    timestampsTobiiSystem( end+1 )      = timeStamp;
    timestampsPtbGetSecs( end+1 )       = ptbGetSecs;
    
    flip_counts(2) = flip_counts(2) + 1;
	
	if (set_first)
        set_first = 0;
        first = timeStamp;
        flip_onsets(2) = timeStamp;
	end
	
    dT = timeStamp - first;
    % dit is een meer failsafe methode om de flips te contoleren, 
    % als een flip wordt gemist, knalt ie hier uit de loop en klopt het toch
    if (dT > maxTrialDuration-dTBreak)
        flip_breaks(2) = 1;
        %write_logfile(['    ' datestr(datetime('now')) ' onsetTime -  First: ' num2str(dT)])
        break;
    end
    
    looklisten_keycheck;
	if (bQuit || bRestartTrial)
        return;
	end
	
	if (bSkip)
        break;
	end
    
    
	% Get the gaze data since last time.
    [gazeData, gazePoints] = get_gaze( hwnd, eyetracking );
	
	
	% Add gazeData to array.
	gazeDataTrial = [ gazeDataTrial, gazeData ]; %#ok<*AGROW>
	
	
	% Take the mean of a number of samples to get a more stable result.
	samplesToTake = min( size(gazePoints,1), numSamples );
	meanGazePoint = nanmean( gazePoints( end-samplesToTake+1 : end, : ), 1 );
	
	
	% Convert from relative to screen coordinates.
	meanGazePointOnScreen = meanGazePoint .* [scrW, scrH];
	
	
	% Draw gaze point on miniscreen.
	if ~isempty( meanGazePoint ) && all( isfinite( meanGazePointOnScreen ) )
		draw_gaze_aoi( hwnd, hwnd_calib, lstAOI, meanGazePointOnScreen(1), meanGazePointOnScreen(2) );
	end
end

if (etrack_diode == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end

Screen('Flip', hwnd);
timeStamp = double(eyeTrackingOperations.get_system_time_stamp) / 1e6;
flip_onsets(3) = timeStamp;