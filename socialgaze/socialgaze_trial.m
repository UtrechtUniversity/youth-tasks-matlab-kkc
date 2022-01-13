

bounce = 0;
bounceIncrFix = 10;

scale = 0.7;
recFaceDest = [scrW/2 scrH/2 scrW/2 scrH/2] + scale * [-rsrc_stim{1,currentTexture}(3), -rsrc_stim{1,currentTexture}(4), rsrc_stim{1,currentTexture}(3), rsrc_stim{1,currentTexture}(4)] / 2;

directGazeMin = 0.3;
directGazeMax = 0.3;
directGazeDuration = directGazeMin + (directGazeMax - directGazeMin) * rand;

%avertedGazeMin = 1.3;  %0.3
%avertedGazeMax = 1.7;  %0.5
avertedGazeDuration = avertedGazeMin + (avertedGazeMax - avertedGazeMin) * rand;

maxTarDuration = 2.5;
maxStaticTarDuration = 1.5;
eyeOnTarDuration = 1.0;
angleIncrTar = 3;

fixScale = 0.5;
tarScale = 0.5;
horTarPos = 0.5 * rsrc_target{currentTarget}(3)/2;

rdst_cent_stim = [scrW/2-fixScale*(rsrc_fix(3)/2)-bounceIncrFix scrH/2-fixScale*(rsrc_fix(4)/2)-bounceIncrFix ...
                  scrW/2+fixScale*(rsrc_fix(3)/2)+bounceIncrFix scrH/2+fixScale*(rsrc_fix(4)/2)+bounceIncrFix];
rgaze_cent_stim = [scrW/2-200 scrH/2-200 scrW/2+200 scrH/2+200];
%rgaze_cent_stim =       [floor(0.35*scrW) 0 ceil(0.65*scrW) scrH];

rdst_peri_stim_right = [scrW-horTarPos-tarScale*rsrc_target{currentTarget}(3)/2 scrH/2-tarScale*rsrc_target{currentTarget}(4)/2 ...
                        scrW-horTarPos+tarScale*rsrc_target{currentTarget}(3)/2 scrH/2+tarScale*rsrc_target{currentTarget}(4)/2];
rdst_peri_stim_left  = [horTarPos-tarScale*rsrc_target{currentTarget}(3)/2 scrH/2-tarScale*rsrc_target{currentTarget}(4)/2 ...
                        horTarPos+tarScale*rsrc_target{currentTarget}(3)/2 scrH/2+tarScale*rsrc_target{currentTarget}(4)/2];

% rgaze_peri_stim_right = [scrW-horTarPos-200 scrH/2-200 ...
%                         scrW-horTarPos+200 scrH/2+200];
% rgaze_peri_stim_left  = [horTarPos-200 scrH/2-200 ...
%                         horTarPos+200 scrH/2+200];
                     
rgaze_peri_stim_left = rgaze_peri_exp_left; %[0 0 floor(0.35*scrW) scrH];
rgaze_peri_stim_right = rgaze_peri_exp_right; %[ceil(0.65*scrW) 0 floor(1.0*scrW) scrH];

if (currentTarget_LR == cond_val_right)
    targetPosition = rdst_peri_stim_right;
    peri_gaze_Position = rgaze_peri_stim_right;
else
    targetPosition = rdst_peri_stim_left;
    peri_gaze_Position = rgaze_peri_stim_left;
end

trial_side = currentTarget_LR;
gaze_side = currentTarget_LR;

dTBreak = 1 / (2*fps);


fix_min_frames = floor(0.6 * fps);


i_snd_rew = randi(length(aud_rew));


gazed_cent = 0;
gazed_peri = 0;

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
flip_onsets = zeros(1,5);
flip_breaks = zeros(1,4);
flip_counts = zeros(1,4);



