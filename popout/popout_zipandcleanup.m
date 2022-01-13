% Zip all files in the Per_trial folder.
zipFileName = fullfile(logpath,'Per_trial.zip');

try
	zippedFiles = zip( zipFileName, '*', perTrialFolder );
	
	
	% Get all file names in the Per_trial folder. Remove folder names '..' and '.'.
	files = dir( perTrialFolder );
	fileNames = setdiff( {files.name}, {'..', '.'} );


	% Check if indeed all files were added to the zip file. If so, remove the Per_trial folder (because
	% all its contents are in the zip).
	if isequal( sort(fileNames), sort(zippedFiles) )
		rmdir( perTrialFolder, 's' );
		fprintf( 1, 'Zip complete and successful.\n' );
	else
		delete( zipFileName );
		fprintf( 1, 'Zip failed! Keeping folder, and removing the zip. <strong>Please notify the technician!</strong>\n');
	end

catch err
	if ~isequal( err.message, 'Nothing to zip.')
		fprintf( 1, 'Zip reported the following: "%s". <strong>Please notify the technician!</strong>\n', err.message );
	end
end