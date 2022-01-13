% Convert GazeData from the new Tobii Pro SDK to the older format from the
% older Tobii Pro Analytics SDK 3.
% It is possible to ask for gazedata in 'flat' form, but this is a
% organised a bit inconviently (a struct of arrays instead of an array of
% structs).
function [leftEyeData, rightEyeData, systemTimeStamps, deviceTimeStamps] = c_convert_tobii_gazedata_format( gazeData )
	
	% Number of samples.
	nrSamples = numel( gazeData );
	
	
	% Data arrays. This follows the data structures of the old SDK (Tobii
	% Pro Analytics SDK 3), in which th data was stores as an array instead
	% of classes.
	leftEyeData			= NaN( nrSamples, 13 );
	rightEyeData		= NaN( nrSamples, 13 );
	
	
	% Convert GazeData to arrays.
	for s = 1 : nrSamples
		% Columns 1-3: gaze origin in user coordinates.
		leftEyeData( s, 1:3 )	= double( gazeData(s).LeftEye.GazeOrigin.InUserCoordinateSystem );
		rightEyeData( s, 1:3 )	= double( gazeData(s).RightEye.GazeOrigin.InUserCoordinateSystem );
		
		% Columns 4-6: gaze origin in track box coordinates.
		leftEyeData( s, 4:6 )	= double( gazeData(s).LeftEye.GazeOrigin.InTrackBoxCoordinateSystem );
		rightEyeData( s, 4:6 )	= double( gazeData(s).RightEye.GazeOrigin.InTrackBoxCoordinateSystem );
		
		% Columns 7-8: gaze point on display area.
		leftEyeData( s, 7:8 )	= double( gazeData(s).LeftEye.GazePoint.OnDisplayArea );
		rightEyeData( s, 7:8 )	= double( gazeData(s).RightEye.GazePoint.OnDisplayArea );
		
		% Columns 9-11: gaze point in user coordinate system.
		leftEyeData( s, 9:11 )	= double( gazeData(s).LeftEye.GazePoint.InUserCoordinateSystem );
		rightEyeData( s, 9:11 )	= double( gazeData(s).RightEye.GazePoint.InUserCoordinateSystem );
		
		% Column 12: pupil diameter.
		leftEyeData( s, 12 )	= double( gazeData(s).LeftEye.Pupil.Diameter );
		rightEyeData( s, 12 )	= double( gazeData(s).RightEye.Pupil.Diameter );
		
		% Column 13: validity. This property has changed in the Tobii Pro
		% SDK. See the website: http://developer.tobiipro.com/commonconcepts/validitycodes.html.
		leftEyeData( s, 13 )	= ~double( gazeData(s).LeftEye.Pupil.Validity ) * 4;
		rightEyeData( s, 13 )	= ~double( gazeData(s).RightEye.Pupil.Validity ) * 4;
	end
	
	
	% Time stamps.
	systemTimeStamps = int64( [gazeData.SystemTimeStamp]' );
	deviceTimeStamps = int64( [gazeData.DeviceTimeStamp]' );
end