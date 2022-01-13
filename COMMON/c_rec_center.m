function [rec] = c_rec_center(rec_src, hori, vert, scrW, scrH)

w = (rec_src(3) - rec_src(1));
h = (rec_src(4) - rec_src(2));
cx = (rec_src(1) + rec_src(3)) / 2;
cy = (rec_src(2) + rec_src(4)) / 2;

rec = [-w -h w h] / 2;

if (vert)
    rec = rec + [0 scrH/2 0 scrH/2];
else
    rec = rec + [0 cy 0 cy];
end

if (hori)
    rec = rec + [scrW/2 0 scrW/2 0];
else
    rec = rec + [cx 0 cx 0];
end

