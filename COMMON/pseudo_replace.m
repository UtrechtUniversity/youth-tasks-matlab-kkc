function [newText] = pseudo_replace(text, oldPseudo, newPseudo)

if (length(text) > 7)
    if ((strcmpi(text(1:6), oldPseudo) == 1) && (strcmpi(text(7), '_') == 1))
        newText = [newPseudo '_' text(8:end)];
    else
        newText = text;
    end
else
    newText = text;
end

