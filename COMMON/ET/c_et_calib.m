function c_et_calib( hwndMain, hwndMini, fps_calib, calib_savefile )

% Set calibration parameters
calibrationParameters = InitCalibration( hwndMain );

if (c_cmd_ask_yesno('Start positioning?') == 1)
	% Display the track status window showing the participant's eyes (to position the participant).
	disp('Starting TrackEyes, press <strong>tab</strong> when done positioning.');
	eyePositioning( hwndMain, calibrationParameters );
	disp('Positioning done.');
end


if (c_cmd_ask_yesno('Start calibration?') == 1)
	% Start the calibration.
	calibrationResult = calibration( hwndMain, hwndMini, calibrationParameters, fps_calib );
	
	% Convert calibration results into 'old' format, which is just a
	% numerical array instead of classes.
	pts = c_convert_tobii_calibration_format( calibrationResult ); %#ok<NASGU>
	
	% Save the calibration result.
	save(calib_savefile, 'pts');
	fprintf( 1, 'Calibration results saved.\n' );
end