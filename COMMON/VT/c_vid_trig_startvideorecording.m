disp('Starting video recording...')
[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.start_rec, []);
if (isempty(msg) || (msg ~= 1))
    disp('<strong>CRITICAL ERROR: Could not start video recording.</strong>');
    disp('<strong>WARNING: VIDEO TRIGGER/RECORDING IS DISABLED</strong>');
    vt_enabled = 0;

    bsOK = 0;
    while (bsOK == 0)
        bsOK = c_cmd_ask_yesno('Please check the above error before continuing');
    end
end

% Add pause to make sure the receiving computer has time.
pause(.5);

%disp('Bringing recording window to front...')
%[msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.bring_front, []);