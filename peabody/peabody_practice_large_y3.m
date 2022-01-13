
answer = -1;
selImg = -1;
overImg = -1;
bMouseDown = 0;
bKeyDown = 0;

for pract_snd_ind = 1 : 4
    for snd_ver = 1 : 2
        player{pract_snd_ind,snd_ver} = audioplayer(audio_pract{curset,snd_ver,pract_snd_ind}, fs_pract(curset,snd_ver,pract_snd_ind));
    end
end

iCntPlayed = zeros(1, 4);
bSelSound = zeros(1, 4);

SetMouse(scrW/2, scrH/2);

%------------------------------------------------------------------
rec_i1 = c_scale_rec(img_pract_rec{curset,1}, rec_img1);
rec_i2 = c_scale_rec(img_pract_rec{curset,2}, rec_img2);
rec_i3 = c_scale_rec(img_pract_rec{curset,3}, rec_img3);
rec_i4 = c_scale_rec(img_pract_rec{curset,4}, rec_img4);

frame_cnt = 0;
bContinue = 0;
bQuit = 0;
while ((bContinue == 0) && (bQuit == 0))
    
    Screen('FillRect', hwnd, clr_img_bg, rec_img1);
    Screen('FillRect', hwnd, clr_img_bg, rec_img2);
    Screen('FillRect', hwnd, clr_img_bg, rec_img3);
    Screen('FillRect', hwnd, clr_img_bg, rec_img4);
    
    Screen('DrawTexture', hwnd, img_pract_tex{curset,1}, img_pract_rec{curset,1}, rec_i1); %, [], [], [], clr_mod);
    Screen('DrawTexture', hwnd, img_pract_tex{curset,2}, img_pract_rec{curset,2}, rec_i2); %, [], [], [], clr_mod);
    Screen('DrawTexture', hwnd, img_pract_tex{curset,3}, img_pract_rec{curset,3}, rec_i3); %, [], [], [], clr_mod);
    Screen('DrawTexture', hwnd, img_pract_tex{curset,4}, img_pract_rec{curset,4}, rec_i4); %, [], [], [], clr_mod);
    
    Screen('FrameRect', hwnd, black, rec_img1, 1+(selImg==1));
    Screen('FrameRect', hwnd, black, rec_img2, 1+(selImg==2));
    Screen('FrameRect', hwnd, black, rec_img3, 1+(selImg==3));
    Screen('FrameRect', hwnd, black, rec_img4, 1+(selImg==4));
    
    
    if (iCntPlayed(1) == 0)
        Screen('DrawTexture', hwnd, sound_tex, sound_rec, rec_snd_btn_mult{1});
    elseif (iCntPlayed(1) == 1)
        Screen('DrawTexture', hwnd, sndgray_tex, sndgray_rec, rec_snd_btn_mult{1});
    end
    if (iCntPlayed(2) == 0)
        Screen('DrawTexture', hwnd, sound_tex, sound_rec, rec_snd_btn_mult{2});
    elseif (iCntPlayed(2) == 1)
        Screen('DrawTexture', hwnd, sndgray_tex, sndgray_rec, rec_snd_btn_mult{2});
    end
    if (iCntPlayed(3) == 0)
        Screen('DrawTexture', hwnd, sound_tex, sound_rec, rec_snd_btn_mult{3});
    elseif (iCntPlayed(3) == 1)
        Screen('DrawTexture', hwnd, sndgray_tex, sndgray_rec, rec_snd_btn_mult{3});
    end
    if (iCntPlayed(4) == 0)
        Screen('DrawTexture', hwnd, sound_tex, sound_rec, rec_snd_btn_mult{4});
    elseif (iCntPlayed(4) == 1)
        Screen('DrawTexture', hwnd, sndgray_tex, sndgray_rec, rec_snd_btn_mult{4});
    end
    
    for btn = 1 : 4
        if ((bSelSound(btn) == 1) && (iCntPlayed(btn) < 2))
            Screen('FrameRect', hwnd, black, rec_snd_btn_mult{btn}, 1);
        end
    end
    
    Screen('Flip', hwnd);
    
    frame_cnt = frame_cnt + 1;
    
    %----------------------------------------------------------------------
    
    [eX, eY, buttons] = GetMouse(scrInd);
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
    
    bSelSound = zeros(1, 4);
    for btn = 1 : 4
        rec_tmp = rec_snd_btn_mult{btn};
        if ((eX >= rec_tmp(1)) && (eX <= rec_tmp(3)) && (eY >= rec_tmp(2)) && (eY <= rec_tmp(4)))
            
            bSelSound(btn) = 1;
            if ((buttons(1) == 1) && (bMouseDown == 0))
                if (iCntPlayed(btn) < 2)
                    play(player{btn, iCntPlayed(btn)+1});
                    iCntPlayed(btn) = iCntPlayed(btn) + 1;
                end
            end
        end
    end
    
    if (buttons(1) == 1)
        %answer = selImg;
        if (overImg ~= -1)
            selImg = overImg;
        end
        bMouseDown = 1;
        SetMouse(scrW/2, scrH/2);
    else
        bMouseDown = 0;
    end
    
    %----------------------------------------------------------------------
    
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    
    iPlaySound = -1;
    if (keyCode(key_1))
        selImg = 1;
    elseif (keyCode(key_2))
        selImg = 2;
    elseif (keyCode(key_3))
        selImg = 3;
    elseif (keyCode(key_4))
        selImg = 4;
    elseif (keyCode(key_a))
        iPlaySound = 1;
    elseif (keyCode(key_s))
        iPlaySound = 2;
    elseif (keyCode(key_d))
        iPlaySound = 3;
    elseif (keyCode(key_f))
        iPlaySound = 4;
    elseif (keyCode(key_continue))
        bContinue = 1;
    elseif (keyCode(key_quit))
        peabody_quit_screen;
    end
    
    if ((iPlaySound ~= -1) && (bKeyDown == 0))
        bSelSound(iPlaySound) = 1;
        if (iCntPlayed(iPlaySound) < 2)
            play(player{iPlaySound, iCntPlayed(iPlaySound)+1});
            iCntPlayed(iPlaySound) = iCntPlayed(iPlaySound) + 1;
        end
    end
    
    bKeyDown = keyDown;
    
    %----------------------------------------------------------------------
end

for frame = 1 : 20
    Screen('Flip', hwnd);
end

SetMouse(scrW/2, scrH/2);

while (keyDown == 1) % || (buttons(1) == 1))
    %[eX, eY, buttons] = GetMouse(scrInd);
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
end

SetMouse(scrW/2, scrH/2);


