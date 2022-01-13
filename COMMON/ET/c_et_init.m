function success = c_et_init(useEyetracking, R0_counter_etframerate)

global settings_path;
global eyeTrackingOperations
global eyeTracker

% Flag for keeping the mode (that is: if the mode is manually set, do not reset it to Default).
global keepTrackingMode


% Get settings from mat file.
settingsFileName	= fullfile( settings_path, 'settings.mat' );
settingsFile		= matfile( settingsFileName, 'writable', true );


% If eyetracking is disabled, quit.
if ~useEyetracking
    assignin('base', 'trackerID', 'eyetracking disabled');
    success = 1;
    return;
end


% EyeTrackerOperations for finding and connecting to available eyetrackers.
eyeTrackingOperations = EyeTrackingOperations;


% Success flag.
success = false;


% Get the address of the last used eyetracker, if any.
if isprop(settingsFile, 'trackerAddress') && ~isempty(settingsFile.trackerAddress)
	% Try connecting to the eyetracker.
	try
		fprintf( 1, 'Connecting to eyetracker %s on address %s ... ', settingsFile.trackerID, settingsFile.trackerAddress );
		
		eyeTracker	= eyeTrackingOperations.get_eyetracker( settingsFile.trackerAddress );
		success		= true;
		
		fprintf( 1, 'OK!\n' );
	catch
		fprintf( 1, 'Failed.\n' );
	end
end


% If not successful, lets try listing all the available trackers and
% connect to one of them.
if ~success
	fprintf( 1, 'Looking for other connected eyetrackers ...\n' );
	eyeTracker = eyeTrackingOperations.find_all_eyetrackers;
	
	if isempty( eyeTracker )
		fprintf( 1, '<strong>No eyetrackers were found.</strong>\n' );
	
	elseif numel( eyeTracker ) > 1
		% If there are more trackers found, list the available devices and
		% let the user select one manually.
		fprintf( 1, 'Please choose the eyetracker you want to use:\n');
		for i = 1 : numel(eyeTracker)
			fprintf( 1, '  %d) %s (%s)\n', i, eyeTracker(i).SerialNumber, eyeTracker(i).Address );
		end
		
		% Let the user choose a tracker.
		choice = 0;
		while choice < 1 || choice > numel(eyeTracker)
			choice = input( sprintf('Choose an item (1-%d): ', numel(eyeTracker)) );
		end
		
		% Select only the chosen tracker.
		eyeTracker	= eyeTracker(choice);		
		success		= true;
		
	else
		% In this else-clause, at least we found an eyetracker, because
		% 'eyeTracker' is not empty.
		success		= true;
	end
end


% If we have connected to an eyetracker, save its name and address in the
% settings file.
if ~isempty( eyeTracker )
	if ~isequal( settingsFile.trackerID, eyeTracker.SerialNumber) || ~isprop( settingsFile, 'trackerAddress' ) || ...
            ~isequal(settingsFile.trackerAddress, eyeTracker.Address)
		fprintf( 1, 'Connected to eyetracker %s on address %s!\n', eyeTracker.SerialNumber, eyeTracker.Address );
	end
	
	% If the trackerID needs to be updated in the settings file, do so.
	if ~isequal( settingsFile.trackerID, eyeTracker.SerialNumber)
		settingsFile.trackerID = eyeTracker.SerialNumber;
		fprintf( 1, 'Eyetracker ID updated in settings file.\n' );
	end
	
	% Update tracker address in settings file if needed.
	if ~isprop( settingsFile, 'trackerAddress' ) || ~isequal(settingsFile.trackerAddress, eyeTracker.Address)
		settingsFile.trackerAddress = eyeTracker.Address;
		fprintf( 1, 'Eyetracker address updated in settings file.\n' );
	end


	% Determine the output frequency.
	if R0_counter_etframerate == 1
		switch eyeTracker.Model
			case 'Tobii TX300'
				outputFrequency = 300;
			case 'Tobii Pro Spectrum'
				outputFrequency = 600;
			otherwise
				error('Unknown eyetracker model for setting frame rate. Ask the lab technician.');
		end
	else
		outputFrequency = 120;
	end
	
	% Set output frequency.
	eyeTracker.set_gaze_output_frequency(outputFrequency);
	
	
	% Set the eye tracking mode to 'Default'.
	if isempty(keepTrackingMode) || ~keepTrackingMode
		eyeTracker.set_eye_tracking_mode('Default');
	end


	% % Start eyetracker for the first time.
	% fprintf( 1, 'Starting eyetracker ... ' );
	% eyeTracker.get_gaze_data;
	% fprintf( 1, 'OK!\n' );

	% Precaution: stop collecting gaze data.
	eyeTracker.stop_gaze_data;


	% Put trackerID in base. Hmm. Bah.
	assignin( 'base', 'trackerID', settingsFile.trackerID );
end
