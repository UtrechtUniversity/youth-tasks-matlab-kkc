

answer = -1;
        selImg = -1;
        
        
        %player = audioplayer(audio_pract{curset,1,pract_snd_ind}, fs_pract(curset,1,pract_snd_ind));


%------------------------------------------------------------------
        rec_i1 = c_scale_rec(img_pract_rec{curset,1}, rec_img1_small);
        rec_i2 = c_scale_rec(img_pract_rec{curset,2}, rec_img2_small);
        rec_i3 = c_scale_rec(img_pract_rec{curset,3}, rec_img3_small);
        rec_i4 = c_scale_rec(img_pract_rec{curset,4}, rec_img4_small);
        
        frame_cnt = 0;
        %for frame = 1 : 60
        while (answer == -1)
            
            Screen('FillRect', hwnd, clr_img_bg, rec_img1_small);
            Screen('FillRect', hwnd, clr_img_bg, rec_img2_small);
            Screen('FillRect', hwnd, clr_img_bg, rec_img3_small);
            Screen('FillRect', hwnd, clr_img_bg, rec_img4_small);
            
            Screen('DrawTexture', hwnd, img_pract_tex{curset,1}, img_pract_rec{curset,1}, rec_i1); %, [], [], [], clr_mod);
            Screen('DrawTexture', hwnd, img_pract_tex{curset,2}, img_pract_rec{curset,2}, rec_i2); %, [], [], [], clr_mod);
            Screen('DrawTexture', hwnd, img_pract_tex{curset,3}, img_pract_rec{curset,3}, rec_i3); %, [], [], [], clr_mod);
            Screen('DrawTexture', hwnd, img_pract_tex{curset,4}, img_pract_rec{curset,4}, rec_i4); %, [], [], [], clr_mod);
            
            Screen('FrameRect', hwnd, black, rec_img1_small, 1+(selImg==1));
            Screen('FrameRect', hwnd, black, rec_img2_small, 1+(selImg==2));
            Screen('FrameRect', hwnd, black, rec_img3_small, 1+(selImg==3));
            Screen('FrameRect', hwnd, black, rec_img4_small, 1+(selImg==4));
            
            Screen('TextFont', hwnd, 'Arial');
            Screen('TextSize', hwnd, 18);
            DrawFormattedText(hwnd, text_instruction, 'center', 'center', black, [], [], [], [], [], [0, 0, scrW, rec_img1_small(2)]);
            
            Screen('Flip', hwnd);
            
            %frame_cnt = frame_cnt + 1;
            %if (frame_cnt == 60*2)
            %    play(player);
            %end
            
            if (bChoose == 1)
                [eX, eY, buttons] = GetMouse(scrInd);
                
                selImg = -1;
                if ((eX >= rec_img1_small(1)) && (eX <= rec_img1_small(3)) && (eY >= rec_img1_small(2)) && (eY <= rec_img1_small(4)))
                    selImg = 1;
                end
                if ((eX >= rec_img2_small(1)) && (eX <= rec_img2_small(3)) && (eY >= rec_img2_small(2)) && (eY <= rec_img2_small(4)))
                    selImg = 2;
                end
                if ((eX >= rec_img3_small(1)) && (eX <= rec_img3_small(3)) && (eY >= rec_img3_small(2)) && (eY <= rec_img3_small(4)))
                    selImg = 3;
                end
                if ((eX >= rec_img4_small(1)) && (eX <= rec_img4_small(3)) && (eY >= rec_img4_small(2)) && (eY <= rec_img4_small(4)))
                    selImg = 4;
                end
                
                if (buttons(1) == 1)
                    answer = selImg;
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
        
        
