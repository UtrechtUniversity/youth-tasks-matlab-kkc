clearvars -except pilotmode
clc; close all

if (exist('pilotmode', 'var') == 0)
    pilotmode = 0;
end

cleanupObj = onCleanup(@closeCommandWindowLog);

%set to 0 to disable eyetracking/diode (for development only)
eyetracking = 1;
en_diode = 1;
vt_enabled = 1;
etrack_diode = 0;

global color_calib;
color_calib = 1;

commandwindow;

[script_path, script_name, script_ext] = fileparts(mfilename('fullpath'));
cd(script_path)

tools_paths = cell(1, 6);
tools_paths{1} = [script_path '/COMMON']; 
tools_paths{2} = [script_path '/COMMON/Tobii_Pro_SDK'];
tools_paths{3} = [script_path '/COMMON/ET'];
tools_paths{4} = [script_path '/COMMON/media_calib'];
tools_paths{5} = [script_path '/COMMON/photodiode'];
tools_paths{6} = [script_path '/COMMON/VT'];

global calib_path;
global common_media_path;
global settings_path;
global media_path;
global common_media_capping
%global changelog_path;
calib_path = [script_path '/COMMON/media_calib/'];
common_media_path = [script_path '/COMMON/media_common/'];
settings_path = [script_path '/SETTINGS/'];
media_path = [script_path '/MEDIA/'];
common_media_capping = fullfile( script_path, 'COMMON', 'media_capping' );
%changelog_path = [script_path '/CHANGELOG/'];
%if (~exist(changelog_path, 'dir'))
%    mkdir(changelog_path);
%end

% Keep the tracking mode for the eyetracker?
global keepTrackingMode
keepTrackingMode = false;

for i = 1: length(tools_paths)
    addpath( genpath( tools_paths{i} ))
end


% Auto-update the subversion codebase.
updateLogFile = fullfile( script_path, 'svn-update-log.txt' );
diary( updateLogFile );
c_auto_update_svn( script_path );
diary off


confirm_settings = 0;
c_setup;

% Get and print the current CODY SVN revision number.
revisionString = c_get_svn_revision_string(script_path);
fprintf( 1, '%s\n', revisionString );

disp(' ');
disp(['<strong>KKC Tasks, ComputerID = ' computerID '</strong>']);
if (pilotmode == 1)
    disp('<strong>TASKS ARE RUNNING IN PILOT MODE</strong>');
end
if (eyetracking == 0)
    disp('<strong>WARNING: EYETRACKING IS DISABLED</strong>');
end
if (en_diode == 0)
    disp('<strong>WARNING: PHOTO DIODE IS DISABLED</strong>');
end
if (vt_enabled == 0)
    disp('<strong>WARNING: VIDEO RECORDING IS DISABLED</strong>');
end
if (etrack_diode == 0)
    disp('<strong>WARNING: EYETRACKING PHOTO DIODE TRIGGER IS DISABLED</strong>');
end

stopped = 0;
%subject_info;

%--------------------------------------------------------------------------
%
%                         2) ET - task - ...
%                        /
%                    type
%                   /    \
%        0) rondom 0      3) EEG - task - ...
%       /
%  group
%       \
%        1) rondom 9      1) CT - task - ...
%                   \    /
%                    type
%                        \
%                         2) ET - task - ...
%
%--------------------------------------------------------------------------

lstSel = cell(1,2);
lstSel{1}.name = 'Rondom 0';                          lstSel{1}.value = 0;                   lstSel{1}.prefix = 'B';     lstSel{1}.subjectscript = 'subject_info_y0';      lstSel{1}.charwave = 'm';
lstSel{2}.name = 'Rondom 9';                          lstSel{2}.value = 9;                   lstSel{2}.prefix = 'A';     lstSel{2}.subjectscript = 'subject_info_y9';      lstSel{2}.charwave = 'y';
lstSel{3}.name = 'Rondom 3';                          lstSel{3}.value = 3;                   lstSel{3}.prefix = 'B';     lstSel{3}.subjectscript = 'subject_info_y3';      lstSel{3}.charwave = 'y';
lstSel{4}.name = 'Rondom 12';                         lstSel{4}.value = 12;                  lstSel{4}.prefix = 'A';     lstSel{4}.subjectscript = 'subject_info_y9';      lstSel{4}.charwave = 'y';

