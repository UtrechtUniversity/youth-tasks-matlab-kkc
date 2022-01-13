function [tex, rec] = c_load_image(img_file, hwnd)

global color_calib;

[img, map, alpha] = imread(img_file);
img = img * color_calib;

if (~isempty(alpha))
    img(:,:,4) = alpha;
end
siz = size(img);
tex = Screen('makeTexture', hwnd, img);
rec = [0, 0, siz(2), siz(1)];
