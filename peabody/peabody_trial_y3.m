
%answer = -1;
%selImg = -1;
%overImg = -1;
%bMouseDown = 0;

%for pract_snd_ind = 1 : 4
%    for snd_ver = 1 : 2
%        player{pract_snd_ind,snd_ver} = audioplayer(audio_pract{curset,snd_ver,pract_snd_ind}, fs_pract(curset,snd_ver,pract_snd_ind));
%    end
%end

iCntPlayed = 0; % zeros(1, 4);
%bSelSound = zeros(1, 4);

%------------------------------------------------------------------
rec_i1 = c_scale_rec(img_rec{curset,i,1}, rec_img1);
rec_i2 = c_scale_rec(img_rec{curset,i,2}, rec_img2);
rec_i3 = c_scale_rec(img_rec{curset,i,3}, rec_img3);
rec_i4 = c_scale_rec(img_rec{curset,i,4}, rec_img4);

frame_cnt = 0;
frame_cnt_sel = 0;
bContinue = 0;
bQuit = 0;

SetMouse(scrW/2, scrH/2);
[eX, eY, buttons] = GetMouse(scrInd);
%preBtn = buttons(1);

time0 = GetSecs;
while ((bContinue == 0) && (bQuit == 0))
    
    Screen('FillRect', hwnd, clr_img_bg, rec_img1);
    Screen('FillRect', hwnd, clr_img_bg, rec_img2);
    Screen('FillRect', hwnd, clr_img_bg, rec_img3);
    Screen('FillRect', hwnd, clr_img_bg, rec_img4);
    
    Screen('DrawTexture', hwnd, img_tex{curset,i,1}, img_rec{curset,i,1}, rec_i1); %, [], [], [], clr_mod);
    Screen('DrawTexture', hwnd, img_tex{curset,i,2}, img_rec{curset,i,2}, rec_i2); %, [], [], [], clr_mod);
    Screen('DrawTexture', hwnd, img_tex{curset,i,3}, img_rec{curset,i,3}, rec_i3); %, [], [], [], clr_mod);
    Screen('DrawTexture', hwnd, img_tex{curset,i,4}, img_rec{curset,i,4}, rec_i4); %, [], [], [], clr_mod);
    
    Screen('FrameRect', hwnd, black, rec_img1, 1+(selImg==1));
    Screen('FrameRect', hwnd, black, rec_img2, 1+(selImg==2));
    Screen('FrameRect', hwnd, black, rec_img3, 1+(selImg==3));
    Screen('FrameRect', hwnd, black, rec_img4, 1+(selImg==4));
    
    Screen('Flip', hwnd);
    
    frame_cnt = frame_cnt + 1;
    
    if (selImg == -1)
        frame_cnt_sel = frame_cnt;
        
        %----------------------------------------------------------------------
        [eX, eY, buttons] = GetMouse(scrInd);
        time1 = GetSecs;
        
        overImg = -1;
        if ((eX >= rec_img1(1)) && (eX <= rec_img1(3)) && (eY >= rec_img1(2)) && (eY <= rec_img1(4)))
            overImg = 1;
        end
        if ((eX >= rec_img2(1)) && (eX <= rec_img2(3)) && (eY >= rec_img2(2)) && (eY <= rec_img2(4)))
            overImg = 2;
        end
        if ((eX >= rec_img3(1)) && (eX <= rec_img3(3)) && (eY >= rec_img3(2)) && (eY <= rec_img3(4)))
            overImg = 3;
        end
        if ((eX >= rec_img4(1)) && (eX <= rec_img4(3)) && (eY >= rec_img4(2)) && (eY <= rec_img4(4)))
            overImg = 4;
        end
        
        if (buttons(1) == 1) %&& (preBtn ~= buttons(1)))
            if (overImg ~= -1)
                selImg = overImg;
            end
        end
        %preBtn = buttons(1);
        
        %----------------------------------------------------------------------
        
        [keyDown, keySec, keyCode] = KbCheck(keyDevice);
        if (selImg == -1)
            time1 = GetSecs;
        end
        
        if (keyCode(key_1))
            selImg = 1;
        elseif (keyCode(key_2))
            selImg = 2;
        elseif (keyCode(key_3))
            selImg = 3;
        elseif (keyCode(key_4))
            selImg = 4;
        elseif (keyCode(key_repeat))
            if ((iCntPlayed < 2) && (bEnableScnd == 1))
                if (iCntPlayed == 0)
                    play(player);
                else
                    play(player2);
                end
                iCntPlayed = iCntPlayed + 1;
                bEnableScnd = 0;
                SetMouse(scrW/2, scrH/2);
                selImg = -1;
            end
        elseif (keyCode(key_quit))
            peabody_quit_screen;
        else
            bEnableScnd = 1;
        end
        
        if (iCntPlayed == 0)
            selImg = -1;
        end
        
        if (selImg ~= -1)
            curreact = 1000 * (time1 - time0);
        end
        %----------------------------------------------------------------------
    else
        if ((frame_cnt - frame_cnt_sel) > 30)
            bContinue = 1;
        end
    end
end

answer = selImg;

for frame = 1 : 20
    Screen('Flip', hwnd);
end

SetMouse(scrW/2, scrH/2);

while (keyDown == 1) % || (buttons(1) == 1))
    %[eX, eY, buttons] = GetMouse(scrInd);
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
end

SetMouse(scrW/2, scrH/2);

