

clr = black;
r = (rdst_cent_stim(4) - rdst_cent_stim(2));

x0_c = 0.75 * scrW;
y0_c = scrH / 2 - r;
arc_rec_cent = [ (x0_c-r), (y0_c-r), (x0_c+r), (y0_c+r) ];
a_cent = -pi/16;

x0_l = (rdst_peri_stim_left(3) + rdst_peri_stim_left(1)) / 2 + r;
y0_l = 0.75 * scrH - r;
arc_rec_left = [ (x0_l-r), (y0_l-r), (x0_l+r), (y0_l+r) ];
a_left = pi/2 - pi/16;

x0_r = (rdst_peri_stim_right(3) + rdst_peri_stim_right(1)) / 2 - r;
y0_r = 0.75 * scrH - r; % + 0.7;
arc_rec_right = [ (x0_r-r), (y0_r-r), (x0_r+r), (y0_r+r) ];
a_right = pi/2 + pi/16;

%Screen('TextFont', hwnd, 'Ariel');
Screen('TextSize', hwnd, 28);

font_color_instruction = black;
rec_screen = [0, 0, scrW, scrH];
rec_screen_top = [0, 0, scrW, scrH/4];
rec_screen_btm = [0, 3*scrH/4, scrW, scrH];

txt_instruction_practice = 'Eerst volgt een voorbeeld\n\nDe begeleider zal de taak uitleggen';

txt_explanation_1 = 'Kijk eerst naar de klok';
if (Rondom == 3)
    txt_explanation_2 = 'Kijk daarna naar de gele stip aan de zijkant';
else
    if (task_type == 3)
        txt_explanation_2 = 'Kijk daarna naar de andere kant';
    else
        txt_explanation_2 = 'Kijk daarna naar het figuur aan de zijkant';
    end
end

ang = 0;
state = 1;


while (1)
    
    saccade_keycheck;
    if (bQuit)
        return;
    end
    if (bSpace)
        if (state < 3)
            state = state + 1;
        end
    end
    if (bBack)
        if (state > 1)
            state = state - 1;
        end
    end
    if (bContinue)
        if (state == 3)
            break;
        end
    end
    
    if (state == 1)
        DrawFormattedText(hwnd, txt_instruction_practice, 'center', 'center', font_color_instruction, [], 0, 0, 2, 0, rec_screen);
    end
    
    if (state > 1)
        Screen('DrawTexture', hwnd, tex_cent, rsrc_cent, rdst_cent_stim, ang);
        
        Screen('FrameArc', hwnd, clr, arc_rec_cent, 40, 140, 4, 4);
        Screen('DrawLine', hwnd, clr, x0_c, y0_c + r, x0_c + 0.8 * cos(a_cent - pi/4)*30, y0_c + r + 0.8 * sin(a_cent - pi/4)*30, 4);
        Screen('DrawLine', hwnd, clr, x0_c, y0_c + r, x0_c + 0.8 * cos(a_cent + pi/4)*30, y0_c + r + 0.8 * sin(a_cent + pi/4)*30, 4);
        
        DrawFormattedText(hwnd, txt_explanation_1, 'center', 'center', font_color_instruction, [], 0, 0, 2, 0, rec_screen_top);
    end
    
    if (state == 3)
        Screen('DrawTexture', hwnd, tex_peri{3}, rsrc_peri{3}, rdst_peri_stim_left);
        
        if (task_type == 3)
            Screen('FrameArc', hwnd, clr, arc_rec_right, 90, 90, 4, 4);
            Screen('DrawLine', hwnd, clr, x0_r + r, y0_r, x0_r + r + 0.8 * cos(a_right - pi/4)*30, y0_r + 0.8 * sin(a_right - pi/4)*30, 4);
            Screen('DrawLine', hwnd, clr, x0_r + r, y0_r, x0_r + r + 0.8 * cos(a_right + pi/4)*30, y0_r + 0.8 * sin(a_right + pi/4)*30, 4);
            
            DrawLineDottedHorizontal_simple(hwnd, rgaze_peri_stim_right_schema(1), rgaze_peri_stim_right_schema(3), rgaze_peri_stim_right_schema(2), 0, 2);
            DrawLineDottedVertical_simple(hwnd, rgaze_peri_stim_right_schema(3), rgaze_peri_stim_right_schema(2), rgaze_peri_stim_right_schema(4), 0, 2);
            DrawLineDottedHorizontal_simple(hwnd, rgaze_peri_stim_right_schema(3), rgaze_peri_stim_right_schema(1), rgaze_peri_stim_right_schema(4), 0, 2);
            DrawLineDottedVertical_simple(hwnd, rgaze_peri_stim_right_schema(1), rgaze_peri_stim_right_schema(4), rgaze_peri_stim_right_schema(2), 0, 2);
        else
            Screen('FrameArc', hwnd, clr, arc_rec_left, 180, 90, 4, 4);
            Screen('DrawLine', hwnd, clr, x0_l - r, y0_l, x0_l - r + 0.8 * cos(a_left - pi/4)*30, y0_l + 0.8 * sin(a_left - pi/4)*30, 4);
            Screen('DrawLine', hwnd, clr, x0_l - r, y0_l, x0_l - r + 0.8 * cos(a_left + pi/4)*30, y0_l + 0.8 * sin(a_left + pi/4)*30, 4);
            
            DrawLineDottedHorizontal_simple(hwnd, rgaze_peri_stim_left_schema(1), rgaze_peri_stim_left_schema(3), rgaze_peri_stim_left_schema(2), 0, 2);
            DrawLineDottedVertical_simple(hwnd, rgaze_peri_stim_left_schema(3), rgaze_peri_stim_left_schema(2), rgaze_peri_stim_left_schema(4), 0, 2);
            DrawLineDottedHorizontal_simple(hwnd, rgaze_peri_stim_left_schema(3), rgaze_peri_stim_left_schema(1), rgaze_peri_stim_left_schema(4), 0, 2);
            DrawLineDottedVertical_simple(hwnd, rgaze_peri_stim_left_schema(1), rgaze_peri_stim_left_schema(4), rgaze_peri_stim_left_schema(2), 0, 2);
        end
        
        DrawFormattedText(hwnd, txt_explanation_2, 'center', 'center', font_color_instruction, [], 0, 0, 2, 0, rec_screen_btm);
    end
    
    Screen('Flip', hwnd);
    
end


