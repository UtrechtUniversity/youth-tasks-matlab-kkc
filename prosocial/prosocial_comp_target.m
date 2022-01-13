
ind = 1 : 4;
cnt = counter(cur_player,:);
if ((do_exclude == 1) && (cur_player ~= 4))
    ind(4) = [];
    cnt(4) = [];
end
ind(cur_player) = [];
cnt(cur_player) = [];
m = max(cnt);
sel = ind(~(cnt == m));
if isempty(sel)
    sel = ind;
end
i_sel = randi(length(sel));

cur_target = sel(i_sel);


