% Track status and distance of the eyes, and allow for repositioning.
function eyePositioning( hwnd, calibrationParameters )

	KbReleaseWait;
	
	
	% Suppress key presses to the console.
	ListenChar(2);
	
	
	% Get window size.
	[ width, height ] = Screen( 'WindowSize', hwnd );


	% Close audio ports, otherwise the video will not play. Ports are re-opened
	% again at the bottom of the script, after the movie stops.
	global hAudioMaster
	PsychPortAudio( 'Close', hAudioMaster );


	% Calibration video.
	fprintf( 1, 'Load video ...\n' );
	[video, ~, ~, movw, movh] = Screen('OpenMovie', hwnd, calibrationParameters.video);
	fprintf( 1, 'Video loaded.\n' );
	Screen('SetMovieTimeIndex',video,0);
	Screen('PlayMovie',video,1);


	% Start eyetracking.
	fprintf( 1, 'Starting eye tracker ...\n' );
	global eyeTracker
	eyeTracker.get_gaze_data;
	fprintf( 1, 'Eye tracker started.\n' );
	
	
	% Get eye tracking mode.
	currentMode = eyeTracker.get_eye_tracking_mode;
	fprintf( 1, 'Eye tracking mode: ''%s''.\n', currentMode );
	
	
	% Print the output frequency.
	currentFrequency = eyeTracker.get_gaze_output_frequency;
	fprintf( 1, 'Output frequency: %.0f Hz\n', currentFrequency );
	
	
	% Get the 'aiming distance', based on the eyetracker model.
	switch eyeTracker.Model
		case 'Tobii TX300'
			aimingDistance = 650;
		case 'Tobii Pro Spectrum'
			aimingDistance = 670;
		otherwise
			error('Unknown eyetracker model. Ask the lab technician.');
	end


	fprintf('\n- Position the screen so that eyes are roughly in the center \n');
	fprintf('- Position the participant or screen so that the green line overlays the middle white line (= %.0f cm) \n', aimingDistance/10);
    fprintf('- In case positioning is really problematic, press ''m'' to toggle modes (Default/Infant) and note down in logbook\n\n');
	fprintf('<strong>Press Tab to continue.</strong> \n');


	% Flag for breaking the continuous loop.
	breakLoopFlag = false;


	while(~breakLoopFlag)
		% Draw background.
		Screen('FillRect', hwnd, calibrationParameters.bkcolor);

		% Get video frame.
		videoframe = Screen('GetMovieImage', hwnd, video);
		if (videoframe <= 0)
			Screen('SetMovieTimeIndex', video, 0);
			videoframe = Screen('GetMovieImage', hwnd, video);
		end


		% Draw video frame.
		Screen('DrawTexture', hwnd, videoframe, [0 0 movw movh],[0 0 width height]);


		% Draw position lines.
		Screen('DrawLine', hwnd, 255, width/2,		round(height/1.33), width/2,		round(height/1.33)+100, 4);
		Screen('DrawLine', hwnd, 255, width/2-200,	round(height/1.33), width/2-200,	round(height/1.33)+100, 4);
		Screen('DrawLine', hwnd, 255, width/2+200,	round(height/1.33), width/2+200,	round(height/1.33)+100, 4);


		% Get gaze data since last time.
		gazeData = eyeTracker.get_gaze_data;

		if ~isempty( gazeData )
			% Get last gaze data.
			gazeData = gazeData(end);


			dotColor = [0 255 0];


			% TODO: In the new Tobii Pro SDK, the system of validity codes in changed. In the old SDK, 
			% this was a numeric code, based on which we could color the eye dots red or green. But how 
			% to proceed with the current SDK?


			% Left Eye.
			if gazeData.LeftEye.GazeOrigin.Validity
				% X- and Y-coordinates, in TrackBox coordinate system.
				leftX = gazeData.LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(1);
				leftY = gazeData.LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(2);
				
				% Z-coordinate in User coordinate system!
				leftZ = gazeData.LeftEye.GazeOrigin.InUserCoordinateSystem(3);

				% Convert to a position on screen.
				leftXOnScreen = double( 1 - leftX ) * width;
				leftYOnScreen = double( leftY ) * height;

				Screen('DrawDots', hwnd, [leftXOnScreen, leftYOnScreen], 30, dotColor );
			else
				leftZ = NaN;
			end


			% Right Eye.
			if gazeData.RightEye.GazeOrigin.Validity
				% X- and Y-coordinates, in TrackBox coordinate system.
				rightX = gazeData.RightEye.GazeOrigin.InTrackBoxCoordinateSystem(1);
				rightY = gazeData.RightEye.GazeOrigin.InTrackBoxCoordinateSystem(2);
				
				% Z-coordinate in User coordinate system!
				rightZ = gazeData.RightEye.GazeOrigin.InUserCoordinateSystem(3);

				% Convert to a position on screen.
				rightXOnScreen = double( 1 - rightX ) * width;
				rightYOnScreen = double( rightY ) * height;

				Screen('DrawDots', hwnd, [rightXOnScreen, rightYOnScreen], 30, dotColor );
			else
				rightZ = NaN;
			end


			% Calculate average distance.
			distance = double( nanmean( [leftZ, rightZ] ) );


			% Convert distance into line indicator position.
			indicatorPosition = round( (distance - aimingDistance) / 1 );


			% Show distance in cm as text.
			DrawFormattedText(hwnd, sprintf('Distance: %.1f cm', distance/10), 'center', height * 0.90, [255 255 255]);


			% Draw position indicator line.
			if ~isnan(indicatorPosition) && indicatorPosition > -200 && indicatorPosition < 200
				Screen('DrawLine', hwnd, [0 255 0], width/2+indicatorPosition, round(height/1.33), width/2+indicatorPosition, round(height/1.33)+100, 4);
			elseif indicatorPosition <= -200
				Screen('DrawLine', hwnd, [255 0 0], width/2-200, round(height/1.33), width/2-200, round(height/1.33)+100, 4);
			elseif indicatorPosition >= 200
				Screen('DrawLine', hwnd, [255 0 0], width/2+200, round(height/1.33), width/2+200, round(height/1.33)+100, 4);
			end
			
			
			% Draw everything to screen.
			Screen('Flip', hwnd);
		end


		% Close video frame texture.
		Screen('Close', videoframe);


		[keyIsDown, ~, keyCode] = KbCheck(-1);
		if keyIsDown
			pressedkeys = find(keyCode);
			if pressedkeys(1) == KbName('Tab')
				breakLoopFlag = true;
			elseif pressedkeys(1) == KbName('m')
				KbReleaseWait;
				c_et_toggle_tracking_mode;
			end
		end

	end
	
	
	% Re-enable key press output to console.
	ListenChar(0);


	% Clear screen.
	Screen('PlayMovie', video, 0);
	Screen('FillRect', hwnd, calibrationParameters.bkcolor);
	Screen('Flip', hwnd);
	
	
	% Stop eye tracker.
	eyeTracker.stop_gaze_data;


	% Re-open and re-start the audio master handle.
	hAudioMaster = PsychPortAudio( 'Open', [], 1+8 );
	PsychPortAudio('Start', hAudioMaster, 0, 0, 1);