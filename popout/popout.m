%% POPOUT TASK.

[keyDevice, barcodeKB] = c_find_keyboards();

diodesize = 75;



%% Initialize eyetracker.

c_et_load_settings(0);

R0_counter_etframerate	= true;
trackerOK				= c_et_init(eyetracking, R0_counter_etframerate);

if ~trackerOK
	fprintf( 1, 'Eye tracker initialization failed.\n' );
	return;
end


% Open master audio handle. For the playback of the individual attention
% grabbers, 'slaves' are opened from this master.
InitializePsychSound;
PsychPortAudio( 'Close' );
global hAudioMaster
hAudioMaster = PsychPortAudio( 'Open', [], 1+8 );
PsychPortAudio('Start', hAudioMaster, 0, 0, 1);



%% Screen and key set-up.

global color_calib;
color_calib = 1;

[hwnd, ~, scrW, scrH] = c_setup_screen(1, color_calib * [127 127 127], 0);
fps = 60;
c_make_colors(hwnd);
c_default_keys();



%% Load images.

% POSSIBLE IMPROVEMENT: loading multiple images and making textures causes PTB to give a warning
% about a synchronization failure. How can we improve this?

n_stim = 6;
tex_stim = cell(1, n_stim);
rsrc_stim = cell(1, n_stim);
for i = 1 : n_stim
    img_file1 = ['POPOUT' num2str(i) '.tif'];
    [tex_stim{i}, rsrc_stim{i}] = c_load_image([media_path 'popout/' img_file1], hwnd);
end

[tex_isi, rsrc_isi] = c_load_image([media_path 'popout/ISI.bmp'], hwnd);

c_kkc_load_common_images(hwnd);

[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);


rdst_stim = cell(1, n_stim);
for i = 1 : n_stim
	rdst_stim{i} = c_resize_to_screen(rsrc_stim{i}, scrW, scrH);
end



%% Load attention grabbers audio and videos.

disp('Loading audio...');
InitializePsychSound
popout_loadsoundbuffers;


disp('Loading video...');
[att_vids] = c_kkc_load_attention_video();



%% Other load things.

width_isi = rsrc_isi(3) - rsrc_isi(1);
height_isi = rsrc_isi(4) - rsrc_isi(2);
roi_isi = [(scrW - 1.5*width_isi) / 2, (scrH - 1.5*height_isi) / 2, (scrW + 1.5*width_isi) / 2, (scrH + 1.5*height_isi) / 2];

aoi_stim = cell(1, n_stim);
for i = 1 : n_stim
    aoi_file1 = ['POPOUT' num2str(i) '.tif.mat'];
    aoi_stim{i} = load([media_path 'popout/aoi/' aoi_file1]);
end


%% Intro video.

c_kkc_intro_video(hwnd, scrW, scrH);
popout_loadsoundbuffers;



%% Stimulus settings.

stimDuration	= 10;
isiDuration		= 1;
numSamples		= 6;

dTBreak = 1 / (2*fps);

ind_aud_trial = Shuffle(1 : length(snd_trial));

order = Shuffle(1 : n_stim);



%% Eyetracker calibration.
calib_count = 1;

hwnd_calib = c_et_start_first_calib( eyetracking, hwnd, logpath, logtag );



%% Initialize keyboard.

disp('Initializing keyboard...');
c_kbqueue_init(keyDevice);
c_kbqueue_start(keyDevice);



%% Task.

popout_loadsoundbuffers;

bQuit = 0;
music_playing = 0;


% Start eyetracker.
global eyeTracker eyeTrackingOperations %#ok<NUSED>
if eyetracking
	eyeTracker.get_gaze_data;
end


% Path for saving per-trial mat files.
perTrialFolder = fullfile( logpath, 'Per_trial' );
if ~exist( perTrialFolder, 'dir' ), mkdir(perTrialFolder); end


% Arrays to store the cumulative onsets.
all_onsets = [];
all_counts = [];


trials_run = 0;
for trial = 1 : length(order)
	cur_tex = order(trial);

	bRestartTrial = 1;
	
	while (bRestartTrial == 1)
		bRestartTrial = 0;
		fprintf('Starting trial %d\n', trial)

		popout_trial;
	end

	if (bQuit)
		break; %#ok<UNRCH>
	end
	
	
	% Convert gazeData into 'old' SDK format.
	[all_leftEye, all_rightEye, convtimestamps, deviceTimeStamps] = c_convert_tobii_gazedata_format( gazeDataTrial );
	

	% Save gaze data per trial.
	save(fullfile( perTrialFolder, [logtag '_gazedata_' num2str(trial) '.mat']), 'all_leftEye', 'all_rightEye', 'convtimestamps', 'trackerID');
	save(fullfile( perTrialFolder, [logtag '_trial_' num2str(trial) '.mat']), 'cur_tex', 'flip_counts', 'flip_onsets', 'flip_breaks', 'timestampsPtbStimulusOnset', 'timestampsTobiiSystem', 'timestampsPtbGetSecs' );
    
    
    % Accumulate all onsets upto the current trial and save them.
    all_onsets = [ all_onsets; flip_onsets ]; %#ok<*AGROW>
    all_counts = [ all_counts; flip_counts ];
    
    save(fullfile( perTrialFolder, [logtag '_onsets_upto_trial_' num2str(trial) '.mat']), 'all_onsets', 'all_counts' );


	trials_run = trials_run + 1;
end



%% Close things.
% Close audio master.
PsychPortAudio( hAudioMaster, 'Close' );


% Stop eye tracker.
if eyetracking
	eyeTracker.stop_gaze_data;
end


% Stop keyboard queue.
c_kbqueue_stop(keyDevice);
c_kbqueue_destroy(keyDevice);



%% End screen.

disp('The task is compeleted.')
disp('<strong>Saving data, this may take a few minutes. Do not close Matlab.</strong>');

text_instruction = ['Dit is het einde van de taak\n\n' ...
                    'Bedankt voor het meedoen'];
c_endmsg_locked_img(hwnd, 0, black, 28, 0, text_instruction, 0, []);



%% Zipping per-trial files.

popout_zipandcleanup;



%% End.

disp('<strong>All done and all saved</strong>');
c_endmsg_locked_imgonly(hwnd, 1, black, 28, 0, text_instruction, 0, []);
sca;