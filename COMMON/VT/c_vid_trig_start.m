
if (vt_enabled ~= 1)
    disp('<strong>WARNING: VIDEO TRIGGER/RECORDING IS DISABLED</strong>');
    disp(' ')
    bsOK = c_cmd_ask_yesno('Please start Biosemi manually and start the recording ');
    disp(' ')
    bsOK = c_cmd_ask_yesno('Set any Biosemi settings you would like to change');
    disp(' ')
    bsOK = c_cmd_ask_yesno('Please start the video recording (click start file)');
    disp(' ')
    
else
    
    disp('Setting up remote recording server');
    
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_tag, logtag);
	
	% Check return code.
	if msg ~= 1
		errorMessage = '<strong>CRITIAL ERROR: log tag not send correctly. Please restart MATLAB.</strong>\n\n';
		fprintf( 1, errorMessage );
		error( errorMessage );
	end
	
	% Add pause to make sure the receiving computer has time to set the logtag.
	pause(.5);
    
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_biosemi_path, []);
    if (isempty(msg) || (msg ~= 1))
        disp('<strong>WARNING: Could not configure Biosemi, please check configuration and savefile !!!.</strong>');
        
        bsOK = 0;
        while (bsOK == 0)
            bsOK = c_cmd_ask_yesno('Please check the above warning before continuing');
        end
    end
    
    % Add pause to make sure the receiving computer has time.
	pause(.5);
    
    disp('Opening video device...')
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.open_device, vt_settings.cam_settings);
    if (isempty(msg) || (msg ~= 1))
        disp('<strong>CRITICAL ERROR: Could not open video device.</strong>');
        disp('<strong>WARNING: VIDEO TRIGGER/RECORDING IS DISABLED</strong>');
        vt_enabled = 0;
        
        bsOK = 0;
        while (bsOK == 0)
            bsOK = c_cmd_ask_yesno('Please check the above error before continuing');
        end
    end
    
    % Add pause to make sure the receiving computer has time.
	pause(.5);
    
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
    
    biosemiOK = 0;
    while (biosemiOK == 0)
        disp('Opening Biosemi...');
        [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.start_biosemi, []);
        if (isempty(msg) || (msg == 0))
            disp('<strong>WARNING: Could not start Biosemi, please start it manually</strong>');
            
            bsOK = 0;
            while (bsOK == 0)
                bsOK = c_cmd_ask_yesno('Please check the above warning before continuing');
            end
            
            biosemiOK = 1;
        elseif (msg == 2)
            if (eeg_autopilot == 0)
                disp('<strong>WARNING: Biosemi is already running, possibly from previous task</strong>');
        
                bsOK = c_cmd_ask_yesno('Do you want to continue with the current biosemi instance?');
                if (bsOK == 1)
                    biosemiOK = 1;
                else
                    bsOK = 0;
                    while (bsOK == 0)
                        bsOK = c_cmd_ask_yesno('Please close biosemi and enter Y to continue');
                    end
                end
            else
                biosemiOK = 1;
            end
        else %if (msg == 1)
            biosemiOK = 1;
        end
        
        % Add pause to make sure the receiving computer has time.
        pause(.5);
    end
    
    if (eeg_autopilot == 0)
        disp('<strong>Set any Biosemi settings you would like to change</strong>');
        bsOK = 0;
        while (bsOK == 0)
            bsOK = c_cmd_ask_yesno('Ready to continue?');
        end
        
        disp('<strong>Please start the Biosemi recording (click start file)</strong>');
        bsOK = 0;
        while (bsOK == 0)
            bsOK = c_cmd_ask_yesno('Is the biosemi recording started?');
        end
    end
    
    
    disp('done');
    
end

