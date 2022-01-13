function [ gazeData, gazePoints ] = get_gaze( hwnd, enableEyetracking )
	
	% Eye tracker object.
	global eyeTracker
	
	
	% Get window size.
	[scrW, scrH] = Screen( 'WindowSize', hwnd );
	
	
	if ~enableEyetracking
		[x,y] = GetMouse(hwnd);
		
		% Convert back to relative coorinates.
		gazePoints	= [x, y] ./ [scrW, scrH];
		
		% Make dummy gazeData.
		gazeData = GazeData( GetSecs * 1e6, GetSecs * 1e6, ...
			gazePoints, [NaN, NaN], Validity.Valid, NaN, NaN, [NaN,NaN], [NaN,NaN], NaN, ...
			gazePoints, [NaN, NaN], Validity.Valid, NaN, NaN, [NaN,NaN], [NaN,NaN], NaN );
	else
		% Get gaze data. This will return an array with all data points since the last call to
		% get_gaze_data.
		gazeData = eyeTracker.get_gaze_data;
		
		
		% More useful arrays.
		gazePoints = NaN( numel(gazeData), 2 );
		
				
		% Restructure the data in a more useful array.
		for dataNr = 1:numel(gazeData)
			% Left and right eye positions.
			leftPosition	= double( gazeData(dataNr).LeftEye.GazePoint.OnDisplayArea );
			rightPosition	= double( gazeData(dataNr).RightEye.GazePoint.OnDisplayArea );
			
			% Left and right validities.
			leftValidity	= gazeData(dataNr).LeftEye.GazePoint.Validity;
			rightValidity	= gazeData(dataNr).RightEye.GazePoint.Validity;
			
			% If both eye positions are valid, take their mean. Otherwise, only take the valid eye.
			% This can also be done using a NANMEAN, because the coordinates for invalid points are
			% always NaNs, but I guess the current approach is safer.
			if leftValidity == Validity.Valid && rightValidity == Validity.Valid
				gazePoints( dataNr, : ) = mean( [leftPosition; rightPosition], 1 );
			elseif leftValidity == Validity.Valid && rightValidity == Validity.Invalid
				gazePoints( dataNr, : ) = leftPosition;
			elseif leftValidity == Validity.Invalid && rightValidity == Validity.Valid
				gazePoints( dataNr, : ) = rightPosition;
			end
		end
	end