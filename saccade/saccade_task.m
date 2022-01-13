


exp_version_date = c_last_file_date(tools_paths);

[keyDevice, barcodeKB] = c_find_keyboards();

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

[hwnd, ~, scrW, scrH] = c_setup_screen(1, color_calib * [127 127 127], 0);
fps = 60;
c_make_colors(hwnd);
c_default_keys();



%% Load images.
disp('Loading images...');

tex_peri = cell(1, 3);
rsrc_peri = cell(1, 3);
[tex_peri{1}, rsrc_peri{1}] = c_load_image([media_path 'saccade/img_face01.png'], hwnd); %SAD
[tex_peri{2}, rsrc_peri{2}] = c_load_image([media_path 'saccade/img_face02.png'], hwnd); %HAPPY
[tex_peri{3}, rsrc_peri{3}] = c_load_image([media_path 'saccade/img_face03.png'], hwnd); %NEUTRAL
[tex_cent, rsrc_cent] = c_load_image([media_path 'saccade/img_gap_cs_clock.png'], hwnd);

c_kkc_load_common_images(hwnd);
[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);



%% Load attention grabbers audio and videos.
disp('Loading audio...');
InitializePsychSound
saccade_loadsoundbuffers;


disp('Loading video...');
[att_vids] = c_kkc_load_attention_video();



%% Define screen position of images.
disp('Calculating stimuli screen locations...');

rdst_peri_stim_left_cm  = [ 0, 0, 3, 3 ] + [ 1.5 0 1.5 0 ];
rdst_peri_stim_right_cm = [ 0, 0, 3, 3 ] - [ 4.5 0 4.5 0 ] + [ scrW_cm 0 scrW_cm 0 ];
rdst_cent_stim_cm       = [ 0, 0, 3, 3 ];

rdst_peri_stim_left  = c_rec_cm2pix(rdst_peri_stim_left_cm,  scrW, scrH, scrW_cm, scrH_cm);
rdst_peri_stim_right = c_rec_cm2pix(rdst_peri_stim_right_cm, scrW, scrH, scrW_cm, scrH_cm);
rdst_cent_stim       = c_rec_cm2pix(rdst_cent_stim_cm,       scrW, scrH, scrW_cm, scrH_cm);

rdst_peri_stim_left  = c_rec_center(rdst_peri_stim_left,  0, 1, scrW, scrH);
rdst_peri_stim_right = c_rec_center(rdst_peri_stim_right, 0, 1, scrW, scrH);
rdst_cent_stim       = c_rec_center(rdst_cent_stim,       1, 1, scrW, scrH);

% AOI's for gaze contingency, put back to old, more precise settings 20170221
rgaze_peri_stim_left =  c_rec_resize(rdst_peri_stim_left, 3);  %[0 0 floor(0.35*scrW) scrH]; 
rgaze_peri_stim_right = c_rec_resize(rdst_peri_stim_right, 3); %[ceil(0.65*scrW) 0 floor(1.0*scrW) scrH];
rgaze_cent_stim =       c_rec_resize(rdst_cent_stim, 3);       %[floor(0.35*scrW) 0 ceil(0.65*scrW) scrH];

rgaze_peri_stim_left_schema =  c_rec_resize(rdst_peri_stim_left, 3);
rgaze_peri_stim_right_schema = c_rec_resize(rdst_peri_stim_right, 3);



%% Animations.
stimLoomFrames  = 18;
stimLoomAnim    = [0,   0.7; ...
                   0.8, 3  ; ...
                   0.9, 4.5; ...
                   1.0, 3  ];
[framesLoom] = AnimToFrames(stimLoomAnim, stimLoomFrames);

rdst_cent_loom = cell(1, stimLoomFrames);
for i = 1 : stimLoomFrames
    rdst_cent_loom{i} = [0, 0, framesLoom(i), framesLoom(i)];
    rdst_cent_loom{i} = c_rec_cm2pix(rdst_cent_loom{i}, scrW, scrH, scrW_cm, scrH_cm);
    rdst_cent_loom{i} = c_rec_center(rdst_cent_loom{i}, 1, 1, scrW, scrH);
end

%---------------------

stimThrobFrames = 20;
stimThrobAnim   = [0,   5; ...
                   0.5, 3; ...
                   1.0, 5];
[framesThrob] = AnimToFrames(stimThrobAnim, stimThrobFrames);

rdst_cent_throb = cell(1, stimThrobFrames);
for i = 1 : stimThrobFrames
    rdst_cent_throb{i} = [0, 0, framesThrob(i), framesThrob(i)];
    rdst_cent_throb{i} = c_rec_cm2pix(rdst_cent_throb{i}, scrW, scrH, scrW_cm, scrH_cm);
    rdst_cent_throb{i} = c_rec_center(rdst_cent_throb{i}, 1, 1, scrW, scrH);
