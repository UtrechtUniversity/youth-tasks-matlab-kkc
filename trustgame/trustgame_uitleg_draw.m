

%coin_count
%trial
%selT1
%selT2

KbName('UnifyKeyNames');
key_back = KbName('t');
goBack = 0;

rec_text_uitleg = [scrW/4, 0, 3*scrW/4, rec_n1a(2)];
rec_text_verder = [scrW/4, rec_t2b(4), 3*scrW/4, scrH];


%[keyDown, keySec, keyCode] = KbCheck(keyDevice);
bRunning = 1;
while (bRunning) %(~keyDown & bRunning)
    %[keyDown, keySec, keyCode] = KbCheck(keyDevice);
    
    trustgame_draw_state;
    hide_p2_choices = cur_hide_p2_choices;
    draw_coins_total_p1 = cur_draw_coins_total_p1;
    draw_coins_total_p2 = cur_draw_coins_total_p2;
    trustgame_draw_schema;
    
    
    %if (usemouse == 0)
        [keyDown, keySec, keyCode] = KbCheck(keyDevice);
        if (keyDown)
            if (keyCode(key_space))
                bRunning = 0;
            elseif (keyCode(key_back))
                bRunning = 0;
                goBack = 1;
            end
        end
%     else
%     
%         [eX, eY, buttons] = GetMouse(scrInd);
%         
%         if ((eX >= rec_btn_ok(1)) && (eX <= rec_btn_ok(3)) && (eY >= rec_btn_ok(2)) && (eY <= rec_btn_ok(4)))
%             Screen('FillRect', hwnd, gray, rec_btn_ok);
%             Screen('FrameRect', hwnd, black, rec_btn_ok, 1);
%             if (buttons(1))
%                 bRunning = 0;
%             end
%         else
%             Screen('FillRect', hwnd, lightgray, rec_btn_ok);
%             Screen('FrameRect', hwnd, gray, rec_btn_ok, 1);
%         end
%         Screen('TextFont', hwnd, 'Arial');
%         Screen('TextSize', hwnd, 14);
%         DrawFormattedText(hwnd, 'OK', 'center', 'center', black, [], [], [], [], [], rec_btn_ok_text);
%     end
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_uitleg, 'center', 'center', font_color_instruction, [], 0, 0, 1.5, 0, rec_text_uitleg);    %wrap_chars_instruction
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, font_size_instruction);
    DrawFormattedText(hwnd, text_verder, 'center', 'center', font_color_instruction, [], 0, 0, 1.5, 0, rec_text_verder);    %wrap_chars_instruction
    
    Screen('Flip', hwnd);
end


%if (usemouse == 0)
    [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    while (keyDown)
        [keyDown, keySec, keyCode] = KbCheck(keyDevice);
    end
% else
%     
%     Screen('TextFont', hwnd, 'Arial');
%     Screen('TextSize', hwnd, 14);
%     [eX, eY, buttons] = GetMouse;
%     while (buttons(1))
%         [eX, eY, buttons] = GetMouse;
%         Screen('FillRect', hwnd, lightgray, rec_btn_ok);
%         Screen('FrameRect', hwnd, black, rec_btn_ok, 1);
%         DrawFormattedText(hwnd, 'OK', 'center', 'center', black, [], [], [], [], [], rec_btn_ok_text);
%         Screen('Flip', hwnd);
%     end
% end

for i = 1 : 30
    Screen('Flip', hwnd);
end

% [keyDown, keySec, keyCode] = KbCheck(keyDevice);
% while (find(keyDown))
%     [keyDown, keySec, keyCode] = KbCheck(keyDevice);
% end




