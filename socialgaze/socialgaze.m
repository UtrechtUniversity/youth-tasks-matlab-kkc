
[keyDevice, barcodeKB] = c_find_keyboards();

exp_version_date = c_last_file_date(tools_paths);

diodesize = 75;


%% Initialize eyetracker.

c_et_load_settings(0);

R0_counter_etframerate	= true;
trackerOK				= c_et_init(eyetracking, R0_counter_etframerate);

% Global reference to eyetracker object.
global eyeTracker eyeTrackingOperations %#ok<NUSED>

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

[hwnd, ~, scrW, scrH] = c_setup_screen(1, color_calib * [131 131 131], 0);
fps = 60;
c_make_colors(hwnd);
c_default_keys();



%% Constants.
% Constants for left and right target and cue directions, and incongruent or congruent codes.
cond_row_face = 1;
cond_row_IC = 2;
cond_row_LR = 3;
cond_val_right = 1;
cond_val_left = 2;
cond_val_i = 1;
cond_val_c = 2;



%% Load images.
n_faces = 10;
lst_cond = { 'URI' 'URC' 'ULI' 'ULC' }; % do not change condition order
n_cond_per_face = length(lst_cond);

n_img = n_faces * n_cond_per_face;
tex_stim = cell(2, n_img);
rsrc_stim = cell(2, n_img);
comb = NaN( 3, n_img );

for j = 1 : n_cond_per_face
    for i = 1 : n_faces
        k = (i-1) * n_cond_per_face + j;
		
		conditionString = lst_cond{j};
        
        img_file1 = ['face' num2str(i, '%02d') conditionString '_01.bmp'];
        img_file2 = ['face' num2str(i, '%02d') conditionString '_02.bmp'];
        
        [tex_stim{1,k}, rsrc_stim{1,k}] = c_load_image([media_path 'socialgaze/faces/' img_file1], hwnd);
        [tex_stim{2,k}, rsrc_stim{2,k}] = c_load_image([media_path 'socialgaze/faces/' img_file2], hwnd);
		
		
		% Face number.
		faceNr = i;
		
		% Cue direction.
		cueLetter			= conditionString(2);
		congruenceLetter	= conditionString(3);
		
		% Convert cue letters into integer codes.
		switch cueLetter
			case 'L'
				cueCode = cond_val_left;
			case 'R'
				cueCode = cond_val_right;
		end
		
		% Convert congruence letters into integer codes.
		switch congruenceLetter
			case 'I'
				congruenceCode = cond_val_i;
			case 'C'
				congruenceCode = cond_val_c;
		end
		
		% Put codes into 'comb' array.
		comb( cond_row_face, k )	= faceNr;
		comb( cond_row_IC, k )		= congruenceCode;
		comb( cond_row_LR, k )		= cueCode;
    end
end

lst_targets = dir([media_path 'socialgaze/targets/*.png']);
n_targets = length(lst_targets);
tex_target = cell(1, n_targets);
rsrc_target = cell(1, n_targets);

for i = 1 : n_targets
    [tex_target{i}, rsrc_target{i}] = c_load_image([media_path 'socialgaze/targets/' lst_targets(i).name], hwnd);
end

[tex_fix, rsrc_fix] = c_load_image([media_path 'socialgaze/red.png'], hwnd);

[tex_exp, rsrc_exp] = c_load_image([media_path 'socialgaze/img_face.png'], hwnd);

c_kkc_load_common_images(hwnd);
[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);



%% Load attention grabbers audio and videos.

disp('Loading audio...');
InitializePsychSound;
socialgaze_loadsoundbuffers;


disp('Loading video...');
[att_vids] = c_kkc_load_attention_video();



%% Define screen position of images.

rdst_cent_exp = rsrc_exp;
rdst_cent_exp = c_rec_center(rdst_cent_exp, 1, 1, scrW, scrH);

exp_target = 1;
tarScale = 0.5;
horTarPos = 0.5 * rsrc_target{exp_target}(3)/2;

rdst_peri_exp_right = [scrW-horTarPos-tarScale*rsrc_target{exp_target}(3)/2 scrH/2-tarScale*rsrc_target{exp_target}(4)/2 ...
                       scrW-horTarPos+tarScale*rsrc_target{exp_target}(3)/2 scrH/2+tarScale*rsrc_target{exp_target}(4)/2];
rdst_peri_exp_left  = [horTarPos-tarScale*rsrc_target{exp_target}(3)/2 scrH/2-tarScale*rsrc_target{exp_target}(4)/2 ...
                       horTarPos+tarScale*rsrc_target{exp_target}(3)/2 scrH/2+tarScale*rsrc_target{exp_target}(4)/2];

rgaze_peri_exp_right_schema = [scrW-horTarPos-200 scrH/2-200 ...
                         scrW-horTarPos+200 scrH/2+200];
rgaze_peri_exp_left_schema  = [horTarPos-200 scrH/2-200 ...
                         horTarPos+200 scrH/2+200];

