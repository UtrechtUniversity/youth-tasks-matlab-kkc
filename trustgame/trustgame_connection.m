


rec_text_title = [scrW/4, 0, 3*scrW/4, rec_choice_brd(2)]; %scrH/4];

rec_text_cont = [scrW/4, rec_choice_brd(4), 3*scrW/4, scrH];

text_connection = 'Bezig met verbinding te maken met de andere spelers...';

frame_cnt = 0;

bRunning = 1;
while (bRunning)
    
    if (frame_cnt > fps * 7)
        bRunning = 0;
    end
        
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_connection, 'center', 'center', font_color_instruction, wrap_chars_instruction, 0, 0, 2, 0, rec_text_title);
    
    Screen('Flip', hwnd);
    
    frame_cnt = frame_cnt + 1;
end


for i = 1 : 30
    Screen('Flip', hwnd);
end


