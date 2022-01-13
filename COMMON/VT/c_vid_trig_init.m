function [vt_enabled, tcpc, vt_cmd, vt_settings] = c_vid_trig_init(vt_enabled)

vt_cmd.nop              = 0;  %0000
vt_cmd.set_code         = 1;  %0001
vt_cmd.set_tag          = 2;  %0010
vt_cmd.close_device     = 4;  %0100
vt_cmd.open_device      = 5;  %0101
vt_cmd.stop_rec         = 6;  %0110
vt_cmd.start_rec        = 7;  %0111
vt_cmd.set_biosemi_path = 8;  %1000
vt_cmd.start_biosemi    = 9;  %1001
vt_cmd.bring_front      = 10; %1010


global settings_path;
cfg_filename = [settings_path 'settings.mat'];

if (exist(cfg_filename, 'file') == 0) %|| (bNewSetup == 1))
    c_setup;
else
    pref_file = matfile(cfg_filename, 'writable', true);
    vt_settings.server = pref_file.remotePC;
    disp(['Remote PC address is: ' vt_settings.server]);
	
	% Default camera settings.
	if ~isprop( pref_file, 'vt_cam_settings' )
		% Set defaults.
		pref_file.vt_cam_settings = 'video=HD Pro Webcam C920;video_size=864x480;framerate=15;pixel_format=yuyv422';
	end
	
	% Get camera settings.
	vt_settings.cam_settings = pref_file.vt_cam_settings;
	fprintf( 1, 'Camera settings string: ''%s''\n\n', vt_settings.cam_settings );
end

tcpc = [];

bChanged = 0;
connected = 0;
while ((connected == 0) && (vt_enabled == 1))
    
    disp('Connecting to recording PC...');
    try
        tcpc = tcpclient(vt_settings.server, 11000);
        connected = 1;
    catch
        disp(['<strong>Could not connect to recording PC ' vt_settings.server '</strong>']);
        if (c_cmd_ask_yesno('Retry connecting?') ~= 1)
            if (c_cmd_ask_yesno('Connect to other server?') == 1)
                vt_settings.server = input('Please enter the IP-address of the server: ', 's');
                bChanged = 1;
            else
               disp('<strong>WARNING: Please start the EEG and Video recording manually if you skip connecting to the server.</strong>');
               if (c_cmd_ask_yesno('Are you sure you want to skip connecting to other server?') == 1)
                   recOK = 0;
                   while (recOK == 1)
                       recOK = c_cmd_ask_yesno('Start the recordings now. Are the recordings started? ');
                   end
                   vt_enabled = 0;
               end
            end
        end
    end
    
end

if (bChanged == 1)
    bSave = c_cmd_ask_yesno('Do you want to save the new remote PC address to the settings file?');
    if (bSave)
        cfg_filename = [settings_path 'settings.mat'];
        pref_file = matfile(cfg_filename, 'writable', true);
        pref_file.remotePC = vt_settings.server;
    end
end

%if (vt_enabled ~= 1)
%    disp('<strong>WARNING: VIDEO TRIGGER/RECORDING IS DISABLED</strong>');
%end

