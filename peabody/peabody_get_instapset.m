
age_calc_ok = 1;

instap = -1;
for i = 1 : length(ages)
    if ((age_y > ages(i,1)) && (age_y < ages(i,3)))
        instap = i;
        break;
    elseif ((age_y == ages(i,1)) && (age_y == ages(i,3)))
        if ((age_m >= ages(i,2)) && (age_m <= ages(i,4)))
            instap = i;
            break;
        end
    elseif ((age_y == ages(i,1)) && (age_m >= ages(i,2)))
        instap = i;
        break;
    elseif ((age_y == ages(i,3)) && (age_m <= ages(i,4)))
        instap = i;
        break;
    end
end

if (instap == -1)
    disp('<strong>WARNING: leefttijd valt buiten de leeftijdsgroepen</strong>')
    if (age_y <= 2)
        instap = 1;
    else
        instap = 14;
    end
    disp(sprintf('instap groep: %d', instap));
    
    age_calc_ok = c_cmd_ask_yesno('Er is iets mis met de leeftijdsberekening, toch doorgaan?');
end
