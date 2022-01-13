function [revisionString, revisionNumber, shortRevisionString] = c_get_svn_revision_string( svnPath )
	
	% As default, pick this m-file's path.
	if nargin < 1
		svnPath = fileparts(mfilename('fullpath'));
	end
	
	
	% Ask system to execute the svn info command.
	commandString = sprintf( 'svn info %s', svnPath );
	[ errorCode, info ] = system( commandString );
	
	
	% Check if there's no error.
	if errorCode == 0
		% Get the revision number and URL using regexp.
		revisionNumber	= regexp(info, 'Revision: (\d+)', 'tokens', 'once');
		relativeUrl		= regexp(info, 'Relative URL: (\S+)', 'tokens', 'once');
		
		% Take number and URL out of cell array.
		revisionNumber = str2double( revisionNumber{1} );
		relativeUrl = relativeUrl{1};
		
		% Make revision string.
		revisionString = sprintf( 'Current SVN revision: %d (%s)', revisionNumber, relativeUrl );
		shortRevisionString = sprintf( '%d (%s)', revisionNumber, relativeUrl );
	else
		revisionString = '';
		warning('Unable to get the SVN revision number. Report to the lab technician!');
	end
	
end