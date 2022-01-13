
if (cur_target == 2)
    cur_jit(i) = 1;
end
for frame_step = 1 : cur_jit(i)
    Screen('DrawTexture', hwnd, img_tex{cur_target,view_target(cur_target),img_seq(1)}, rsrc_img{cur_target,view_target(cur_target),img_seq(1)}, draw_rec, 0);
    
    if ((cur_target == 2) && (new_target == -1))
        prosocial_input_nodraw;
    end
    
    Screen(hwnd, 'TextSize', 18);
    DrawFormattedText(hwnd, 'Speler 1', 'center', 'center', black, [], 0, 0, [], 0, rec_txt1);
    DrawFormattedText(hwnd, 'Speler 2', 'center', 'center', black, [], 0, 0, [], 0, rec_txt2);
    DrawFormattedText(hwnd, 'Speler 3', 'center', 'center', black, [], 0, 0, [], 0, rec_txt3);
    
    Screen('Flip', hwnd);
end
