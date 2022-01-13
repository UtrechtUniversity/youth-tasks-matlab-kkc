function draw_gaze_aoi( hwndMain, hwndMini, lstAOI, eyeX, eyeY, drawRects )
	
	if nargin < 6, drawRects = true; end
	
	% Get screen sizes.
	[ widthMain, heightMain ] = Screen( 'WindowSize', hwndMain );
	[ widthMini, heightMini ] = Screen( 'WindowSize', hwndMini );
	
	
	% Calculate ratios to scale the rects to mini screen size.
	scaleWidth	= widthMini / widthMain;
	scaleHeight = heightMini / heightMain;
	
	
	% Convert main screen coordinates to mini screen coordinates.
	eyeXMini = eyeX * scaleWidth;
	eyeYMini = eyeY * scaleHeight;
	
    
	% Draw rects.
	if drawRects
		for i = 1 : length(lstAOI)
			Screen('FrameRect', hwndMini, [0 0 0], lstAOI{i} .* [scaleWidth scaleHeight scaleWidth scaleHeight]);
		end
	end
    
    
	% Draw crosshairs.
    Screen('DrawLine', hwndMini, 0, eyeXMini-20, eyeYMini, eyeXMini+20, eyeYMini, 5);
    Screen('DrawLine', hwndMini, 0, eyeXMini, eyeYMini-20, eyeXMini, eyeYMini+20, 5);
    
	
	% Flip screen.
	Screen('Flip', hwndMini, 0, 0, 2, 0);
% end

    