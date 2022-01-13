

for frame_step = 1 : 16 %one more because of jitter
    Screen('DrawTexture', hwnd, img_tex{cur_player,cur_target,img_seq(1)}, rsrc_img{cur_player,cur_target,img_seq(1)}, draw_rec, 0);
    
    Screen(hwnd, 'TextSize', 18);
    DrawFormattedText(hwnd, 'Speler 1', 'center', 'center', black, [], 0, 0, [], 0, rec_txt1);
    DrawFormattedText(hwnd, 'Speler 2', 'center', 'center', black, [], 0, 0, [], 0, rec_txt2);
    DrawFormattedText(hwnd, 'Speler 3', 'center', 'center', black, [], 0, 0, [], 0, rec_txt3);
    
    Screen('Flip', hwnd);
end

