function calibrationParameters = InitCalibration( hwnd )

	% Paths for media during calibration.
	global calib_path

% 	calibrationParameters.xres = scrW; % res(1);
% 	calibrationParameters.yres = scrH; % res(2);
	[calibrationParameters.xres, calibrationParameters.yres] = Screen( 'WindowSize', hwnd );

	calibrationParameters.points.x = [0.1 0.9 0.5 0.9 0.1];  % X coordinates in [0,1] coordinate system 
	calibrationParameters.points.y = [0.1 0.1 0.5 0.9 0.9];  % Y coordinates in [0,1] coordinate system 
	calibrationParameters.points.names = {'Top left','Top right','Middle','Bottom right','Bottom left'};
	calibrationParameters.points.n = size(calibrationParameters.points.x, 2); % Number of calibration points

	calibrationParameters.bkcolor = [127 127 127]; % background color used in calibration process
	calibrationParameters.fgcolor = [0 0 255]; % (Foreground) color used in calibration process

	calibrationParameters.images = {'ET_CALIB_spiral01.png' 'ET_CALIB_spiral02.png' 'ET_CALIB_spiral03.png' 'ET_CALIB_spiral04.png' 'ET_CALIB_spiral05.png'};
	calibrationParameters.bkmusic = {'ET_CALIB_song01.wav' 'ET_CALIB_song02.wav' 'ET_CALIB_song03.wav' 'ET_CALIB_song04.wav' 'ET_CALIB_song05.wav'};
	calibrationParameters.fgmusic = {'ET_CALIB_sound01.wav' 'ET_CALIB_sound02.wav' 'ET_CALIB_sound03.wav' 'ET_CALIB_sound05.wav'};
	calibrationParameters.video = [calib_path 'ET_CALIB_video.mp4']; %'ET_CALIB_video(Elmo).m4v';

	calibrationParameters.nimages = length(calibrationParameters.images);
	calibrationParameters.nbkmusic = length(calibrationParameters.bkmusic);
	calibrationParameters.nfgmusic = length(calibrationParameters.fgmusic);

	calibrationParameters.stimsize = 200; % calibration image size in pixels
	calibrationParameters.changeperflip = -5; % degrees calibration image rotation per Screen flip
	calibrationParameters.sizechange = 30; % max pixelchange in each direction
	calibrationParameters.finalsize = 20; % calibration image size at point of actual calibration
	calibrationParameters.finaltime = 0.5; % time in s of final decrease in size before calibration of point

	calibrationParameters.bkcolor = [131 131 131]; % background color used in calibration process