% if ~isempty(lefteye)
%     Screen('FrameRect',hwnd_calib,[0 0 0], rdst_cent_stim .* [scaleW_calib, scaleH_calib, scaleW_calib, scaleH_calib]);
%     Screen('FrameRect',hwnd_calib,[0 0 0], rgaze_cent_stim .* [scaleW_calib, scaleH_calib, scaleW_calib, scaleH_calib]);
%     if (trial_side == 1)
%         Screen('FrameRect',hwnd_calib,[0 0 0], rdst_peri_stim_right .* [scaleW_calib, scaleH_calib, scaleW_calib, scaleH_calib]);
%     else
%         Screen('FrameRect',hwnd_calib,[0 0 0], rdst_peri_stim_left .* [scaleW_calib, scaleH_calib, scaleW_calib, scaleH_calib]);
%     end
%     if (gaze_side == 1)
%         Screen('FrameRect',hwnd_calib,[0 0 0], rgaze_peri_stim_right .* [scaleW_calib, scaleH_calib, scaleW_calib, scaleH_calib]);
%     else
%         Screen('FrameRect',hwnd_calib,[0 0 0], rgaze_peri_stim_left .* [scaleW_calib, scaleH_calib, scaleW_calib, scaleH_calib]);
%     end
%     %Screen('DrawText',hwnd_calib, '+', eyeX, eyeY, [0 0 0]);
%     Screen('DrawLine', hwnd_calib, 0, eyeX-20, eyeY, eyeX+20, eyeY, 5);
%     Screen('DrawLine', hwnd_calib, 0, eyeX, eyeY-20, eyeX, eyeY+20, 5);
%     Screen('Flip', hwnd_calib, 0, 0, 2, 0);
% end

function draw_gaze_lr( hwndMain, hwndMini, trial_side, gaze_side, rdst_cent_stim, rdst_peri_stim_left, rdst_peri_stim_right, rgaze_cent_stim, rgaze_peri_stim_left, rgaze_peri_stim_right, eyeX, eyeY )
	
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
	Screen('FrameRect',hwndMini,[0 0 0], rdst_cent_stim .* [scaleWidth, scaleHeight, scaleWidth, scaleHeight]);
	Screen('FrameRect',hwndMini,[0 0 0], rgaze_cent_stim .* [scaleWidth, scaleHeight, scaleWidth, scaleHeight]);
	
	
	if trial_side == 1
		Screen('FrameRect',hwndMini,[0 0 0], rdst_peri_stim_right .* [scaleWidth, scaleHeight, scaleWidth, scaleHeight]);
	else
		Screen('FrameRect',hwndMini,[0 0 0], rdst_peri_stim_left .* [scaleWidth, scaleHeight, scaleWidth, scaleHeight]);
	end
	
	if gaze_side == 1
		Screen('FrameRect',hwndMini,[0 0 0], rgaze_peri_stim_right .* [scaleWidth, scaleHeight, scaleWidth, scaleHeight]);
	else
		Screen('FrameRect',hwndMini,[0 0 0], rgaze_peri_stim_left .* [scaleWidth, scaleHeight, scaleWidth, scaleHeight]);
	end
	
	
	% Draw crosshairs.
    Screen('DrawLine', hwndMini, 0, eyeXMini-20, eyeYMini, eyeXMini+20, eyeYMini, 5);
    Screen('DrawLine', hwndMini, 0, eyeXMini, eyeYMini-20, eyeXMini, eyeYMini+20, 5);
    
	
	% Flip screen.
	Screen('Flip', hwndMini, 0, 0, 2, 0);