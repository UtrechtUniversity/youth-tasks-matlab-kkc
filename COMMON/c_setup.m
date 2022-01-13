

if (exist('confirm_settings', 'var') == 0)
    confirm_settings = 1;
end

info_entered = 0;

%cfg_path = [script_path '/SETTINGS/'];
if (~exist(settings_path, 'dir'))
    mkdir(settings_path);
end

cfg_filename = [settings_path 'settings.mat'];
if (exist(cfg_filename, 'file') == 2)
    cfg_file = matfile(cfg_filename, 'writable', true);
	
	% Backwards compatibility: in previous versions, the number of the Mac was
	% stored as a double in the property macID. Since we now have both Macs
	% and PCs (Dell), we store the full computerID as a string.
	if isprop( cfg_file, 'macID' ) && ~isprop( cfg_file, 'computerID' )
		computerID = sprintf('MAC%02d', cfg_file.macID);
		
		% Make new property.
		cfg_file.computerID = computerID;
		
		% Message.
		fprintf( 1, 'Converted macID into computerID in settings.mat.\n' );
	end
	
    computerID = cfg_file.computerID;
    scrW_cm = cfg_file.ScreenWidthCm;
    scrH_cm = cfg_file.ScreenHeightCm;
    trackerID = cfg_file.trackerID;
    remotePC = cfg_file.remotePC;
    
    info_entered = 1;
else
    cfg_file = matfile(cfg_filename, 'writable', true);
    
    disp('<strong>Settings file not found, please enter settings</strong>');
    disp(' ');
end

if (info_entered == 1)
    disp(' ')
end

inp_ok = 0;
while (inp_ok == 0)
    
    if (info_entered == 1)
        disp(['Computer ID is: ' computerID]);
        disp(['Screen size is: ' num2str(scrW_cm) ' x ' num2str(scrH_cm) ' cm']);
        disp(['Tracker ID is: ' trackerID]);
        disp(['Remote PC is: ' remotePC]);
        
        if (confirm_settings == 0)
            inp_ok = 1;
        else
            [inp_ok] = c_cmd_ask_yesno('Is this correct?');
        end
    end
        
    if (inp_ok == 0)
        confirm_settings = 1;
        
        disp(' ');
        
		% Ask for hostname, which can be used for default computer name.
		[~, defaultComputerID]	= system('hostname');
		defaultComputerID		= strtrim(defaultComputerID);
		
		computerID = input( sprintf('Enter Mac ID (leave empty for default: <strong>%s</strong>): ', defaultComputerID), 's' );
		scrW_cm = input('Enter screen width in Cm: ');
        scrH_cm = input('Enter screen height in Cm: ');
        trackerID = input('Enter tracker ID (example: TX300-123456789012): ', 's');
        remotePC = input('Enter IP address for the remote PC (192.168.1.5X where X is the PC number): ', 's');
        
        disp(' ')
        
        info_entered = 1;
        if (isempty(computerID))
            computerID = defaultComputerID;
		end
		
		% Trim spaces and make all capitals.
		computerID = upper( strtrim( computerID ) );
        
        if (isempty(scrW_cm))
            info_entered = 0;
            disp('Invalid screen width')
        elseif (scrW_cm < 1)
            info_entered = 0;
            disp('Invalid screen width')
        end
        
        if (isempty(scrH_cm))
            info_entered = 0;
            disp('Invalid screen height')
        elseif (scrH_cm < 1)
            info_entered = 0;
            disp('Invalid screen height')
        end
        
        if (isempty(remotePC))
            info_entered = 0;
            disp('Invalid remote PC address')
        end
        
    end
end

cfg_file.computerID = computerID;
cfg_file.ScreenWidthCm = scrW_cm;
cfg_file.ScreenHeightCm = scrH_cm;
cfg_file.trackerID = trackerID;
cfg_file.remotePC = remotePC;