lstSel{1}.types = cell(1,2);
lstSel{1}.types{1}.name = 'ET';                       lstSel{1}.types{1}.value = 2;          lstSel{1}.types{1}.extrascript = '';          %lstSel{1}.types{1}.datafolder = 'ET';
lstSel{1}.types{2}.name = 'EEG';                      lstSel{1}.types{2}.value = 3;          lstSel{1}.types{2}.extrascript = '';          %lstSel{1}.types{2}.datafolder = 'EEG';

lstSel{2}.types = cell(1,3);
lstSel{2}.types{1}.name = 'CT1';                      lstSel{2}.types{1}.value = 1;          lstSel{2}.types{1}.extrascript = 'subject_infoextra_y9';          %lstSel{2}.types{1}.datafolder = 'comptask1';
lstSel{2}.types{2}.name = 'CT2';                      lstSel{2}.types{2}.value = 2;          lstSel{2}.types{2}.extrascript = 'subject_infoextra_y9';          %lstSel{2}.types{2}.datafolder = 'comptask2';
lstSel{2}.types{3}.name = 'ET';                       lstSel{2}.types{3}.value = 3;          lstSel{2}.types{3}.extrascript = '';          %lstSel{2}.types{3}.datafolder = 'ET';

lstSel{3}.types = cell(1,3);
lstSel{3}.types{1}.name = 'CT';                       lstSel{3}.types{1}.value = 1;          lstSel{3}.types{1}.extrascript = 'subject_infoextra_y3';
lstSel{3}.types{2}.name = 'ET';                       lstSel{3}.types{2}.value = 2;          lstSel{3}.types{2}.extrascript = '';
lstSel{3}.types{3}.name = 'EEG';                      lstSel{3}.types{3}.value = 3;          lstSel{3}.types{3}.extrascript = '';

lstSel{4}.types = cell(1,3);
lstSel{4}.types{1}.name = 'CT1';                      lstSel{4}.types{1}.value = 1;          lstSel{4}.types{1}.extrascript = 'subject_infoextra_y9';          %lstSel{2}.types{1}.datafolder = 'comptask1';
lstSel{4}.types{2}.name = 'CT2';                      lstSel{4}.types{2}.value = 2;          lstSel{4}.types{2}.extrascript = 'subject_infoextra_y9';          %lstSel{2}.types{2}.datafolder = 'comptask2';
lstSel{4}.types{3}.name = 'ET';                       lstSel{4}.types{3}.value = 3;          lstSel{4}.types{3}.extrascript = '';          %lstSel{2}.types{3}.datafolder = 'ET';

lstSel{1}.types{1}.tasks = cell(1,3);
lstSel{1}.types{1}.tasks{1}.name = 'Social Gaze';     lstSel{1}.types{1}.tasks{1}.value = 1; lstSel{1}.types{1}.tasks{1}.tag = 'infsgaze';  lstSel{1}.types{1}.tasks{1}.folder = 'socialgaze';    lstSel{1}.types{1}.tasks{1}.script = 'socialgaze';     lstSel{1}.types{1}.tasks{1}.tasktype = 0;    lstSel{1}.types{1}.tasks{1}.show4waves = [];
lstSel{1}.types{1}.tasks{2}.name = 'Pro Gap';         lstSel{1}.types{1}.tasks{2}.value = 2; lstSel{1}.types{1}.tasks{2}.tag = 'infprogap'; lstSel{1}.types{1}.tasks{2}.folder = 'saccade';       lstSel{1}.types{1}.tasks{2}.script = 'saccade_task';   lstSel{1}.types{1}.tasks{2}.tasktype = 4;    lstSel{1}.types{1}.tasks{2}.show4waves = [];
lstSel{1}.types{1}.tasks{3}.name = 'Popout';          lstSel{1}.types{1}.tasks{3}.value = 3; lstSel{1}.types{1}.tasks{3}.tag = 'infpop';    lstSel{1}.types{1}.tasks{3}.folder = 'popout';        lstSel{1}.types{1}.tasks{3}.script = 'popout';         lstSel{1}.types{1}.tasks{3}.tasktype = 1;    lstSel{1}.types{1}.tasks{3}.show4waves = [];