end

%---------------------

stimThrobFrames_peri = 15;
stimThrobAnim_peri   = [0,   5; ...
                        0.5, 3; ...
                        1.0, 5];
[framesThrob_peri] = AnimToFrames(stimThrobAnim_peri, stimThrobFrames_peri);

rdst_peri_throb_left = cell(1, stimThrobFrames_peri);
rdst_peri_throb_right = cell(1, stimThrobFrames_peri);
for i = 1 : stimThrobFrames_peri
    rdst_peri_throb_left{i} = [-framesThrob_peri(i)/2, 0, framesThrob_peri(i)/2, framesThrob_peri(i)] + [ 3 0 3 0 ];
    rdst_peri_throb_left{i} = c_rec_cm2pix(rdst_peri_throb_left{i}, scrW, scrH, scrW_cm, scrH_cm);
    rdst_peri_throb_left{i} = c_rec_center(rdst_peri_throb_left{i}, 0, 1, scrW, scrH);
    
    rdst_peri_throb_right{i} = [-framesThrob_peri(i)/2, 0, framesThrob_peri(i)/2, framesThrob_peri(i)] - [ 3 0 3 0 ] + [ scrW_cm 0 scrW_cm 0 ];
    rdst_peri_throb_right{i} = c_rec_cm2pix(rdst_peri_throb_right{i}, scrW, scrH, scrW_cm, scrH_cm);
    rdst_peri_throb_right{i} = c_rec_center(rdst_peri_throb_right{i}, 0, 1, scrW, scrH);
end

%---------------------

stimShrinkFrames = 60;
stimShrinkAnim = [0, 3;...
                  1, 0.01];
[framesShrink] = AnimToFrames(stimShrinkAnim, stimShrinkFrames);

rdst_peri_shrink_left = cell(1, stimShrinkFrames);
rdst_peri_shrink_right = cell(1, stimShrinkFrames);
for i = 1 : stimShrinkFrames
    rdst_peri_shrink_left{i} = [-framesShrink(i)/2, 0, framesShrink(i)/2, framesShrink(i)] + [ 3 0 3 0 ];
    rdst_peri_shrink_left{i} = c_rec_cm2pix(rdst_peri_shrink_left{i}, scrW, scrH, scrW_cm, scrH_cm);
    rdst_peri_shrink_left{i} = c_rec_center(rdst_peri_shrink_left{i}, 0, 1, scrW, scrH);
    
    rdst_peri_shrink_right{i} = [-framesShrink(i)/2, 0, framesShrink(i)/2, framesShrink(i)] - [ 3 0 3 0 ] + [ scrW_cm 0 scrW_cm 0 ];
    rdst_peri_shrink_right{i} = c_rec_cm2pix(rdst_peri_shrink_right{i}, scrW, scrH, scrW_cm, scrH_cm);
    rdst_peri_shrink_right{i} = c_rec_center(rdst_peri_shrink_right{i}, 0, 1, scrW, scrH);
end



%% Trial conditions.
disp('Setting up trial conditions...');

trials_rondom0 = [ 1 1 2 2 3 3 ;  % 1=GAP, 2=OVERLAP, 3=BASELINE
                   1 2 1 2 1 2 ];  % 1=RIGHT, 2=LEFT
                %  3 3 3 3 3 3 ]; % 3=NEUTRAL
order_rondom0a = c_randomise_conditions(trials_rondom0, 2);
order_rondom0b = c_randomise_conditions(trials_rondom0, 2);
order_rondom0c = c_randomise_conditions(trials_rondom0, 2);
order_rondom0d = c_randomise_conditions(trials_rondom0, 2);
order_rondom0e = c_randomise_conditions(trials_rondom0, 2);
order_rondom0 = [order_rondom0a order_rondom0b order_rondom0c order_rondom0d order_rondom0e];
trials_rondom0 = [trials_rondom0; 3*ones(1, 6)];

trials_pro = trials_rondom0;
order_pro = order_rondom0;

trials_anti = trials_rondom0;
order_anti = order_rondom0;

disp('Saving conditions...')
save([logpath logtag '_conditions.mat'], 'trials_rondom0', 'order_rondom0', 'trials_pro', 'order_pro', 'trials_anti', 'order_anti'); %, 'trials_neutral', 'order_neutral'



%% Some task initialization.

disp('Initializing keyboard...')
c_kbqueue_init(keyDevice);
c_kbqueue_start(keyDevice);

%--------------------------------------------------------------------------

numSamples = 6;

