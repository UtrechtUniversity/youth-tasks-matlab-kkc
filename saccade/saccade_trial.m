
%diodesize = 75;


% Collect all gaze data for this trial in an array.
gazeDataTrial = GazeData.empty;


% Array for storing PTB and Tobii time stamps.
timestampsPtbStimulusOnset  = [];
timestampsTobiiSystem       = [];
timestampsPtbGetSecs        = [];


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

stimRotEachSec = 500;
ISI = randi([600, 700]) / 1000;

%fixationPosition = rgaze_cent_stim;
dTBreak = 1 / (2*fps);

flip_onsets = zeros(1,6);
flip_breaks = zeros(1,5);
flip_counts = zeros(1,5);

gazed_cent = 0;
gazed_peri = 0;

i_snd_cent = randi(length(aud_cent));
i_snd_peri = randi(length(aud_peri));
i_snd_rew = randi(length(aud_rew));

PsychPortAudio('Start', aud_cent{i_snd_cent}, 1, 0, 0);

% get_gaze;
% draw_gaze_lr;

%rdst_cur = rdst_cent_stim;

if (etrack_diode == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end
Screen('Flip', hwnd);


set_first = 1;

i = 1;
while (1)
    
    if (i <= stimLoomFrames)
        rdst_cur = rdst_cent_loom{i};
    else
        j = 1 + mod(i - stimLoomFrames - 1, stimThrobFrames);
        rdst_cur = rdst_cent_throb{j};
    end
    i=i+1;
    
    Screen('DrawTexture', hwnd, tex_cent, rsrc_cent, rdst_cur); %rdst_cent_stim);

	if (etrack_diode == 1)
		if (i < 6)
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
    
    saccade_keycheck;
	
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
			
			gazed_cent = 1;
			break;
		end
	end
end

ang = 0;
set_first = 1;
for i = 1 : fps * ISI
    
    Screen('DrawTexture', hwnd, tex_cent, rsrc_cent, rdst_cent_stim, ang);

	if (etrack_diode == 1)
        if (i < 6)
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
    
	if (dT > ISI-dTBreak)
        flip_breaks(2) = 1;
        break;
	end
    
    ang = stimRotEachSec * dT;
end

set_first = 1;
for i = 1 : fps * 0.2
    
	if (trial_type > 1)
        Screen('DrawTexture', hwnd, tex_cent, rsrc_cent, rdst_cent_stim, ang);
	end
	
	if (etrack_diode == 1)
        if (i < 6)
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
    
	if (dT > 0.2-dTBreak)
        flip_breaks(3) = 1;
        break;
	end
end

set_first = 1;
for i = 1 : fps * 2
    
	if (trial_side == 1)
        Screen('DrawTexture', hwnd, tex_peri{trial_img}, rsrc_peri{trial_img}, rdst_peri_stim_right);
	else
        Screen('DrawTexture', hwnd, tex_peri{trial_img}, rsrc_peri{trial_img}, rdst_peri_stim_left);
	end
	
	if (trial_type == 2) %OVERLAP
        Screen('DrawTexture', hwnd, tex_cent, rsrc_cent, rdst_cent_stim, ang);
	end
	
	if (etrack_diode == 1)
        if (i < 6)
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
        PsychPortAudio('Start', aud_peri{i_snd_peri}, 1, 0, 0);
	end
	
    dT = (timeStamp - first);
   
	if (dT > 2-dTBreak)
        flip_breaks(4) = 1;
        break;
	end
    
    saccade_keycheck;
	
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
		if (gaze_side == 1)
			if ((meanGazePointOnScreen(1) >= rgaze_peri_stim_right(1)) && ...
				(meanGazePointOnScreen(1) <= rgaze_peri_stim_right(3)) && ...
				(meanGazePointOnScreen(2) >= rgaze_peri_stim_right(2)) && ...
				(meanGazePointOnScreen(2) <= rgaze_peri_stim_right(4)))

				gazed_peri = 1;
				break;
			end
		else
			if ((meanGazePointOnScreen(1) >= rgaze_peri_stim_left(1)) && ...
				(meanGazePointOnScreen(1) <= rgaze_peri_stim_left(3)) && ...
				(meanGazePointOnScreen(2) >= rgaze_peri_stim_left(2)) && ...
				(meanGazePointOnScreen(2) <= rgaze_peri_stim_left(4)))

				gazed_peri = 1;
				break;
			end
		end
	end
end

ang = 0;
set_first = 1;
for i = 1 : fps * 1
    
	if (trial_side == 1)
        if (reward_anim == 0)
            rdst_cur = rdst_peri_stim_right;
        elseif (reward_anim == 1)
            j = 1 + mod(i-1, stimShrinkFrames);
            rdst_cur = rdst_peri_shrink_right{j};
        else
            j = 1 + mod(i-1, stimThrobFrames_peri);
            rdst_cur = rdst_peri_throb_right{j};
        end
        %Screen('DrawTexture', hwnd, tex_peri{trial_img}, rsrc_peri{trial_img}, rdst_peri_stim_right, ang);
    else
        if (reward_anim == 0)
            rdst_cur = rdst_peri_stim_left;
        elseif (reward_anim == 1)
            j = 1 + mod(i-1, stimShrinkFrames);
            rdst_cur = rdst_peri_shrink_left{j};
        else
            j = 1 + mod(i-1, stimThrobFrames_peri);
            rdst_cur = rdst_peri_throb_left{j};
        end
        %Screen('DrawTexture', hwnd, tex_peri{trial_img}, rsrc_peri{trial_img}, rdst_peri_stim_left, ang);
	end
	
    Screen('DrawTexture', hwnd, tex_peri{trial_img}, rsrc_peri{trial_img}, rdst_cur, ang);
	
	if (etrack_diode == 1)
        if (i < 6)
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
    
    flip_counts(5) = flip_counts(5) + 1;
	
	if (set_first)
        set_first = 0;
        first = timeStamp;
        flip_onsets(5) = timeStamp;
        PsychPortAudio('Start', aud_rew{i_snd_rew}, 1, 0, 0);
	end
	
    dT = (timeStamp - first);
    if (dT > 1-dTBreak)
        flip_breaks(5) = 1;
        break;
    end
    
    if (reward_spin)
        ang = stimRotEachSec * dT;
    end
    
    saccade_keycheck;
	
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
	end
end

if (etrack_diode == 1)
    Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
end

Screen('Flip', hwnd);
timeStamp = double(eyeTrackingOperations.get_system_time_stamp) / 1e6;
flip_onsets(6) = timeStamp;

% for i = 1 : 12
%     if (i > 6)
%         Screen('FillRect', hwnd, white, [0 0 150 100]);
%     else
%         Screen('FillRect', hwnd, black, [0 0 150 100]);
%     end
%     [VBLTimestamp, StimulusOnsetTime, ~, ~, ~] = Screen('Flip', hwnd);
% end
% 
% all_onsets(end+1,1:6) = flip_onsets;
% all_breaks(end+1,1:5) = flip_breaks;
% all_counts(end+1,1:5) = flip_counts;
% all_gazed(end+1,1:2) = [gazed_cent, gazed_peri];

