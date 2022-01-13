clc; clear; close all

%[script_path, script_name, script_ext] = fileparts(mfilename('fullpath'));
%addpath([script_path '/.../']);

addpath('../../COMMON/');



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



backcolor = [0 0 0];

[hwnd, fps, scrW, scrH] = c_setup_screen(1, backcolor, 0);
fps = 60;

diodesize = 100;

for i = 1 : 10
    
    for j = 1 : 100
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        Screen('Flip', hwnd);
    end
    
    if EEGpres == 1 % for BioSemi
        tic;
        send_code(t_box_handle,Block); % for BioSemi
        s = toc
        tic;
        send_code(t_box_handle,Block+1); % for BioSemi
        s = toc
        tic;
        send_code(t_box_handle,0); % for BioSemi
        s = toc
        send_code(t_box_handle,trials); % for BioSemi
        send_code(t_box_handle,0); % for BioSemi
        
        tic;
        for k = 50 : 80
            send_code(t_box_handle,k);
            send_code(t_box_handle,0);
        end
        t = toc
        
        if stimselect<5;
            send_code(t_box_handle,240);
        elseif stimselect>4;
            send_code(t_box_handle,250);
        end
    end
    
    for j = 1 : 60
        Screen('FillRect', hwnd, [0 0 0], [0 0 diodesize diodesize]);
        Screen('Flip', hwnd);
    end
    
    for j = 1 : 20
        Screen('FillRect', hwnd, [255 255 255], [0 0 diodesize diodesize]);
        Screen('Flip', hwnd);
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
    
end



% einde van het exp:
close_photodiode(t_box_handle);

sca;