%--------------------------
%extra flip after get_gaze, keep time between flips short
if (etrack_diode == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end
Screen('Flip', hwnd);


set_first = 1;

cnt_frames = 0;
while (1)
    sizeChange = bounceIncrFix * sin(deg2rad(bounce));
    bounce = bounce + bounceIncrFix;
    
    fixationPosition = [scrW/2-(rsrc_fix(3)/2)-sizeChange scrH/2-(rsrc_fix(4)/2)-sizeChange ...
        scrW/2+(rsrc_fix(3)/2)+sizeChange scrH/2+(rsrc_fix(4)/2)+sizeChange];
    
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
    
    socialgaze_keycheck;
	
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
		draw_gaze_lr( hwnd, hwnd_calib, trial_side, gaze_side, rdst_cent_stim, rdst_peri_stim_left, rdst_peri_stim_right, rgaze_cent_stim, rgaze_peri_stim_left, rgaze_peri_stim_right, meanGazePointOnScreen(1), meanGazePointOnScreen(2) )
	
	
		% Continue as soon as the gaze is at the fixation area.
		if ((meanGazePointOnScreen(1) >= rgaze_cent_stim(1)) && ...
			(meanGazePointOnScreen(1) <= rgaze_cent_stim(3)) && ...
			(meanGazePointOnScreen(2) >= rgaze_cent_stim(2)) && ...
			(meanGazePointOnScreen(2) <= rgaze_cent_stim(4)))
			
			if (cnt_frames >= fix_min_frames)
				break;
			end
		end
	end
end


set_first = 1;
for dirG = 1 : (directGazeDuration * fps)
    Screen('DrawTexture', hwnd, tex_stim{1,currentTexture}, [], recFaceDest);

	if (etrack_diode == 1)
        if (dirG < 6)
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
		draw_gaze_lr( hwnd, hwnd_calib, trial_side, gaze_side, rdst_cent_stim, rdst_peri_stim_left, rdst_peri_stim_right, rgaze_cent_stim, rgaze_peri_stim_left, rgaze_peri_stim_right, meanGazePointOnScreen(1), meanGazePointOnScreen(2) )
	end
	
    dT = (timeStamp - first);
    if (dT > directGazeDuration-dTBreak)
        flip_breaks(2) = 1;
        break;
    end
end

set_first = 1;
for avG = 1 : (avertedGazeDuration * fps)
    Screen('DrawTexture', hwnd, tex_stim{2,currentTexture}, [], recFaceDest);
	if (etrack_diode == 1)
        if (avG < 6)
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
    
    flip_counts(3) = flip_counts(3) + 1;
	
	if (set_first)
        set_first = 0;
        first = timeStamp;
        flip_onsets(3) = timeStamp;
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
		draw_gaze_lr( hwnd, hwnd_calib, trial_side, gaze_side, rdst_cent_stim, rdst_peri_stim_left, rdst_peri_stim_right, rgaze_cent_stim, rgaze_peri_stim_left, rgaze_peri_stim_right, meanGazePointOnScreen(1), meanGazePointOnScreen(2) )
	end
	
	
    dT = (timeStamp - first);
    if (dT > avertedGazeDuration-dTBreak)
        flip_breaks(3) = 1;
        break;
    end
end

angle = 0;
gazed_peri = 0;
dynamic_tar = 0;
set_first = 1;
gazeTime = 0;
for tar = 1 : (maxTarDuration * fps)
    
    %currentTime = GetSecs;
    %angle = angle + angleIncrTar;
    
    Screen('DrawTexture', hwnd, tex_target{currentTarget}, [], targetPosition, angle);
    if (etrack_diode == 1)
        if (tar < 6)
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
    
    
    flip_counts(4) = flip_counts(4) + 1;
	if (set_first)
        set_first = 0;
        first = timeStamp;
        flip_onsets(4) = timeStamp;
	end
	
    dT = (timeStamp - first);
    if (dT > maxTarDuration-dTBreak)
        flip_breaks(4) = 1;
        break;
    end
    
    socialgaze_keycheck;
    if (bQuit || bRestartTrial)
        return;
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
		draw_gaze_lr( hwnd, hwnd_calib, trial_side, gaze_side, rdst_cent_stim, rdst_peri_stim_left, rdst_peri_stim_right, rgaze_cent_stim, rgaze_peri_stim_left, rgaze_peri_stim_right, meanGazePointOnScreen(1), meanGazePointOnScreen(2) )
	
	
		% Continue as soon as the gaze is at the fixation area.
		if ((meanGazePointOnScreen(1) >= peri_gaze_Position(1)) && ...
			(meanGazePointOnScreen(1) <= peri_gaze_Position(3)) && ...
			(meanGazePointOnScreen(2) >= peri_gaze_Position(2)) && ...
			(meanGazePointOnScreen(2) <= peri_gaze_Position(4)))
			
			gazed_peri = 1;
		end
	end
    
    if (dynamic_tar == 1)
        angle = angle + angleIncrTar;
        if (gazed_peri == 1)
            if (dT - gazeTime > eyeOnTarDuration)
                break;
            end
        end
    else
        if ((gazed_peri == 1) || (dT > maxStaticTarDuration))
            PsychPortAudio('Start', aud_rew{i_snd_rew}, 1, 0, 0);
            dynamic_tar = 1;
            gazeTime = dT;
        end
    end
end

if (etrack_diode == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end

Screen('Flip', hwnd);
timeStamp = double(eyeTrackingOperations.get_system_time_stamp) / 1e6;
flip_onsets(5) = timeStamp;