lstSel{1}.types{2}.tasks = cell(1,3);
lstSel{1}.types{2}.tasks{1}.name = 'Face House';      lstSel{1}.types{2}.tasks{1}.value = 1; lstSel{1}.types{2}.tasks{1}.tag = 'facehouse'; lstSel{1}.types{2}.tasks{1}.folder = 'emotionalface'; lstSel{1}.types{2}.tasks{1}.script = 'emotionalface';  lstSel{1}.types{2}.tasks{1}.tasktype = 1;    lstSel{1}.types{2}.tasks{1}.show4waves = [];
lstSel{1}.types{2}.tasks{2}.name = 'Face Emotions';   lstSel{1}.types{2}.tasks{2}.value = 2; lstSel{1}.types{2}.tasks{2}.tag = 'faceemo';   lstSel{1}.types{2}.tasks{2}.folder = 'emotionalface'; lstSel{1}.types{2}.tasks{2}.script = 'emotionalface';  lstSel{1}.types{2}.tasks{2}.tasktype = 2;    lstSel{1}.types{2}.tasks{2}.show4waves = [10];
lstSel{1}.types{2}.tasks{3}.name = 'Coherence';       lstSel{1}.types{2}.tasks{3}.value = 3; lstSel{1}.types{2}.tasks{3}.tag = 'coherence'; lstSel{1}.types{2}.tasks{3}.folder = 'restingstate';  lstSel{1}.types{2}.tasks{3}.script = 'restingstate';   lstSel{1}.types{2}.tasks{3}.tasktype = 1;    lstSel{1}.types{2}.tasks{3}.show4waves = [];

lstSel{2}.types{1}.tasks = cell(1,3);
lstSel{2}.types{1}.tasks{1}.name = 'Peabody';         lstSel{2}.types{1}.tasks{1}.value = 1; lstSel{2}.types{1}.tasks{1}.tag = 'peabody';   lstSel{2}.types{1}.tasks{1}.folder = 'peabody';       lstSel{2}.types{1}.tasks{1}.script = 'peabody';        lstSel{2}.types{1}.tasks{1}.tasktype = 1;    lstSel{2}.types{1}.tasks{1}.show4waves = [];
lstSel{2}.types{1}.tasks{2}.name = 'Discount';        lstSel{2}.types{1}.tasks{2}.value = 2; lstSel{2}.types{1}.tasks{2}.tag = 'discount';  lstSel{2}.types{1}.tasks{2}.folder = 'discount';      lstSel{2}.types{1}.tasks{2}.script = 'discount';       lstSel{2}.types{1}.tasks{2}.tasktype = 1;    lstSel{2}.types{1}.tasks{2}.show4waves = [];
lstSel{2}.types{1}.tasks{3}.name = 'Cyberball';       lstSel{2}.types{1}.tasks{3}.value = 3; lstSel{2}.types{1}.tasks{3}.tag = 'cyberball'; lstSel{2}.types{1}.tasks{3}.folder = 'prosocial';     lstSel{2}.types{1}.tasks{3}.script = 'prosocial';      lstSel{2}.types{1}.tasks{3}.tasktype = 1;    lstSel{2}.types{1}.tasks{3}.show4waves = [];
%lstSel{2}.types{1}.tasks{3}.name = 'Trustgame';       lstSel{2}.types{1}.tasks{3}.value = 3; lstSel{2}.types{1}.tasks{3}.tag = 'trustgame'; lstSel{2}.types{1}.tasks{3}.folder = 'trustgame';     lstSel{2}.types{1}.tasks{3}.script = 'trustgame';      lstSel{2}.types{1}.tasks{3}.tasktype = 1;    lstSel{2}.types{1}.tasks{3}.show4waves = [];
%lstSel{2}.types{1}.tasks{4}.name = 'RMET';            lstSel{2}.types{1}.tasks{4}.value = 4; lstSel{2}.types{1}.tasks{4}.tag = 'rmet';      lstSel{2}.types{1}.tasks{4}.folder = 'rmet';          lstSel{2}.types{1}.tasks{4}.script = 'rmet';           lstSel{2}.types{1}.tasks{4}.tasktype = 1;    lstSel{2}.types{1}.tasks{4}.show4waves = [];

