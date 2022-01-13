function c_et_toggle_tracking_mode()
	
	% Eyetracker object.
	global eyeTracker
	global keepTrackingMode
	
	
	% Get the current mode sting.
	currentMode		= eyeTracker.get_eye_tracking_mode;
	
	
	% Get the new mode.
	modesUsed	= { 'Default', 'Infant' };
	newMode		= setdiff( modesUsed, currentMode );
	newMode		= newMode{1};
	
	
	% Set the eyetracker to the new mode.
	eyeTracker.set_eye_tracking_mode( newMode );
	keepTrackingMode = true;
	
	
	% Display message.
	fprintf( 1, 'Tracking mode set to ''%s''.\n', newMode );
	
end