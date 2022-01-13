

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

[hwnd, ~, scrW, scrH] = c_setup_screen(1, color_calib * [195 195 195], 0);
fps = 60;
c_make_colors(hwnd);
c_default_keys();



%% Trial set-up.
 
words = {'banaan' 'koekje' 'bad' 'stoel' 'poes' 'baby' 'hond' 'koe' 'jas' 'schoen' 'hand' 'voet'};
%pairs = {'banaan_koekje' 'koekje_banaan' 'bad_stoel' 'stoel_bad' 'poes_baby' 'baby_poes' 'hond_koe' 'koe_hond' 'jas_schoen' 'schoen_jas' 'hand_voet' 'voet_hand'};
pairmap = [reshape(1:12, 2, 6)'; reshape(12:-1:1, 2, 6)'];
pairmap = [pairmap ones(12,1); pairmap 2*ones(12,1)];
%pairmap = [left_image right_image type]

carrierSentences = {'kijk' 'waar' 'zie'};
positions = {'left' 'right'};

%order = [12 11 10  9  8  7  1  2  3  4  5  6 10  9  2  1  7 11  8 12  6  4  3  5];
%side  = [ 2  1  1  2  2  1  2  1  1  2  2  1  2  1  2  1  2  2  1  1  2  1  2  1];
%sent  = [ 2  3  1  2  1  3  1  3  2  2  3  1  3  1  2  1  3  2  1  3  2  1  2  3];
%vari  = [ 1  1  1  1  1  1  1  1  1  1  1  1  2  2  2  2  2  2  2  2  2  2  2  2];

order = [12 11 10  9  8  7  1  2  3  4  5  6 10  9  2  1  7 11  8 12  6  4  3  5];
side  = [ 2  1  1  2  2  1  2  1  1  2  2  1  2  1  2  1  2  2  1  1  2  1  2  1];
sent  = [ 2  3  1  2  1  3  1  3  2  2  3  1  3  1  2  1  3  2  1  3  2  1  2  3];
vari  = [ 1  1  1  1  1  1  2  2  2  2  2  2  1  1  2  2  1  1  1  1  2  2  2  2];



%% Load images.

c_kkc_load_common_images(hwnd);
[tex_end, rsrc_end] = c_load_image([common_media_path 'while_saving.jpg'], hwnd);

%[tex_fix, rsrc_fix] = c_load_image([media_path 'looklisten/color_star2_EB.jpg'], hwnd);
[tex_fix, rsrc_fix] = c_load_image([media_path 'looklisten/fixstar.png'], hwnd);

n_stim = 24;
tex_stim = cell(n_stim, 2);
rsrc_stim = cell(n_stim, 2);
rdst_stim = cell(n_stim, 2);

for i = 1 : n_stim
    %for j = 1 : 2
    j = vari(i);
        img_name = [words{pairmap(order(i), 1)} '_' words{pairmap(order(i),2)} num2str(j) '.png'];
        [tex_stim{i}, rsrc_stim{i}] = c_load_image([media_path 'looklisten/stimuli/' img_name], hwnd);
        [rdst_stim{i}] = c_resize_to_screen(rsrc_stim{i}, scrW, scrH);
    %end
end

%--------------------------------------------------------------------------

fixationPosition = [scrW/2-(rsrc_fix(3)/2) scrH/2-(rsrc_fix(4)/2) ...
                    scrW/2+(rsrc_fix(3)/2) scrH/2+(rsrc_fix(4)/2)];
rgaze_cent_stim = c_rec_resize(fixationPosition, 2);

lstAOI = cell(1,2);
lstAOI{1} = fixationPosition;
lstAOI{2} = rgaze_cent_stim;



%% Load audio and video.

disp('Loading audio...');
looklisten_loadsoundbuffers;

disp('Loading video...');
[att_vids] = c_kkc_load_attention_video();



%% Other load things.

minFixDuration = 1.5;
minFixGaze = 0.5;
maxFixDuration = 3;

maxTrialDuration = 5;
%eyeOnTarDuration = 0.6;

dTBreak = 1 / (2*fps);

numSamples = 6;



%% Initialize keyboard.

disp('Initializing keyboard...')
c_kbqueue_init(keyDevice);
c_kbqueue_start(keyDevice);



%% Logging
%write_logfile('open', '/Users/jacco/Desktop/', 'looklisten')%logging processing
%write_logfile([datestr(datetime('now')) ' ============ Start LWL ============='])



%% --- TRIALS ---------------------------------------------------------------

all_trial_info = [];

bQuit = 0;
if (bQuit == 0)
    
    c_kkc_intro_video(hwnd, scrW, scrH);
	looklisten_loadsoundbuffers;
    
    trials_run = 0;
    
    if (bQuit == 0)
        
        c_kbqueue_stop(keyDevice);
        c_kbqueue_destroy(keyDevice);
        
        calib_count = 1;
		hwnd_calib = c_et_start_first_calib( eyetracking, hwnd, logpath, logtag );
		looklisten_loadsoundbuffers;
        
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
            
            %bRestartTrial = 1;
            %while (bRestartTrial == 1)
                bRestartTrial = 0;
                fprintf('Starting trial %d\n', trial)
                
                %write_logfile(['Trial: ' num2str(trial)])
                
                %tex_nr = order(trial);
                tex_nr = trial;
                vari_nr = vari(trial);
                word_nr = pairmap(order(trial), side(trial));
                sent_nr = sent(trial);
                
                looklisten_trial;
                
            %end
            
            if (bQuit)
                break;
			end
			
			
			% Convert gazeData into 'old' SDK format.
			[all_leftEye, all_rightEye, convtimestamps, deviceTimeStamps] = c_convert_tobii_gazedata_format( gazeDataTrial );
			
			
			% Save single-trial data.
			save( fullfile( perTrialFolder, [logtag '_trial_' num2str(trial) '.mat'] ), 'task_type', 'trial', 'tex_nr', 'vari_nr', 'word_nr', 'sent_nr', 'flip_onsets', 'flip_counts', 'flip_breaks', 'timestampsPtbStimulusOnset', 'timestampsTobiiSystem', 'timestampsPtbGetSecs' );
			save( fullfile( perTrialFolder, [logtag '_gazedata_' num2str(trial) '.mat'] ), 'all_leftEye', 'all_rightEye', 'convtimestamps', 'trackerID');
            
%             all_trial_info(end+1,1:8) = [trial, tex_nr, vari_nr, word_nr, sent_nr, flip_onsets];


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

looklisten_zipandcleanup;



%% End.

disp('<strong>All done and all saved</strong>');
c_endmsg_locked_imgonly(hwnd, 1, black, 28, 0, text_instruction, 0, []);
sca;