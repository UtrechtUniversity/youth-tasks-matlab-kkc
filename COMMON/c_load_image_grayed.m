function [tex, rec] = c_load_image_grayed(img_file, hwnd, multiplier)

global color_calib;

[img, map, alpha] = imread(img_file);
img = (255 - (255 - img) * multiplier) * color_calib;

if (~isempty(alpha))
    img(:,:,4) = alpha;
end
siz = size(img);
tex = Screen('makeTexture', hwnd, img);
rec = [0, 0, siz(2), siz(1)];