lstSel{2}.types{2}.tasks = cell(1,1);
lstSel{2}.types{2}.tasks{1}.name = 'Trustgame';       lstSel{2}.types{2}.tasks{1}.value = 3; lstSel{2}.types{2}.tasks{1}.tag = 'trustgame'; lstSel{2}.types{2}.tasks{1}.folder = 'trustgame';     lstSel{2}.types{2}.tasks{1}.script = 'trustgame';      lstSel{2}.types{2}.tasks{1}.tasktype = 1;    lstSel{2}.types{2}.tasks{1}.show4waves = [];
%lstSel{2}.types{2}.tasks{1}.name = 'Cyberball';       lstSel{2}.types{2}.tasks{1}.value = 1; lstSel{2}.types{2}.tasks{1}.tag = 'cyberball'; lstSel{2}.types{2}.tasks{1}.folder = 'prosocial';     lstSel{2}.types{2}.tasks{1}.script = 'prosocial';      lstSel{2}.types{2}.tasks{1}.tasktype = 1;    lstSel{2}.types{2}.tasks{1}.show4waves = [];

lstSel{2}.types{3}.tasks = cell(1,3);
lstSel{2}.types{3}.tasks{1}.name = 'Social Gaze';     lstSel{2}.types{3}.tasks{1}.value = 1; lstSel{2}.types{3}.tasks{1}.tag = 'chsgaze';   lstSel{2}.types{3}.tasks{1}.folder = 'socialgaze';    lstSel{2}.types{3}.tasks{1}.script = 'socialgaze';     lstSel{2}.types{3}.tasks{1}.tasktype = 9;    lstSel{2}.types{3}.tasks{1}.show4waves = [];
%lstSel{2}.types{3}.tasks{2}.name = 'Saccade Neutral'; lstSel{2}.types{3}.tasks{2}.value = 2; lstSel{2}.types{3}.tasks{2}.tag = 'chgapinf';  lstSel{2}.types{3}.tasks{2}.folder = 'saccade';       lstSel{2}.types{3}.tasks{2}.script = 'saccade_task';   lstSel{2}.types{3}.tasks{2}.tasktype = 1;    lstSel{2}.types{3}.tasks{2}.show4waves = [];
lstSel{2}.types{3}.tasks{2}.name = 'Pro Gap';         lstSel{2}.types{3}.tasks{2}.value = 2; lstSel{2}.types{3}.tasks{2}.tag = 'chprogap';  lstSel{2}.types{3}.tasks{2}.folder = 'saccade';       lstSel{2}.types{3}.tasks{2}.script = 'saccade_task';   lstSel{2}.types{3}.tasks{2}.tasktype = 2;    lstSel{2}.types{3}.tasks{2}.show4waves = [];
lstSel{2}.types{3}.tasks{3}.name = 'Anti Gap';        lstSel{2}.types{3}.tasks{3}.value = 3; lstSel{2}.types{3}.tasks{3}.tag = 'chantigap'; lstSel{2}.types{3}.tasks{3}.folder = 'saccade';       lstSel{2}.types{3}.tasks{3}.script = 'saccade_task';   lstSel{2}.types{3}.tasks{3}.tasktype = 3;    lstSel{2}.types{3}.tasks{3}.show4waves = [];


lstSel{3}.types{1}.tasks = cell(1,1);
lstSel{3}.types{1}.tasks{1}.name = 'Peabody';         lstSel{3}.types{1}.tasks{1}.value = 1; lstSel{3}.types{1}.tasks{1}.tag = 'infpeabody';   lstSel{3}.types{1}.tasks{1}.folder = 'peabody';       lstSel{3}.types{1}.tasks{1}.script = 'peabody';        lstSel{3}.types{1}.tasks{1}.tasktype = 2;    lstSel{3}.types{1}.tasks{1}.show4waves = [];

