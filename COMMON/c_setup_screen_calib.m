function [hwnd, fps, scrW, scrH] = c_setup_screen_calib(scrInd, bgColor, enable_synctest, scrWidth, scrHeight)

%commandwindow;
%rng('shuffle')

%scrScale = 2;
%scrRes = Screen('Resolution', scrInd);  % resolution of the screen
%scrWidth = 640; %scrRes.width / scrScale;    % width of the window we will open
%scrHeight = 360; %scrRes.height / scrScale;  % height of the window we will open
%scrScale = scrRes.width / scrWidth;

PsychDefaultSetup(1);
if (enable_synctest == 0)
    Screen('Preference', 'SkipSyncTests', 1);
end
%pixSize = max(Screen(0,'PixelSizes'));
%hwnd = Screen('OpenWindow', scrInd, bgColor, [0, 0, scrWidth, scrHeight], pixSize, 2, [], 4, []);
hwnd = Screen('OpenWindow', scrInd, bgColor, [0, 0, scrWidth, scrHeight]); %, [], [], [], 4, [], [], []);
%hwnd = Screen('OpenWindow', scrInd, bgColor, [], [], [], [], 4, [], [], []);
[scrW, scrH] = Screen('WindowSize', hwnd);
%scrW = scrRes.width;
%scrH = scrRes.height;
%scrRec = Screen('Rect', hwnd)
%Screen('BlendFunction', hwnd, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
ShowCursor(0, scrInd);

%rec_center = [scrW/2, scrH/2, scrW/2, scrH/2];

%fps = 60;
fps = Screen('FrameRate', hwnd);      % frames per second
ifi = Screen('GetFlipInterval', hwnd);
if (fps == 0)
    fps = 1/ifi;
end

