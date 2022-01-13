

%rec_play1 = rec_center + (player_rec - 1.5 * [player_rec(3), 0, player_rec(3), 0]) / (1.5*scale) + [0, 80, 0, 80]; % [0, screenYpixels/4, 0, screenYpixels/4];
%rec_play2 = rec_center + (player_rec - 0.5 * [player_rec(3), 0, player_rec(3), 0]) / (1.5*scale) + [0, 80, 0, 80]; % [0, screenYpixels/4, 0, screenYpixels/4];
%rec_play3 = rec_center + (player_rec + 0.5 * [player_rec(3), 0, player_rec(3), 0]) / (1.5*scale) + [0, 80, 0, 80]; % [0, screenYpixels/4, 0, screenYpixels/4];

%player_connected = zeros(1,3);


rec_text_conn = [0, scrH/4, scrW, scrH/2];
rec_prg = rec_center + [-40, 0-40, 40, 0+40];

startAngle = zeros(5);
arcAngle = zeros(5);
delayAng = 0;
state = 0;



time_conn1 = (2 + randi(3)) * fps;
time_conn2 = time_conn1 + (3 + randi(3)) * fps;
time_conn3 = time_conn2 + (6 + randi(6)) * fps;
time_total = time_conn3 + (1 + randi(2)) * fps;


%bRunning = 1;
%while (bRunning)
for i = 1 : time_total
    
    
    
%     if (state == 0)
%         arcAngle = arcAngle + 4
%         
%         if (arcAngle >= 360)
%             state = 1;
%         end
%     else
%         arcAngle = arcAngle - 4
%         startAngle = startAngle + 4;
%         if (arcAngle <= 0)
%             state = 0;
%             startAngle = 0;
%         end
%     end


    dA = 2 + 3 * (startAngle(1) / 360) - 1/20;
    if (startAngle(1) < 360-16)
        if (arcAngle(1) > 16)
            startAngle(1) = startAngle(1) + dA;
        else
            arcAngle(1) = arcAngle(1) + dA;
        end
    elseif (startAngle(1) < 360)
        startAngle(1) = startAngle(1) + dA;
        arcAngle(1) = 360 - startAngle(1);
    end
    
    for j = 2 : 5
        dA = 2 + 3 * (startAngle(j) / 360) - j / 20;
        if (startAngle(j-1) > 16)
            if (startAngle(j) < 360)
                
                if (startAngle(j) < 360-16)
                    if (arcAngle(j) > 16)
                        startAngle(j) = startAngle(j) + dA;
                    else
                        arcAngle(j) = arcAngle(j) + dA;
                    end
                elseif (startAngle(j) < 360)
                    startAngle(j) = startAngle(j) + dA;
                    arcAngle(j) = 360 - startAngle(j);
                end
                
            end
        end
    end
    
    if (startAngle(5) >= 360)
        delayAng = delayAng + 1;
        if (delayAng >= 20)
            delayAng = 0;
            startAngle(:) = 0;
            arcAngle(:) = 0;
        end
    end
    
    
    for a = 1:5
        Screen('FrameArc', hwnd, color_conn, rec_prg, startAngle(a), arcAngle(a), 3, 3)
    end
    
    Screen('TextFont', hwnd, 'Arial');
    Screen('TextSize', hwnd, 20);
    DrawFormattedText(hwnd, 'Verbinding maken met centrale server', 'center', 'center', color_conn, [], 0, 0, 2, 0, rec_text_conn);
    
    
    if (i >= time_conn1) %(player_connected(1) == 1)
        %Screen('DrawTexture', hwnd, player_tex, player_rec, rec_play1, 0);
    end
    if (i >= time_conn2) %(player_connected(2) == 1)
        %Screen('DrawTexture', hwnd, player_tex, player_rec, rec_play2, 0);
    end
    if (i >= time_conn3) %(player_connected(3) == 1)
        %Screen('DrawTexture', hwnd, player_tex, player_rec, rec_play3, 0);
    end
    
    Screen('Flip', hwnd);
end