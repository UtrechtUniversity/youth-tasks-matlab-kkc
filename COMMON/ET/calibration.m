function calibrationResult = calibration( hwndMain, hwndMini, calibrationParameters, fps )
	
	% Global paths.
	global calib_path
	
	
	% Eyetracker object.
	global eyeTracker
	
	
	% Initialize sound (if not done elsewhere already).
	InitializePsychSound;
	
	
	% Close all existing audio handles. For safety.
	PsychPortAudio( 'Close' );
	
	
	% Open master audio handle.
	global hAudioMaster
	hAudioMaster = PsychPortAudio( 'Open', [], 1+8 );
	PsychPortAudio('Start', hAudioMaster, 0, 0, 1);
	
	
	% Load background music.
	hAudio = NaN( 1, numel(calibrationParameters.fgmusic) );
	
	for i = 1 : numel(calibrationParameters.fgmusic)
		hAudio(i) = c_load_audio( fullfile( calib_path, calibrationParameters.fgmusic{i} ) );
	end
	
	
	% Clear miniscreen.
	backgroundColor = 131;
	Screen( 'FillRect', hwndMini, backgroundColor );
	Screen( 'Flip', hwndMini );
	
	
	% Get screen dimensions for presentation screen and miniscreen.
	[mainWidth, mainHeight] = Screen( 'WindowSize', hwndMain );
	[miniWidth, miniHeight] = Screen( 'WindowSize', hwndMini );
	
	
	% Calculate scale factors to convert from main screen coordinates to
	% mini screen coordinates.
	scaleWidth	= miniWidth / mainWidth;
	scaleHeight = miniHeight / mainHeight;
	
	
	% Random shuffling of the calibration images.
	calibrationParameters.images = calibrationParameters.images( randperm(numel(calibrationParameters.images)) );
	
	
	% Calibration object.
	calibration = ScreenBasedCalibration( eyeTracker );
	
	try
		calibration.enter_calibration_mode;
		fprintf( 1, 'Calibration mode started.\n' );
	catch
		calibration.leave_calibration_mode;
		calibration.enter_calibration_mode;
		fprintf( 1, 'Calibration mode re-started.\n' );
	end
	
	
	% Flags for continuous loop.
	isCalibrating = true;
	recalibration = false;
	
	
	% Shuffle calibration points in a random order.
	pointOrder = randperm( calibrationParameters.points.n );
	
	
	while isCalibrating
		
		% If recalibrating, ask for the points to be recalibrated.
		while recalibration
			answer = input( 'Points to be recalibrated (separate with spaces, leave <strong>empty</strong> for all points): ', 's');
			answer = str2num( answer ); %#ok<ST2NM>
			
			if isempty(answer)
				answer = randperm( calibrationParameters.points.n );
			end
			
			if isnumeric(answer)
				% Set the points to be recalibrated and shuffle them.
				pointOrder = answer( randperm(numel(answer)) );
				
				fprintf( 1, 'Recalibrating points: %s.\n', num2str(answer) );
				
				% Leave loop.
				break
			else
				fprintf( 1, 'Please enter point numbers separated by spaces.\n' );
			end				
		end
	
		% Present calibration point.
		for pointNr = pointOrder
			
			fprintf( 1, 'Press <strong>Space</strong> (or Shift) when participant is looking at stimulus %d.\n', pointNr );

			% Get the point's coordinates (relative).
			point = [ calibrationParameters.points.x(pointNr), calibrationParameters.points.y(pointNr) ];


			% Convert into absolute coordinates on screen and miniscreen.
			pointOnMainScreen = [mainWidth, mainHeight] .* point;
			pointOnMiniScreen = [miniWidth, miniHeight] .* point;


			% Show point on miniscreen.
			Screen( 'TextSize', hwndMini, 40 );
			Screen( 'DrawText', hwndMini, sprintf('%d', pointNr), pointOnMiniScreen(1), pointOnMiniScreen(2), [0 0 0], [], 1 );
			Screen( 'Flip', hwndMini);


			% Start music. (Pick a random sound from the sound buffer.)
			soundNr = randi( numel(calibrationParameters.fgmusic) );
			PsychPortAudio( 'Start', hAudio( soundNr ), 0 );


			% Pick a random image and make that into a texture for display.
			pointImage		= imread( fullfile( calib_path, calibrationParameters.images{pointNr}), 'PNG', 'BackgroundColor', calibrationParameters.bkcolor./255 );
			pointTexture	= Screen( 'MakeTexture', hwndMain, pointImage );


			% Get rect of image.
			baseRect = [0 0 1 1] .* calibrationParameters.stimsize;


			% Rotation variable for animation.
			rotationAngle = 0;


			% Animate texture until keypress.
			while true
				% Rotation and size change.
				rotationAngle	= rotationAngle + calibrationParameters.changeperflip;
				sizeOffset		= calibrationParameters.sizechange * sin( deg2rad(rotationAngle) );


				% Make image rectangle smaller and center around stimulus point.
				imageRect = CenterRectOnPointd( baseRect - [0 0 1 1] * sizeOffset, pointOnMainScreen(1), pointOnMainScreen(2) );


				% Draw everything on main screen.
				Screen( 'FillRect', hwndMain, backgroundColor );
				Screen( 'DrawTexture', hwndMain, pointTexture, [], imageRect, rotationAngle );
				Screen( 'Flip', hwndMain );


				% Go to next point.
				[keyIsDown, ~, keyCode] = KbCheck(-1);
				if keyIsDown
					pressedKeys = find(keyCode);
					if ismember( pressedKeys(1), [ KbName('Space'), KbName('LeftShift'), KbName('RightShift') ] )
						break
					end
				end
			end


			% Size change per flip for final animation.
			imageSize			= calibrationParameters.stimsize - sizeOffset;
			sizeOffsetPerFlip	= ( imageSize - calibrationParameters.finalsize ) / ( fps * calibrationParameters.finaltime );


			% Animation for disappearing.
			for frameNr = 1 : ( fps * calibrationParameters.finaltime )

				% Update rotation and size offset.
				imageSize		= imageSize - sizeOffsetPerFlip;
				rotationAngle	= rotationAngle + calibrationParameters.changeperflip;


				% Make image rect and center it.
				imageRect = CenterRectOnPointd( [0 0 1 1] * imageSize, pointOnMainScreen(1), pointOnMainScreen(2) );


				% Draw everything on main screen.
				Screen( 'FillRect', hwndMain, backgroundColor );
				Screen( 'DrawTexture', hwndMain, pointTexture, [], imageRect, rotationAngle );
				Screen( 'Flip', hwndMain );
			end


			% Stop music.
			PsychPortAudio( 'Stop', hAudio( soundNr ) );


			% Remove old data from calibration.
			calibration.discard_data( point );


			% Add new calibration point.
			if calibration.collect_data( point ) ~= CalibrationStatus.Success
				% If not successful, try again if it didn't go well the first time.
				calibration.collect_data( point );
			end


			% Wait 200 ms.
			pause(.2);


			% Clear screen and miniscreen.
			Screen( 'FillRect', hwndMain, backgroundColor );
			Screen( 'Flip', hwndMain );
			
			Screen( 'FillRect', hwndMini, backgroundColor );
			Screen( 'Flip', hwndMini );
		end
		
		
		% Apply calibration.
		calibrationResult = calibration.compute_and_apply;
		
		
		% Plot calibration results in miniscreen.
		for pointNr = 1:numel(calibrationResult.CalibrationPoints)
			
			% Plot calibration point.
			point				= calibrationResult.CalibrationPoints(pointNr).PositionOnDisplayArea;
			pointOnMiniScreen	= [miniWidth, miniHeight] .* point;
			
			
			% Draw the calibration fixation point.
			Screen( 'DrawDots', hwndMini, pointOnMiniScreen, 10, [0 0 0] );
			
			
			% Rect for accuracy circle.
			accuracyCircleDiameter	= 67; % pixels on main screen. This corresponds to the circle sizes in previous versions.
			accuracyCircleRect		= CenterRectOnPointd( accuracyCircleDiameter * [0 0 1 1] .* [1 1 scaleWidth scaleHeight], ...
				pointOnMiniScreen(1), pointOnMiniScreen(2) );
			
			% Draw accuracy circle.
			Screen( 'FrameOval', hwndMini, [0 0 0], accuracyCircleRect );
			
			
			% Get calibration data for each eye.
			leftEye		= calibrationResult.CalibrationPoints(pointNr).LeftEye;
			rightEye	= calibrationResult.CalibrationPoints(pointNr).RightEye;
			
			
			% Colors for drawing calibration data.
			leftColor	= [255 0 0];
			rightColor	= [0 0 255];
			
			
			% Draw left eye data.
			for dataNr = 1 : numel(leftEye)
				if leftEye(dataNr).Validity == CalibrationEyeValidity.ValidAndUsed
					dataPointOnMiniScreen = leftEye(dataNr).PositionOnDisplayArea .* [miniWidth, miniHeight];
					
					Screen('DrawDots', hwndMini, dataPointOnMiniScreen, 6, leftColor, [], 2 );
					Screen('DrawLines', hwndMini, [pointOnMiniScreen; dataPointOnMiniScreen]', 1, leftColor );
				end
			end
			
			
			% Draw right eye data.
			for dataNr = 1 : numel(rightEye)
				if rightEye(dataNr).Validity == CalibrationEyeValidity.ValidAndUsed
					dataPointOnMiniScreen = rightEye(dataNr).PositionOnDisplayArea .* [miniWidth, miniHeight];
					
					Screen('DrawDots', hwndMini, dataPointOnMiniScreen, 6, rightColor, [], 2 );
					Screen('DrawLines', hwndMini, [pointOnMiniScreen; dataPointOnMiniScreen]', 1, rightColor );
				end
			end
		end
		
		
		% Draw point numbers on miniscreen. If no data is gathered during calibration (for example
		% because none of the eyes were found), the calibrationResults is empty. Therefore, we draw
		% the numbers separately.
		for pointNr = 1: calibrationParameters.points.n
			% Point in relative and in screen coordinates.
			point				= [ calibrationParameters.points.x(pointNr), calibrationParameters.points.y(pointNr) ];
			pointOnMiniScreen	= point .* [miniWidth, miniHeight];
			
			% Draw point number.
			Screen( 'TextSize', hwndMini, 20 );
			Screen( 'TextStyle', hwndMini, 1 );
			Screen( 'DrawText', hwndMini, sprintf('%d', pointNr), pointOnMiniScreen(1), pointOnMiniScreen(2), [0 180 0] );
		end
		
		
		% Draw everything to miniscreen.
		Screen( 'Flip', hwndMini );
		
		
		% Accept the calibration or not?
		validAnswer = false;
		
		while ~validAnswer
			answer = strtrim( input('Accept calibration? ([y]/n): ', 's') );

			if isempty(answer) || answer(1) == 'y'
				validAnswer	= true;
				isCalibrating = false;
			elseif answer(1) == 'n'
				validAnswer = true;
				recalibration = true;
			else
				fprintf( 1, 'Please answer ''y'' or ''n''.\n' );
			end
		end
	end
	
	
	% Leave calibration mode.
	calibration.leave_calibration_mode;
	
	
	fprintf( 1, 'Calibration finished.\n' );