% back to small gaze contingency AOI's on 20170221 (JE), so commenting out below:                       
%rgaze_peri_exp_left =  [0 0 floor(0.35*scrW) scrH];
%rgaze_peri_exp_right = [ceil(0.65*scrW) 0 floor(1.0*scrW) scrH];
rgaze_peri_exp_left =  c_rec_resize(rdst_peri_exp_left, 3);  %[0 0 floor(0.35*scrW) scrH]; 
rgaze_peri_exp_right = c_rec_resize(rdst_peri_exp_right, 3); %[ceil(0.65*scrW) 0 floor(1.0*scrW) scrH];


% Number of samples for averaging gaze data.
numSamples		= 6;



%% Trial conditions.

blocks = 1;

if (task_type == 0)
    n_repeat = 1;
elseif (task_type == 9)
    n_repeat = 2;
else
    error('Task type must be 0 or 9. Please contact the lab technician.');
end

order = c_randomise_conditions(comb, n_repeat);

order_targets = 1 : n_targets;
order_targets = repmat(order_targets, 1, ceil(length(order) / n_targets));
order_targets = Shuffle(order_targets);



%% Some task initialization.

disp('Initializing keyboard...')
c_kbqueue_init(keyDevice);
c_kbqueue_start(keyDevice);

numbOfSamples = 6;

if (Rondom == 0)
    avertedGazeMin = 1.3;
    avertedGazeMax = 1.7;
else
    avertedGazeMin = 0.3;
    avertedGazeMax = 0.5;
end


task_name = 'Social Gaze';
%task_type = 1;
bQuit = 0;

switch (Rondom)
    case 0
        explanation = 0;
    case 9
        explanation = 1;
    otherwise
        disp('WARNING: invalid value for rondom');
        explanation = 1;
end


%--- TRIALS ---------------------------------------------------------------

all_trial_info = [];

if (bQuit == 0)
    disp(['<strong>Running ' task_name ' task</strong>']);
    
	if (explanation == 1)
        disp('Explanation started. (please give instructions to the participant)')
        disp('Press "space" to move forward "t" to move back, or "tab" to start the task');
        socialgaze_schema;
    else
        c_kkc_intro_video(hwnd, scrW, scrH);
	end
	
	trials_run = 0;
    
    if (bQuit == 0)
        
        c_kbqueue_stop(keyDevice);
        c_kbqueue_destroy(keyDevice);
        
		% Eye tracker first calibration.
		calib_count = 1;
		hwnd_calib	= c_et_start_first_calib( eyetracking, hwnd, logpath, logtag );
		
		socialgaze_loadsoundbuffers;
        
        c_kbqueue_init(keyDevice);
        c_kbqueue_start(keyDevice);
		
		% Start eyetracker.
		if eyetracking
			eyeTracker.get_gaze_data;
		end
		
		
		% Path for saving per-trial mat files.
		perTrialFolder = fullfile( logpath, 'Per_trial' );
		if ~exist( perTrialFolder, 'dir' ), mkdir(perTrialFolder); end
        
        
        % Arrays to store the cumulative onsets.
        all_onsets = [];
        all_counts = [];
		
        
        for trial = 1 : length(order)
            
            bRestartTrial = 1;
			while (bRestartTrial == 1)
                bRestartTrial = 0;
                fprintf('Starting trial %d\n', trial)
                
                currentTexture = order(trial);
                currentLR = comb(cond_row_LR, order(trial));
                currentIC = comb(cond_row_IC, order(trial));
                currentTarget = order_targets(trial);
                if (currentIC == cond_val_c)
                    currentTarget_LR = currentLR;
                elseif (currentLR == cond_val_left)
                    currentTarget_LR = cond_val_right;
                else
                    currentTarget_LR = cond_val_left;
                end
                
                socialgaze_trial;
			end
            
			if (bQuit)
                break;
			end
			
			% Convert gazeData into 'old' SDK format.
			[all_leftEye, all_rightEye, convtimestamps, deviceTimeStamps] = c_convert_tobii_gazedata_format( gazeDataTrial );
			
			% Save gaze data per trial.
			save(fullfile( perTrialFolder, [logtag '_trial_' num2str(trial) '.mat']), 'task_type', 'trial', 'currentTexture', 'currentLR', 'currentIC', 'currentTarget', 'currentTarget_LR', 'flip_onsets', 'flip_counts', 'flip_breaks', 'timestampsPtbStimulusOnset', 'timestampsTobiiSystem', 'timestampsPtbGetSecs' );
			save(fullfile( perTrialFolder, [logtag '_gazedata_' num2str(trial) '.mat']), 'all_leftEye', 'all_rightEye', 'convtimestamps', 'trackerID');
%             
%             all_trial_info(end+1,1:14) = [task_type, currentTexture, currentLR, currentIC, currentTarget, currentTarget_LR, gazed_cent, gazed_peri, (gazed_cent & gazed_peri), flip_onsets];


            % Accumulate all onsets upto the current trial and save them.
            all_onsets = [ all_onsets; flip_onsets ]; %#ok<*AGROW>
            all_counts = [ all_counts; flip_counts ];

            save(fullfile( perTrialFolder, [logtag '_onsets_upto_trial_' num2str(trial) '.mat']), 'all_onsets', 'all_counts' );
            
            
            trials_run = trials_run + 1;
		end
    end
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

socialgaze_zipandcleanup;



%% End.
disp('<strong>All done and all saved</strong>');
c_endmsg_locked_imgonly(hwnd, 1, black, 28, 0, text_instruction, 0, []);
sca;