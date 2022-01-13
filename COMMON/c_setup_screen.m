function [hwnd, fps, scrW, scrH] = c_setup_screen(scrInd, bgColor, enable_synctest)

commandwindow;
rng('shuffle')

scrRes = Screen('Resolution', scrInd);  % resolution of the screen
%scrWidth = scrRes.width / scrScale;    % width of the window we will open
%scrHeight = scrRes.height / scrScale;  % height of the window we will open

PsychDefaultSetup(1);
if (enable_synctest == 0)
    Screen('Preference', 'SkipSyncTests', 1);
else
    Screen('Preference', 'SkipSyncTests', 0);
end

Screen('Preference', 'Verbosity', 1);
PsychPortAudio('Verbosity', 1);

%pixSize = max(Screen(0,'PixelSizes'));
%hwnd = Screen('OpenWindow', scrInd, bgColor, [0, 0, scrWidth, scrHeight], pixSize, 2, [], 4, []);
hwnd = Screen('OpenWindow', scrInd, bgColor, [], [], [], [], 4, [], [], []);
[scrW, scrH] = Screen('WindowSize', hwnd);
%scrW = scrRes.width;
%scrH = scrRes.height;
%scrRec = Screen('Rect', hwnd)
%scrL = scrRec(1);
%scrT = scrRec(2);
Screen('BlendFunction', hwnd, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
%ShowCursor(0, scrInd);

%rec_center = [scrW/2, scrH/2, scrW/2, scrH/2];

%fps = 60;
fps = Screen('FrameRate', hwnd);      % frames per second
ifi = Screen('GetFlipInterval', hwnd);
if (fps == 0)
    fps = 1/ifi;
end