switch (Rondom)
    case 0
        explanation = 0;
    case 3
        explanation = 1;
    case 9
        explanation = 1;
    otherwise
        disp('WARNING: invalid value for rondom');
        explanation = 1;
end

%--------------------------------------------------------------------------

% if ((do_neutral + do_prosaccade + do_antisaccade) ~= 1)
%     disp('<strong>WARNING: Cannot run all task at once, only the first will be run</strong>');
% end
% if (do_neutral)
%     task_type = 1;
%     do_prosaccade = 0;
%     do_antisaccade = 0;
% elseif (do_prosaccade)
%     task_type = 2;
%     do_antisaccade = 0;
% else
%     task_type = 3;
% end

bQuit = 0;
conditions = [];
task_name = '';
switch (task_type)
    %case 1
    %    task_name = 'Neutral';
    %    conditions = trials_neutral;
    %    order = order_neutral;
    case 2
        task_name = 'Prosaccade';
        conditions = trials_pro;
        order = order_pro;
    case 3
        task_name = 'Antisaccade';
        conditions = trials_anti;
        order = order_anti;
    case 4
        task_name = 'Rondom0';
        conditions = trials_rondom0;
        order = order_rondom0;
    otherwise
        disp('<strong>ERROR: No task defined, quitting</strong>');
        bQuit = 1;
end

[m_cond, n_cond] = size(conditions);
count_valid = zeros(1, n_cond);



%--- TRIALS ---------------------------------------------------------------

% all_trial_info = [];

if (bQuit == 0)
    disp(['<strong>Running ' task_name ' task</strong>']);
    
    %task_type = 2;
    if (explanation == 1)
        disp('Explanation started. (please give instructions to the participant)')
        disp('Press "space" to move forward "t" to move back, or "tab" to start the task');
        saccade_schema;
    else
        c_kkc_intro_video(hwnd, scrW, scrH);
		saccade_loadsoundbuffers;
    end
    
    
    trials_run = 0;
    
    if (bQuit == 0)
        
        c_kbqueue_stop(keyDevice);
        c_kbqueue_destroy(keyDevice);
        
        % Eye tracker first calibration.
		calib_count = 1;
		hwnd_calib	= c_et_start_first_calib( eyetracking, hwnd, logpath, logtag );
		
		saccade_loadsoundbuffers;
        
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
                
                trial_type = conditions(1, order(trial));
                trial_side = conditions(2, order(trial));
                trial_img = conditions(3, order(trial));
                if (task_type == 3)
                    gaze_side = mod(trial_side, 2) + 1;
                else
                    gaze_side = trial_side;
                end
                
                reward_anim = randi(3) - 1;
                reward_spin = (reward_anim < 2);
                
                saccade_trial;
				
                if (bRestartTrial == 0)
                    if ((gazed_cent == 1) && (gazed_peri == 1))
                        count_valid(order(trial)) = count_valid(order(trial)) + 1;
                    end
                end
            end
            
            if (bQuit)
                break;
			end
			
			% Convert gazeData into 'old' SDK format.
			[all_leftEye, all_rightEye, convtimestamps, deviceTimeStamps] = c_convert_tobii_gazedata_format( gazeDataTrial );
			
			% Save single-trial data.
			save(fullfile( perTrialFolder, [logtag '_trial_' num2str(trial) '.mat']), 'task_type', 'trial', 'trial_type', 'trial_side', 'trial_img', 'flip_onsets', 'flip_counts', 'flip_breaks', 'timestampsPtbStimulusOnset', 'timestampsTobiiSystem', 'timestampsPtbGetSecs' );
			save(fullfile( perTrialFolder, [logtag '_gazedata_' num2str(trial) '.mat']), 'all_leftEye', 'all_rightEye', 'convtimestamps', 'trackerID');
            
            
            % Accumulate all onsets upto the current trial and save them.
            all_onsets = [ all_onsets; flip_onsets ]; %#ok<*AGROW>
            all_counts = [ all_counts; flip_counts ];

            save(fullfile( perTrialFolder, [logtag '_onsets_upto_trial_' num2str(trial) '.mat']), 'all_onsets', 'all_counts' );
            
            
            trials_run = trials_run + 1;
            
            %if ((task_type == 4) && (trials_run == 48))
            if (trials_run == 48)
                counts_gaps_ok = sum(reshape(count_valid, 2, 3), 1);
                if (sum(counts_gaps_ok >= 12) == length(counts_gaps_ok))
                    disp('Skipping extra block')
                    break;
                else
                    disp('Starting extra block')
                end
            end
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

saccade_zipandcleanup;



%% End.
disp('<strong>All done and all saved</strong>');
c_endmsg_locked_imgonly(hwnd, 1, black, 28, 0, text_instruction, 0, []);
sca;