

% draw the background
Screen('DrawTexture', hwnd, imgTex1, rsrc_img1, posImg1, 0);

% Draw the question
Screen('TextColor', hwnd, 0);
Screen('TextFont', hwnd, 'Georgia');
Screen(hwnd, 'TextSize', 60);
DrawFormattedText(hwnd, textVraag, 'center', scrH/2 - 130);

%------------------------------------------------------------------



% make the text for the buttons
if (floor(varAmount) == varAmount)
    txtVar = strrep(sprintf(textVariableInt, varAmount), '.', ',');
else
    txtVar = strrep(sprintf(textVariableFrac, varAmount), '.', ',');
end
if (floor(fixAmount) == fixAmount)
    txtFix = strrep(sprintf(textFixedInt, fixAmount, QDelays(curInd)), '.', ',');
else
    txtFix = strrep(sprintf(textFixedFrac, fixAmount, QDelays(curInd)), '.', ',');
end

% Draw the text on the buttons
Screen('TextFont', hwnd, 'Verdana');
%Screen(hwnd, 'TextSize', 14);

TextSizeBtnL = 14 + (overButton == 0) * 6;
TextSizeBtnR = 14 + (overButton == 1) * 6;
if (flip_btn == 0)
    Screen(hwnd, 'TextSize', TextSizeBtnL);
    DrawFormattedText(hwnd, txtVar, 'center', 'center', btnColor1, [], 0, 0, [], 0, lBtnRgn);
    Screen(hwnd, 'TextSize', TextSizeBtnR);
    DrawFormattedText(hwnd, txtFix, 'center', 'center', btnColor2, [], 0, 0, [], 0, rBtnRgn);
else
    Screen(hwnd, 'TextSize', TextSizeBtnL);
    DrawFormattedText(hwnd, txtFix, 'center', 'center', btnColor1, [], 0, 0, [], 0, lBtnRgn);
    Screen(hwnd, 'TextSize', TextSizeBtnR);
    DrawFormattedText(hwnd, txtVar, 'center', 'center', btnColor2, [], 0, 0, [], 0, rBtnRgn);
end

% if the mouse cursor is over one of the buttons, then draw a
% rectangle around the button
if (overButton == 0)
    Screen('FrameRect', hwnd , [213 223 239], lBtnRgn);
elseif (overButton == 1)
    Screen('FrameRect', hwnd , [213 223 239], rBtnRgn);
end

% Show the new screen
Screen('Flip', hwnd);


