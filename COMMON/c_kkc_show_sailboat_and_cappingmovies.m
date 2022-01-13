global common_media_path
global common_media_capping


% Load sailboat image.
sailboatPath = fullfile( common_media_path, 'pauzescreen.jpg' );
sailboatImage = imread( sailboatPath );


% Get screen rect.
rect = Screen( 'Rect', hwnd );


% Make texture.
sailboatTexture = Screen( 'MakeTexture', hwnd, sailboatImage );


% Get file names for movies in media_capping path.
files = dir( fullfile( common_media_capping, '*.mp4' ) );


% Set low sound volume for these movies.
lowVolume = true;


% Continue flag.
continueWithTask = false;


% Let the user select a video file, or continue.
while ~continueWithTask
    % Draw texture.
    Screen( 'DrawTexture', hwnd, sailboatTexture, [], rect );
    Screen( 'Flip', hwnd );
    
	% Print menu.
	fprintf( 1, '\nAvailable video files:\n' );
	
	for i = 1 : numel(files)
		fprintf( 1, '%3d) %s\n', i, files(i).name );
	end
	
	% Ask for item input.
	choice = input( '\n<strong>Select video file (or ''c'' to continue):</strong> ', 's' );
	
	% Check answer.
	if isequal( lower(choice), 'c' )
		continueWithTask = true;
		
	elseif str2double(choice) >= 1 && str2double(choice) <= numel(files)
		choice = str2double(choice);
		
		% Pick the selected video file.
		video_file = fullfile( files(choice).folder, files(choice).name );
		
		% Parameter for c_play_video.
		continue_on_key = 1;
		
		fprintf( 1, 'Video started (press <strong>Tab</strong> to stop).\n');
		c_play_video;
		fprintf( 1, 'Video stopped.\n');
		
	else
		fprintf( 1, '\nInvalid answer.\n' );
	end
end


% Reset sound volume to normal.
lowVolume = false;