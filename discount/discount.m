


[keyDevice, barcodeKB] = c_find_keyboards();

%--- Setup experiment -----------------------------------------------------

discount_init;
[fileID, logfile] = discount_makelogfile(logpath, logtag, length(QDelays));

%--- Setup Screen ---------------------------------------------------------

[hwnd, fps, scrW, scrH] = c_setup_screen(0, [226 225 222], enable_synctest);
fps = 60;
c_make_colors(hwnd);
c_default_keys();
ShowCursor(0, 0);

%--- layout parameters ----------------------------------------------------

ButtonRect = [0, 0, 250, 140];      % size of a button

lBtnPos = [scrW/2 - 270, scrH/2 + 50]; % upper left corner of the button
rBtnPos = [scrW/2 + 20, scrH/2 + 50];  % upper left corner of the button

lBtnRgn = ButtonRect + [lBtnPos, lBtnPos];  % rect describing the area of the button
rBtnRgn = ButtonRect + [rBtnPos, rBtnPos];  % rect describing the area of the button

%--- Load Pictures --------------------------------------------------------

[imgTex1, rsrc_img1] = c_load_image([media_path 'discount/discountbg.bmp'], hwnd);
posImg1 = ([scrW, scrH, scrW, scrH] + [-rsrc_img1(3), -rsrc_img1(4), rsrc_img1(3), rsrc_img1(4)]) / 2;

[imgTex2, rsrc_img2] = c_load_image([media_path 'discount/discountbg2.bmp'], hwnd);
posImg2 = ([scrW, scrH, scrW, scrH] + [-rsrc_img2(3), -rsrc_img2(4), rsrc_img2(3), rsrc_img2(4)]) / 2;

%--- Show Intro Screen ----------------------------------------------------

discount_info_screen(hwnd, 0, imgTex2, rsrc_img2, posImg2, textUitleg);

%---  Trials --------------------------------------------------------------

for trial = 1 : MaxTrials
    selInd = randi(length(DelayInds));
    curInd = DelayInds(selInd);
    
    faketrial = 0;
    if (length(DelayInds) < length(QDelays))
        faketrial = (randi(1 + length(DelayInds)) == 1);
    end
    
    if (faketrial == 1)
        varAmount = MakeRandomAmount(0, fixAmount, step);
        curInd = randi(length(QDelays));
    else
        varAmount = MakeRandomAmount(qOLL(curInd), qOUL(curInd), step);
    end
    
    %----------------------------------------------------------------------
    
    flip_btn = randi(2) - 1;
    
    choice = -1;
    T0 = GetSecs * 1000;
    TClick = -1;
    
    overButton = -1;
    btnColor1 = 96;
    btnColor2 = 96;
    
    discount_drawtrial;
            
    while (choice == -1) % loop while no button is clicked
        
        % check if the mouse cursor is over one of the buttons 
        % and if one of the buttons is clicked
        
        [x,y,buttons] = GetMouse(hwnd);
        
         overButton = -1;
         btnColor1 = 96;
         btnColor2 = 96;
        % is mouse over button 1 ??
        if ((x > lBtnRgn(1)) && (x < lBtnRgn(3)) && (y > lBtnRgn(2)) && (y < lBtnRgn(4)))
            overButton = 0;
            btnColor1 = 0;
        end
        % is mouse over button 2 ??
        if ((x > rBtnRgn(1)) && (x < rBtnRgn(3)) && (y > rBtnRgn(2)) && (y < rBtnRgn(4)))
            overButton = 1;
            btnColor2 = 0;
        end
        % if the mouse button is clicked...
        if (buttons(1) == 1)
            TClick = GetSecs * 1000 - T0;
            choice = overButton;
        end
        
        %------------------------------------------------------------------
    end % loop while no button is clicked
    
    for i = 1 : floor(0.4 * 60)
        discount_drawtrial;
    end
    
    %----------------------------------------------------------------------
    
    if (flip_btn == 1)
        choice = -1 * choice + 1;
    end
    
    % update boundaries etc.
    if (faketrial == 0)
        [qOLL(curInd), qILL(curInd), qIUL(curInd), qOUL(curInd)] = Discount_Deside(choice, varAmount, fixAmount, qOLL(curInd), qILL(curInd), qIUL(curInd), qOUL(curInd));
        
        if (abs(qOUL(curInd) - qOLL(curInd)) <= step)
            QConverged(curInd) = 1;
            QResults(curInd) = varAmount;
            DelayInds(selInd) = [];
        end
    end
    
    discount_savetrial;

    % wait until mouse button released
    [x,y,buttons] = GetMouse(hwnd);
    while (buttons(1) == 1)
        [x,y,buttons] = GetMouse(hwnd);
    end
    
    % no more trials? then we are done
    if (length(DelayInds) == 0)
        break;
    end
end

%--- Done, close the log file ---------------------------------------------

fclose(fileID);

%--- Show the End Screen --------------------------------------------------

discount_info_screen(hwnd, 1, imgTex2, rsrc_img2, posImg2, textKlaar);

%--------------------------------------------------------------------------

sca

disp('Experiment completed')
disp(sprintf('The log file is: %s', logfile));


