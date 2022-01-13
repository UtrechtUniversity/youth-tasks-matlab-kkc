Block = 19;
trials = 25;
stimselect = 10;
% begin van het exp:
% Settings for photodiode - BioSemi
time_out_secs  = 10;
% t_box_handle = init_photodiode('/dev/cu.KeySerial1');
% t_box_handle = init_photodiode('/dev/cu.usbmodem26221');
t_box_handle = init_photodiode( );

EEGpres = 1;
% voordat je de stimulus presenteert:

                if EEGpres == 1 % for BioSemi
                    send_code(t_box_handle,Block); % for BioSemi
                    send_code(t_box_handle,0); % for BioSemi
                    send_code(t_box_handle,trials); % for BioSemi
                    send_code(t_box_handle,0); % for BioSemi

                    if stimselect<5;
                        send_code(t_box_handle,240);
                    elseif stimselect>4;
                        send_code(t_box_handle,250);
                    end
                end

 % nadat je de stimulus presenteert:
                if EEGpres == 1 % for BioSemi
                    if stimselect<5;
                        wait_for_code_back(t_box_handle,time_out_secs,240);
                    elseif stimselect>4;
                        wait_for_code_back(t_box_handle,time_out_secs,250);
                    end
                    send_code(t_box_handle,0); % for BioSemi
                end


% einde van het exp:
close_photodiode(t_box_handle);
