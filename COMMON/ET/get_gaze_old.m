
if (eyetracking == 0)    
    [x,y,buttons] = GetMouse(hwnd);
    timestamp = floor(1000000 * GetSecs);
    trigsignal = 0;
    
    lefteye = zeros(1,13);
    lefteye(7) = (x - 20) / scrW;
    lefteye(8) = y / scrH;
    
    righteye = zeros(1,13);
    righteye(7) = (x + 20) / scrW;
    righteye(8) = y / scrH;
    
    lefteye    = repmat(lefteye, 5, 1);
    righteye   = repmat(righteye, 5, 1);
    timestamp  = repmat(timestamp, 5, 1);
    trigsignal = repmat(trigsignal, 5, 1);
else
    [lefteye, righteye, timestamp, trigsignal] = tetio_readGazeData;
end

if ~isempty(lefteye)
    numGazeData = size(lefteye, 2);
    all_leftEye = [all_leftEye; lefteye(:, 1:numGazeData)];
    all_rightEye = [all_rightEye; righteye(:, 1:numGazeData)];
    all_timeStamp = [all_timeStamp; timestamp(:,1)];
    all_trigger = [all_trigger; trigsignal(:,1)];
    
    
    % DRAW EYE ON SCREEN
    rightGazePoint2d.x = all_rightEye(:,7);
    rightGazePoint2d.y = all_rightEye(:,8);
    leftGazePoint2d.x = all_leftEye(:,7);
    leftGazePoint2d.y = all_leftEye(:,8);
    eyeX = mean([rightGazePoint2d.x, leftGazePoint2d.x],2);
    eyeY = mean([rightGazePoint2d.y, leftGazePoint2d.y],2);
    
    % collect last n samples to determine 'on targetness'
    % multiply with screenresolution to get screen coordinates
    % (Tobii returns a value between 0 and 1 as screen coordinate)
    nSamp = min(length(eyeX), numbOfSamples);
    eyeXnSamples = sum(eyeX(end-(nSamp-1) : end))/nSamp * scrW;    % ET reports eye position as a scalar [0 1]
    eyeYnSamples = sum(eyeY(end-(nSamp-1) : end))/nSamp * scrH;
    
    eyeX = eyeX(end)*scrW_calib;
    eyeY = eyeY(end)*scrH_calib;
    
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

end
