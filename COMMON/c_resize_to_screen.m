function [rdst] = c_resize_to_screen(rsrc, scrW, scrH)

dx = scrW / rsrc(3);
dy = scrH / rsrc(4);
if (dx < dy)
    rtmp = dx * rsrc;
else
    rtmp = dy * rsrc;
end
rdst = rtmp + ([scrW scrH scrW scrH] - [rtmp(3) rtmp(4) rtmp(3) rtmp(4)]) / 2;