lstSel{3}.types{2}.tasks = cell(1,4);
lstSel{3}.types{2}.tasks{1}.name = 'Social Gaze';       lstSel{3}.types{2}.tasks{1}.value = 1; lstSel{3}.types{2}.tasks{1}.tag = 'infsgaze';   lstSel{3}.types{2}.tasks{1}.folder = 'socialgaze';  lstSel{3}.types{2}.tasks{1}.script = 'socialgaze';      lstSel{3}.types{2}.tasks{1}.tasktype = 0;    lstSel{3}.types{2}.tasks{1}.show4waves = [];
lstSel{3}.types{2}.tasks{2}.name = 'Pro Gap';           lstSel{3}.types{2}.tasks{2}.value = 2; lstSel{3}.types{2}.tasks{2}.tag = 'infprogap';  lstSel{3}.types{2}.tasks{2}.folder = 'saccade';     lstSel{3}.types{2}.tasks{2}.script = 'saccade_task';    lstSel{3}.types{2}.tasks{2}.tasktype = 4;    lstSel{3}.types{2}.tasks{2}.show4waves = [];
lstSel{3}.types{2}.tasks{3}.name = 'Popout';            lstSel{3}.types{2}.tasks{3}.value = 3; lstSel{3}.types{2}.tasks{3}.tag = 'infpop';     lstSel{3}.types{2}.tasks{3}.folder = 'popout';      lstSel{3}.types{2}.tasks{3}.script = 'popout';          lstSel{3}.types{2}.tasks{3}.tasktype = 1;    lstSel{3}.types{2}.tasks{3}.show4waves = [];
lstSel{3}.types{2}.tasks{4}.name = 'Looking/listening'; lstSel{3}.types{2}.tasks{4}.value = 4; lstSel{3}.types{2}.tasks{4}.tag = 'looklisten'; lstSel{3}.types{2}.tasks{4}.folder = 'looklisten';  lstSel{3}.types{2}.tasks{4}.script = 'looklisten_task'; lstSel{3}.types{2}.tasks{4}.tasktype = 1;    lstSel{3}.types{2}.tasks{4}.show4waves = [];

lstSel{3}.types{3}.tasks = cell(1,3);
lstSel{3}.types{3}.tasks{1}.name = 'Face House';      lstSel{3}.types{3}.tasks{1}.value = 1; lstSel{3}.types{3}.tasks{1}.tag = 'facehouse'; lstSel{3}.types{3}.tasks{1}.folder = 'emotionalface'; lstSel{3}.types{3}.tasks{1}.script = 'emotionalface';  lstSel{3}.types{3}.tasks{1}.tasktype = 3;    lstSel{3}.types{3}.tasks{1}.show4waves = [];
lstSel{3}.types{3}.tasks{2}.name = 'Face Emotions';   lstSel{3}.types{3}.tasks{2}.value = 2; lstSel{3}.types{3}.tasks{2}.tag = 'faceemo';   lstSel{3}.types{3}.tasks{2}.folder = 'emotionalface'; lstSel{3}.types{3}.tasks{2}.script = 'emotionalface';  lstSel{3}.types{3}.tasks{2}.tasktype = 4;    lstSel{3}.types{3}.tasks{2}.show4waves = [];
lstSel{3}.types{3}.tasks{3}.name = 'Coherence';       lstSel{3}.types{3}.tasks{3}.value = 3; lstSel{3}.types{3}.tasks{3}.tag = 'coherence'; lstSel{3}.types{3}.tasks{3}.folder = 'restingstate';  lstSel{3}.types{3}.tasks{3}.script = 'restingstate';   lstSel{3}.types{3}.tasks{3}.tasktype = 1;    lstSel{3}.types{3}.tasks{3}.show4waves = [];

lstSel{4}.types{1}.tasks = cell(1,3);
lstSel{4}.types{1}.tasks{1}.name = 'Peabody';         lstSel{4}.types{1}.tasks{1}.value = 1; lstSel{4}.types{1}.tasks{1}.tag = 'peabody';   lstSel{4}.types{1}.tasks{1}.folder = 'peabody';       lstSel{4}.types{1}.tasks{1}.script = 'peabody';        lstSel{4}.types{1}.tasks{1}.tasktype = 1;    lstSel{4}.types{1}.tasks{1}.show4waves = [];
lstSel{4}.types{1}.tasks{2}.name = 'Discount';        lstSel{4}.types{1}.tasks{2}.value = 2; lstSel{4}.types{1}.tasks{2}.tag = 'discount';  lstSel{4}.types{1}.tasks{2}.folder = 'discount';      lstSel{4}.types{1}.tasks{2}.script = 'discount';       lstSel{4}.types{1}.tasks{2}.tasktype = 1;    lstSel{4}.types{1}.tasks{2}.show4waves = [];
lstSel{4}.types{1}.tasks{3}.name = 'Cyberball';       lstSel{4}.types{1}.tasks{3}.value = 3; lstSel{4}.types{1}.tasks{3}.tag = 'cyberball'; lstSel{4}.types{1}.tasks{3}.folder = 'prosocial';     lstSel{4}.types{1}.tasks{3}.script = 'prosocial';      lstSel{4}.types{1}.tasks{3}.tasktype = 1;    lstSel{4}.types{1}.tasks{3}.show4waves = [];

