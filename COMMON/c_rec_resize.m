function [rec] = c_rec_resize(rec_src, scale)

w = (rec_src(3) - rec_src(1));
h = (rec_src(4) - rec_src(2));
cx = (rec_src(1) + rec_src(3)) / 2;
cy = (rec_src(2) + rec_src(4)) / 2;

rec = [cx cy cx cy] + scale * [-w -h w h] / 2;
