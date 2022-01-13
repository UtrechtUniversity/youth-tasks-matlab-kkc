function [result] = c_cmd_ask_yesno(text)

bOK = 0;
while (~bOK)
    answer = strtrim(input([text ' (Y/N): '], 's'));
    if (strcmp(answer, 'Y') || strcmp(answer, 'y'))
        bOK = 1;
        result = 1;
    elseif (strcmp(answer, 'N') || strcmp(answer, 'n'))
        bOK = 1;
        result = 0;
    end
end