lstSel{4}.types{2}.tasks = cell(1,1);
lstSel{4}.types{2}.tasks{1}.name = 'Trustgame';       lstSel{4}.types{2}.tasks{1}.value = 3; lstSel{4}.types{2}.tasks{1}.tag = 'trustgame'; lstSel{4}.types{2}.tasks{1}.folder = 'trustgame';     lstSel{4}.types{2}.tasks{1}.script = 'trustgame';      lstSel{4}.types{2}.tasks{1}.tasktype = 1;    lstSel{4}.types{2}.tasks{1}.show4waves = [];

lstSel{4}.types{3}.tasks = cell(1,3);
lstSel{4}.types{3}.tasks{1}.name = 'Social Gaze';     lstSel{4}.types{3}.tasks{1}.value = 1; lstSel{4}.types{3}.tasks{1}.tag = 'chsgaze';   lstSel{4}.types{3}.tasks{1}.folder = 'socialgaze';    lstSel{4}.types{3}.tasks{1}.script = 'socialgaze';     lstSel{4}.types{3}.tasks{1}.tasktype = 9;    lstSel{4}.types{3}.tasks{1}.show4waves = [];
lstSel{4}.types{3}.tasks{2}.name = 'Pro Gap';         lstSel{4}.types{3}.tasks{2}.value = 2; lstSel{4}.types{3}.tasks{2}.tag = 'chprogap';  lstSel{4}.types{3}.tasks{2}.folder = 'saccade';       lstSel{4}.types{3}.tasks{2}.script = 'saccade_task';   lstSel{4}.types{3}.tasks{2}.tasktype = 2;    lstSel{4}.types{3}.tasks{2}.show4waves = [];
lstSel{4}.types{3}.tasks{3}.name = 'Anti Gap';        lstSel{4}.types{3}.tasks{3}.value = 3; lstSel{4}.types{3}.tasks{3}.tag = 'chantigap'; lstSel{4}.types{3}.tasks{3}.folder = 'saccade';       lstSel{4}.types{3}.tasks{3}.script = 'saccade_task';   lstSel{4}.types{3}.tasks{3}.tasktype = 3;    lstSel{4}.types{3}.tasks{3}.show4waves = [];


%--------------------------------------------------------------------------
disp(' ');
valsG = zeros(1,length(lstSel));
for i = 1 : length(lstSel)
    valsG(i) = lstSel{i}.value;
end
[ordG, indG] = sort(valsG);
for i = 1 : length(lstSel)
%     disp([num2str(lstSel{indG(i)}.value) ') ' lstSel{indG(i)}.name]);
	fprintf( 1, '%2d) %s\n', lstSel{indG(i)}.value, lstSel{indG(i)}.name );
end
disp(' ');

bInpSelectOk = 0;
while (bInpSelectOk == 0)
    G = input('Select group: ');
    disp(' ');
    
    if (~isempty(G))
        for i = 1 : length(lstSel)
            if (lstSel{i}.value == G)
                iG = i;
                bInpSelectOk = 1;
                break;
            end
        end
    end
    if (bInpSelectOk == 0)
        disp(['Unknown option: ' num2str(G)]);
    end
end
%--------------------------------------------------------------------------

if (pilotmode == 1)
    prefix = 'D';
else
    prefix = lstSel{iG}.prefix;
end
%subject_info;
run(lstSel{iG}.subjectscript);

char_wave = lstSel{iG}.charwave;

%--------------------------------------------------------------------------

tmp_counter   = mod(subject_nr, 2);
R9_counter_trustgame    = 0; %mod(subject_nr, 2);
R0_counter_restingstate = mod(floor(subject_nr / 2), 2);

%if (lstSel{iG}.value == 0)
%    R0_counter_etframerate = mod(floor(subject_nr / (2*2)), 2);
%else
    R0_counter_etframerate = 1;
%end

