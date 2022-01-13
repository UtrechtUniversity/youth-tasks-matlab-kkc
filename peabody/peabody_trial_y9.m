
rec_i1 = c_scale_rec(img_rec{curset,i,1}, rec_img1);
rec_i2 = c_scale_rec(img_rec{curset,i,2}, rec_img2);
rec_i3 = c_scale_rec(img_rec{curset,i,3}, rec_img3);
rec_i4 = c_scale_rec(img_rec{curset,i,4}, rec_img4);

frame_cnt = 0;
%for frame = 1 : 60

time0 = GetSecs;
while (answer == -1)
    
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
    
    if ((bPlayedTwice == 0) && (bEnableScnd == 1))
        Screen('DrawTexture', hwnd, sound_tex, sound_rec, rec_snd_btn);
        if (bSelSound == 1)
            Screen('FrameRect', hwnd, black, rec_snd_btn, 1);
        end
    end
    
    %Screen('TextFont', hwnd, 'Arial');
    %Screen('TextSize', hwnd, 18);% should be commented out!!!
    %unless we debug and print words
    %DrawFormattedText(hwnd, words{curset,i}, 'center', 'center', black, [], [], [], [], [], [0, 0, scrW, rec_img1(2)]);%idem
    
    Screen('Flip', hwnd);
    
    frame_cnt = frame_cnt + 1;
    if (frame_cnt == 60*2)
        play(player);
        bEnableScnd = 1;
    end
    
    [eX, eY, buttons] = GetMouse(scrInd);
    time1 = GetSecs;
    
    selImg = -1;
    if (bEnableScnd == 1)
        if ((eX >= rec_img1(1)) && (eX <= rec_img1(3)) && (eY >= rec_img1(2)) && (eY <= rec_img1(4)))
            selImg = 1;
        end
        if ((eX >= rec_img2(1)) && (eX <= rec_img2(3)) && (eY >= rec_img2(2)) && (eY <= rec_img2(4)))
            selImg = 2;
        end
        if ((eX >= rec_img3(1)) && (eX <= rec_img3(3)) && (eY >= rec_img3(2)) && (eY <= rec_img3(4)))
            selImg = 3;
        end
        if ((eX >= rec_img4(1)) && (eX <= rec_img4(3)) && (eY >= rec_img4(2)) && (eY <= rec_img4(4)))
            selImg = 4;
        end
        if ((eX >= rec_snd_btn(1)) && (eX <= rec_snd_btn(3)) && (eY >= rec_snd_btn(2)) && (eY <= rec_snd_btn(4)))
            if ((bPlayedTwice == 0) && (bEnableScnd == 1))
                bSelSound = 1;
                if (buttons(1) == 1)
                    play(player2);
                    bPlayedTwice = 1;
                end
            end
        else
            bSelSound = 0;
        end
        
        if (buttons(1) == 1)
            curreact = 1000 * (time1 - time0);
            answer = selImg;
        end
    end
end

for frame = 1 : 20
    Screen('Flip', hwnd);
end

while (buttons(1) == 1)
    [eX, eY, buttons] = GetMouse(scrInd);
end

