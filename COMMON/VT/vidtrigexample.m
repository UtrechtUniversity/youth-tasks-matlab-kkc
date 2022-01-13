clear; close all; clc;

addpath( genpath('/home/cid/Documents/YOUth/kkc_tasks/COMMON') );

global settings_path;
settings_path = '/home/cid/Documents/YOUth/kkc_tasks/SETTINGS/';


% Output file name for video file on other computer.
outputFilename = ['test_' datestr(now, 'yyyy-mm-dd_HHMMSS')];


% Initialize video trigger.
[vt_enabled, tcpc, vt_cmd, vt_settings] = c_vid_trig_init(true);


% Check for connection.
if ~vt_enabled
	error('Some error occured while initializing. Video trigger recorder not active.');
end


% Open video device using the camera settings from settings.mat.
msg = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.open_device, vt_settings.cam_settings);

% Check return code.
if msg ~= 1
	error('Some error occured while opening video device.');
end


% Set output file name.
msg = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_tag, outputFilename); %#ok<*NASGU>


% Send trigger code 0 and start the recording.
msg = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, 0);
msg = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.start_rec, []);


% Send the following trigger codes.
codesToSend = [165 90 162];


% Send codes.
for code = codesToSend
	msg = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.set_code, code);
	pause(1);
end


% Stop recording and close device.
msg = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.stop_rec, []);
msg = c_vid_trig_send(vt_enabled, tcpc, vt_cmd.close_device, []);


fprintf( 1, '\nDone!\n\n' );