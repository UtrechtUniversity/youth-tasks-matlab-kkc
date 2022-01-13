
n_aoi = size(aoi_stim{cur_tex}.aoiRectList, 1);
lstAOI = cell(1, n_aoi);
for i = 1 : n_aoi
    rs = rdst_stim{cur_tex};
    x = rs(1); %(scrW - rs(3)) / 2;
    y = rs(2); %(scrH - rs(4)) / 2;
    lstAOI{i} = [x y x y] + [(rs(3)-rs(1)) (rs(4)-rs(2)) (rs(3)-rs(1)) (rs(4)-rs(2))] .* aoi_stim{cur_tex}.aoiRectList(i,:) / 100;
end

music_playing = 0;

fix_min_frames = floor(0.6 * fps);

%diodesize = 75;


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


% Flip counts and timings.
flip_onsets = zeros(1,3);
flip_breaks = zeros(1,2);
flip_counts = zeros(1,2);


cnt_frames = 0;
set_first = 1;

while (1)
    Screen( 'DrawTexture', hwnd, tex_isi );
    
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
    
    popout_keycheck;
	
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
		if ((meanGazePointOnScreen(1) >= roi_isi(1)) && ...
			(meanGazePointOnScreen(1) <= roi_isi(3)) && ...
			(meanGazePointOnScreen(2) >= roi_isi(2)) && ...
			(meanGazePointOnScreen(2) <= roi_isi(4)))
			
			if (cnt_frames >= fix_min_frames)
				break;
			end
		end
	end
end


music_playing = 1;
PsychPortAudio('Start', aud_trial{ind_aud_trial(trial)}, 1, 0, 0);


cnt_interval = 0;
set_first = 1;

for dirG = 1 : (stimDuration * fps)
	% Draw stimulus texture in backbuffer.
	Screen('DrawTexture', hwnd, tex_stim{1,cur_tex}, rsrc_stim{cur_tex}, rdst_stim{cur_tex});
    
	
	% Display square for diode.
	if (etrack_diode == 1)
		if (dirG < 6)
			Screen('FillRect', hwnd, [255 255 255], [0 0 diodesize diodesize]);
		else
			Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
		end
	end
	
	
	% Flip the screen.
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
	
    
	% Perform a keycheck every 10 flips.
	cnt_interval = cnt_interval + 1;
	if (cnt_interval == 10)
		cnt_interval = 0;
		
		popout_keycheck;
		
		if (bQuit || bRestartTrial)
			PsychPortAudio('Stop', aud_trial{ind_aud_trial(trial)});
			return;
		end
	end
    
	
	
    dT = timeStamp - first;
    if (dT > stimDuration-dTBreak)
%         flip_breaks(2) = 1;
        break;
    end
end

if (etrack_diode == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end

Screen('Flip', hwnd);
timeStamp = double(eyeTrackingOperations.get_system_time_stamp) / 1e6;
flip_onsets(3) = timeStamp;


music_playing = 0;
PsychPortAudio('Stop', aud_trial{ind_aud_trial(trial)});


