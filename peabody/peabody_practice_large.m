

        answer = -1;
        selImg = -1;
        
        if (bChoose == 1)
            player = audioplayer(audio_pract{curset,1,pract_snd_ind}, fs_pract(curset,1,pract_snd_ind));
            player2 = audioplayer(audio_pract{curset,2,pract_snd_ind}, fs_pract(curset,2,pract_snd_ind));
        end
        bPlayedTwice = 0;
        bSelSound = 0;
        bEnableScnd = ~bPlayFirst;
        
%------------------------------------------------------------------
        rec_i1 = c_scale_rec(img_pract_rec{curset,1}, rec_img1);
        rec_i2 = c_scale_rec(img_pract_rec{curset,2}, rec_img2);
        rec_i3 = c_scale_rec(img_pract_rec{curset,3}, rec_img3);
        rec_i4 = c_scale_rec(img_pract_rec{curset,4}, rec_img4);
        
        frame_cnt = 0;
        %for frame = 1 : 60
        while (answer == -1)
            
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
            
            if ((bChoose == 1) && (bPlayedTwice == 0) && (bEnableScnd == 1))
                Screen('DrawTexture', hwnd, sound_tex, sound_rec, rec_snd_btn);
                if (bSelSound == 1)
                    Screen('FrameRect', hwnd, black, rec_snd_btn, 1);
                end
            end
             
            if (bShowInstruction == 1)
                Screen('TextFont', hwnd, 'Arial');
                Screen('TextSize', hwnd, 18);
                DrawFormattedText(hwnd, text_instruction, 'center', 'center', black, [], [], [], [], [], [0, 0, scrW, rec_img1(2)]);
            end
            
            Screen('Flip', hwnd);
            
            if (bChoose == 1)
                frame_cnt = frame_cnt + 1;
                if ((frame_cnt == 60*2) && (bPlayFirst == 1))
                    play(player);
                    bEnableScnd = 1;
                end
            
            
                [eX, eY, buttons] = GetMouse(scrInd);
                
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
                        answer = selImg;
                    end
                end
            else
                
                [keyDown, keySec, keyCode] = KbCheck(keyDevice);
                if (keyCode(key_space))
                    answer = 5;
                end
                
            end
        end
        
        for frame = 1 : 20
            Screen('Flip', hwnd);
        end
        
        if (bChoose == 1)
            while (buttons(1) == 1)
                [eX, eY, buttons] = GetMouse(scrInd);
            end
        end
        
        