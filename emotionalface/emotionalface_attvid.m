

    if ((task_button == 1) && (show_button == 1))
        show_button = 0;
        emotionalface_buttontrial;
    end
    

    disp('Playing video, press "tab" to continue');
    
    if ((en_diode == 1) && (practice ~= 1))
        send_code(t_box_handle, 121);
        send_code(t_box_handle, 0);
    end
    
    cur_vid = att_last_vid;
    while (cur_vid == att_last_vid)
        cur_vid = randi(length(att_vids));
    end
    att_last_vid = cur_vid;
    video_file = att_vids{cur_vid};
    continue_on_key = 1;
    vid_rec = [scrW/4 scrH/4 3*scrW/4 3*scrH/4];
    show_diode_square = 1;
    trigger_diode = 0;
    c_play_video;
	emotionalface_loadsoundbuffers;
    bRestartTrial = 1;
    
    