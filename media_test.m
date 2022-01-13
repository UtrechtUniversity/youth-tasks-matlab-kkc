clc; clear; close all

kkcpath;
disp(kkc_main_path);
disp(' ');

addpath([kkc_main_path '/COMMON']);

lstFold = cell(1,13);
lstTypes = cell(1,13);

lstFold{1} = 'MEDIA/peabody/audio_main';           lstTypes{1} = 'wav';
lstFold{2} = 'MEDIA/peabody/audio_pract';          lstTypes{2} = 'wav';

lstFold{3} = 'MEDIA/emotionalface/audio';          lstTypes{3} = 'wav';
lstFold{4} = 'MEDIA/restingstate/audio';           lstTypes{4} = 'wav';
lstFold{5} = 'MEDIA/restingstate/video';           lstTypes{5} = 'mp4';

lstFold{6} = 'MEDIA/popout';                       lstTypes{6} = 'wav';
lstFold{7} = 'MEDIA/popout/attention_grabber';     lstTypes{7} = 'wav';
lstFold{8} = 'MEDIA/saccade';                      lstTypes{8} = 'wav';
lstFold{9} = 'MEDIA/saccade/attention_grabber';    lstTypes{9} = 'wav';
lstFold{10} = 'MEDIA/socialgaze/audio';            lstTypes{10} = 'wav';

lstFold{11} = 'COMMON/media_calib';                lstTypes{11} = 'wav';
lstFold{12} = 'COMMON/media_calib';                lstTypes{12} = 'mp4';   %(mv4)
lstFold{13} = 'COMMON/media_common';               lstTypes{13} = 'mp4';

for i = 1 : length(lstFold)
    disp([num2str(i) ') ' lstFold{i} ' - ' lstTypes{i}]);
end
disp(' ');

F = input('Select media folder: ');
disp(' ');

curFolder = [kkc_main_path '/' lstFold{F} '/'];
disp(curFolder);
disp(' ');
lstDir = dir([curFolder '*.' lstTypes{F}]);
lstFiles = [];
j=0;
for i = 1 : length(lstDir)
    curName = lstDir(i).name;
    if (curName(1) ~= '.')
        j=j+1;
        lstFiles{j} = [curFolder curName];
        disp(lstFiles{j});
    end
end
disp(' ');

switch (lstTypes{F})
    case 'wav'
        disp('Loading audio...');
        
        n_aud = length(lstFiles);
        aud = cell(1,n_aud);
        snd = cell(1,n_aud);
        fs = zeros(1,n_aud);
        nchan = zeros(1,n_aud);
        for i = 1 : n_aud
            [aud{i}, snd{i}, fs(i), nchan(i)] = c_load_audio(lstFiles{i});
        end
        
        disp(' ');
        disp('Playing audio...');
        for i = 1 : n_aud
            disp(lstFiles{i});
            PsychPortAudio('Start', aud{i}, 1, 0, 0);
            PsychPortAudio('Stop', aud{i}, 1, 1);
        end
        
    case 'mp4'
        disp('Loading video...');
        
        %[keyDevice, barcodeKB] = c_find_keyboards();
        
        backcolor = [108 108 108];
        c_default_keys;
        [hwnd, fps, scrW, scrH] = c_setup_screen(0, backcolor, 0);
        c_make_colors(hwnd);
        fps = 60;
        
        %disp('Initializing keyboard...')
        %c_kbqueue_init(keyDevice);
        %c_kbqueue_start(keyDevice);
        
        i = 1;
        while i <= length(lstFiles)
            video_file = lstFiles{i};
            continue_on_key = 1;
            %att_keycheck = 1;
            en_go_back = 1;
            bBack = 0;
            c_play_video;
            
            if (bBack == 1)
                i=max(1,i-1);
            else
                i=i+1;
            end
            
            if (i > length(lstFiles))
                disp('All video files played');
                if (c_cmd_ask_yesno('Replay last video?') == 1)
                    i=i-1;
                end
            end
        end
        
        %c_kbqueue_stop(keyDevice);
        %c_kbqueue_destroy(keyDevice);
        
        sca
        
    otherwise
        disp(['Error: Unknown type ' lstTypes{F}]);
end

disp('DONE');


