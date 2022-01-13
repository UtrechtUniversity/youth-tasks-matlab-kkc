function [qOLL, qILL, qIUL, qOUL] = Discount_Deside(choice, SSR, LLR, OLL, ILL, IUL, OUL)

qOLL = OLL;
qILL = ILL;
qIUL = IUL;
qOUL = OUL;

if (choice == 0)    %SSR
    if (SSR < IUL)
        if (SSR < ILL)
            qOLL = 0;
            qILL = SSR;
        else
            qOUL = IUL;
            qIUL = SSR;
        end
    else            %SSR >= IUL
        qOUL = SSR;
    end
else                %LLR
    if (SSR > ILL)
        if (SSR > IUL)
            qOUL = LLR;
            qIUL = SSR;
        else
           qOLL = ILL;
           qILL = SSR;
        end
    else            %SSR <= ILL
        qOLL = SSR;
    end
end
