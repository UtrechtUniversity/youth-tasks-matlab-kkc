
try
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.stop_rec, []);
    [msg] = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.close_device, []);
catch
    disp('<strong>Error: unable to close recording, connection was terminated unexpectedly.</strong>');
    disp('<strong>Please close the video recording manually.</strong>');
end
