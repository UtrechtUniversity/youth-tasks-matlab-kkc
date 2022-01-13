function hwnd_calib = c_et_start_first_calib(eyetracking, hwnd, logpath, logtag )

% Get screen width and height.
% scrW = evalin('base', 'scrW');
% scrH = evalin('base', 'scrH');
[scrW, scrH] = Screen( 'WindowSize', hwnd );


% File names for calibration logging.
calib_savefile = c_et_calib_filenames(logpath, logtag, 1, 0); %the last 0 initialises trial number as 0


% Open mini-screen.
width_calib = 640;
height_calib = floor(640 * scrH / scrW);
hwnd_calib = c_setup_screen_calib(0, [127 127 127], 0, width_calib, height_calib);
fps_calib = 60;


% %[hwnd_calib, fps_calib, scrW_calib, scrH_calib, scaleW_calib, scaleH_calib] = c_et_calib(eyetracking, scrW, scrH, hwnd, script_path, calib_savefile, calib_plotfile);
if eyetracking
	c_et_calib( hwnd, hwnd_calib, fps_calib, calib_savefile );
end