function status = c_auto_update_svn( svnPath )

	% In case of errors, we use this global variable to skip the update. This boolean is set to true just
	% before trying to update. If the update is successful, set it back to false again. This way, if the
	% system command fails to return, we have bSkipSvnUpdate set to true, so that the next time it will skip
	% updating.
	global bSkipSvnUpdate
	
	
	% Settings file. The current revision number will be stored here.
	global settings_path
	settingsFile = fullfile( settings_path, 'settings.mat' );
	
	
	% The default directory for our code.
	if nargin < 1
		fprintf( 1, '\n<strong>MELDEN aan de technicus: "Ongeldig pad voor update". Je kunt wel gewoon doorgaan met de taken.</strong>\n' );
		bSkipSvnUpdate = true;
	end

	
	% Run the updating procedure.
	if isempty(bSkipSvnUpdate) || ~bSkipSvnUpdate
		try
			bSkipSvnUpdate = true;
			[status, output] = system( sprintf('svn --username cid update %s', svnPath) );
			bSkipSvnUpdate = false;

			if status ~= 0
				fprintf( 1, '\n<strong>MELDEN aan de technicus: "Updaten mislukt". Je kunt wel gewoon doorgaan met de taken.</strong>\n\n' );
			else
				% Get current revision number.
				[~, newRevisionNumber] = c_get_svn_revision_string( svnPath );
				
				% If mat file exists, open it to read and write interactively.
				if exist( settingsFile, 'file' )
					settingsMat = matfile(settingsFile, 'writable', true);
					
					% Check previous version number (if available).
					if isprop( settingsMat, 'svnRevisionNumber' )
						previousRevisionNumber = settingsMat.svnRevisionNumber;
					else
						previousRevisionNumber = 0;
					end
					
					% If the new number is higher, that means the code was updated. Write the new revision
					% number in the mat file and show the output of 'svn update'.
					if newRevisionNumber > previousRevisionNumber
						settingsMat.svnRevisionNumber = newRevisionNumber;
						
						fprintf( 1, '%s\n', datestr( now, 'yyyy-mm-dd HH:MM' ) );
						fprintf( 1, '%s\n', output );
					end
				end
			end
			
		catch
			status = -1;
			fprintf( 1, '\n<strong>MELDEN aan de technicus: "Updaten mislukt". Je kunt wel gewoon doorgaan met de taken.</strong>\n\n' );
		end
	else
		fprintf( 1, '\nUpdate overgeslagen.\n\n' );
	end
end