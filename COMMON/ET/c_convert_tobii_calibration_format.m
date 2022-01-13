% Convert CalibrationResult from the new Tobii Pro SDK to the older format from the
% older Tobii Pro Analytics SDK 3.
% It is possible to ask for gazedata in 'flat' form, but this is a
% organised a bit inconviently (a struct of arrays instead of an array of
% structs).
function pts = c_convert_tobii_calibration_format( calibrationResult )
	
	% Number of calibration points and number of data points.
	nrPoints = numel( calibrationResult.CalibrationPoints );
	
	
	% Result array.
	pts = [];
	
	
	% Convert calibration data. See also
	% http://developer.tobiipro.com/matlab/matlab-oldmigrationsdk.html.
	for pointNr = 1:nrPoints
		nrSamples = numel( calibrationResult.CalibrationPoints(pointNr).LeftEye );
		
		ptsForThisPoint = NaN( nrSamples, 8 );
		
		for sampleNr = 1:nrSamples
			% Columns 1-2: true location of calibration point.
			ptsForThisPoint( sampleNr, 1:2 ) = calibrationResult.CalibrationPoints(pointNr).PositionOnDisplayArea;
			
			% Columns 3-5: measured location and validity for left eye.
			ptsForThisPoint( sampleNr, 3:4 ) = calibrationResult.CalibrationPoints(pointNr).LeftEye(sampleNr).PositionOnDisplayArea;
			ptsForThisPoint( sampleNr, 5 )	= ~double( calibrationResult.CalibrationPoints(pointNr).LeftEye(sampleNr).Validity ) * 4;
			
			% Columns 6-8: measured location and validity for right eye.
			ptsForThisPoint( sampleNr, 6:7 ) = calibrationResult.CalibrationPoints(pointNr).RightEye(sampleNr).PositionOnDisplayArea;
			ptsForThisPoint( sampleNr, 8 )	= ~double( calibrationResult.CalibrationPoints(pointNr).RightEye(sampleNr).Validity ) * 4;
		end
		
		% Add to final results array.
		pts = [ pts; ptsForThisPoint ]; %#ok<AGROW>
	end