%R0_counter_et           = mod(floor(subject_nr / (2*2)), 6);
%R9_counter_et           = mod(floor(subject_nr / (2*2*6)), 2);
%R9_counter_ct           = mod(floor(subject_nr / (2*2*6*2)), 6);
%
%R0_order_et = c_order_from_index(R0_counter_et, 3);
%R9_order_et = c_order_from_index(R9_counter_et, 2);
%R9_order_ct = c_order_from_index(R9_counter_ct, 3);
%
%for i = 1 : 3
%    lstSel{1}.types{1}.tasks{i}.value = R0_order_et(i);
%end
%
%lstSel{2}.types{3}.tasks{1}.value = 1 + (R9_order_et(1)-1) * 3;
%for i = 1 : 3
%    lstSel{2}.types{3}.tasks{i+1}.value = i + (R9_order_et(2)-1);
%end
%
%for i = 1 : 3
%    lstSel{2}.types{1}.tasks{i}.value = R9_order_ct(i);
%end

%--------------------------------------------------------------------------

confirm_extra_info = 1;

skip_eeg_user_interaction = 0;
auto_select_next_task = 0;

iT = -1;
while (1)
    bTaskSelected = 0;
    while (bTaskSelected == 0)
        
        if (iT == -1)
            disp(' ');
            for i = 1 : length(lstSel{iG}.types)
                disp([num2str(lstSel{iG}.types{i}.value) ') ' lstSel{iG}.types{i}.name]);
            end
            disp(' ')
            disp('9) Quit');
            disp(' ');
            
            bInpSelectOk = 0;
            while (bInpSelectOk == 0)
                T = input('Select task type: ');
                disp(' ');
                
                if (~isempty(T))
                    if (T == 9)
                        return;
                    end
                    for i = 1 : length(lstSel{iG}.types)
                        if (lstSel{iG}.types{i}.value == T)
                            iT = i;
                            bInpSelectOk = 1;
                            break;
                        end
                    end
                end
                if (bInpSelectOk == 0)
                    disp(['Unknown option: ' num2str(T)]);
                end
            end
        end
        
        if (isempty(lstSel{iG}.types{iT}.extrascript) == 0)
            run(lstSel{iG}.types{iT}.extrascript);
            confirm_extra_info = 0;
        end
        
        %--------------------------------------------------------------------------
        disp(' ');
        task_disp = [];
        for i = 1 : length(lstSel{iG}.types{iT}.tasks)
            task_disp(i) = lstSel{iG}.types{iT}.tasks{i}.value;
        end
        [task_disp_tmp, task_disp_ind] = sort(task_disp);
        for j = 1 : length(lstSel{iG}.types{iT}.tasks)
            i = task_disp_ind(j);
            
            bShow = 1;
            if (~isempty(lstSel{iG}.types{iT}.tasks{i}.show4waves))
                bShow = 0;
                for k = 1 : length(lstSel{iG}.types{iT}.tasks{i}.show4waves)
                    if (lstSel{iG}.types{iT}.tasks{i}.show4waves == age_nr)
                        bShow = 1;
                        break;
                    end
                end
            end
            
            if (bShow == 1)
                disp([num2str(lstSel{iG}.types{iT}.tasks{i}.value) ') ' lstSel{iG}.types{iT}.tasks{i}.name ' (' lstSel{iG}.types{iT}.tasks{i}.tag ')']);
            end
        end
        disp(' ')
        disp('8) Go back');
        disp('9) Quit');
        disp(' ');
        
        bInpSelectOk = 0;
        while (bInpSelectOk == 0)
            if (auto_select_next_task == 0)
                S = input('Select task: ');
            else
                S = auto_select_next_task;
                auto_select_next_task = 0;
            end
            disp(' ');
            
            if (~isempty(S))
                if (S == 8)
                    bTaskSelected = 0;
                    bInpSelectOk = 1;
                    iT = -1;
                    break;
                end
                if (S == 9)
                    return;
                end
                for i = 1 : length(lstSel{iG}.types{iT}.tasks)
                    if (lstSel{iG}.types{iT}.tasks{i}.value == S)
                        bShow = 1;
                        if (~isempty(lstSel{iG}.types{iT}.tasks{i}.show4waves))
                            bShow = 0;
                            for k = 1 : length(lstSel{iG}.types{iT}.tasks{i}.show4waves)
                                if (lstSel{iG}.types{iT}.tasks{i}.show4waves == age_nr)
                                    bShow = 1;
                                    break;
                                end
                            end
                        end
                        
                        if (bShow == 1)
                            iS = i;
                            bTaskSelected = 1;
                            bInpSelectOk = 1;
                            break;
                        end
                    end
                end
            end
            if (bInpSelectOk == 0)
                disp(['Unknown option: ' num2str(S)]);
            end
        end
        
    end
    
    %--------------------------------------------------------------------------
    
    dt = clock;
    datum = datestr(now, 'yyyymmdd');
    time_readable = sprintf('%02.0f:%02.0f', dt(4), dt(5));
    datum_readable = datestr(now, 'dd-mm-yyyy');
    itime = dt(4)*100 + dt(5);
    %strdate = sprintf('%s_%02.0f%02.0f', datum, dt(4), dt(5));
    
    wave = [num2str(subject_file.age_nr, '%d') char_wave]; %'y'];
    if (subject_file.subject_nr == 12345)
        pcode = [prefix 't'];
    else
        pcode = [prefix num2str(subject_file.subject_nr,'%05d')];
    end
    %strtag = [pcode '_' wave '_' strdate];
    
    %--------------------------------------------------------------------------
    
    %typename = lstSel{iG}.types{iT}.datafolder;
    taskname = lstSel{iG}.types{iT}.tasks{iS}.name;
    tasktag = lstSel{iG}.types{iT}.tasks{iS}.tag;
    
    bLogOK = 0;
    while (bLogOK == 0)
        strtime = num2str(itime, '%04d');
        if (pilotmode == 1)
            DataFolder = 'DATAPILOT';
        else
            DataFolder = 'DATA';
        end
        logpath = [script_path '/' DataFolder '/' pcode '_' wave '_' tasktag '_' datum '_' strtime '_' computerID '/'];
        if (~exist(logpath, 'dir'))
            mkdir(logpath);
            bLogOK = 1;
        else
            itime = itime + 1;
        end
    end
    logtag = [pcode '_' wave '_' tasktag '_' datum '_' strtime];
	
	% Start diary for logging everything that happens in the console
	% window.
	diaryFileName = fullfile( logpath, sprintf( '%s_commandwindowlog.txt', logtag ) );
	diary off
	diary(diaryFileName)
	fprintf( 1, 'Starting command window log (%s) at %s.\n', diaryFileName, datestr(now, 'yyyy-mm-dd HH:MM:SS.FFF') );
	
	% Show settings again, so that they appear in the console log.
	confirm_settings = 0;
	c_setup;

	% Get and print the current CODY SVN revision number.
	[revisionString, ~, shortRevisionString] = c_get_svn_revision_string(script_path);
	fprintf( 1, '%s\n', revisionString );
    
    disp(['Starting ' taskname ' task...']);
    disp(['log path: ' logpath]);
    disp(['log tag: ' logtag]);
    disp(' ');
    
    %--------------------------------------------------------------------------
    
    eeg_autopilot = skip_eeg_user_interaction;
    skip_eeg_user_interaction = 0;
    auto_select_next_task = 0;
    
    %workaround to fix bug in old pyschtoolbox versions
    global ptb_drawformattedtext_disableClipping;
    ptb_drawformattedtext_disableClipping = 1;
    
    enable_synctest = 0;
    
    Rondom = lstSel{iG}.value;
    Wave = age_nr;
    task_type = lstSel{iG}.types{iT}.tasks{iS}.tasktype;
    
    c_log_settings;
    
    cd(script_path);
    cd(lstSel{iG}.types{iT}.tasks{iS}.folder);
    run(lstSel{iG}.types{iT}.tasks{iS}.script);
    
    clearvars -except pilotmode subject_file subject_nr s_subject_nr wave script_path subj_path geslacht age_nr age_y age_m stopped lstSel iG iT prefix char_wave computerID scrW_cm scrH_cm trackerID calib_path common_media_path media_path settings_path tools_paths eyetracking en_diode vt_enabled etrack_diode confirm_extra_info R9_counter_trustgame R0_counter_restingstate R0_counter_etframerate color_calib auto_select_next_task skip_eeg_user_interaction hwnd fps scrW scrH %R0_counter_et R9_counter_et R9_counter_ct
    if (auto_select_next_task == 0)
        clearvars hwnd fps scrW scrH
    end
    cd(script_path);
    
    disp(' ');
    disp(' ');
    disp(['<strong>Subject nr: ' s_subject_nr '</strong>']);
    disp(['<strong>Wave: ' num2str(age_nr) '</strong>']);
    
    % Close command window log.
    closeCommandWindowLog;
end


% Function for closing diary (used with onCleanup).
function closeCommandWindowLog
    % Close diary.
	fprintf( 1, 'Closing command window log\n' );
	diary off
end

