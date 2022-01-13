function [tex, rec] = c_load_image_grayalpha(img_file, hwnd, alphavalmin, alphavalmax)

global color_calib;

[img, map, alpha] = imread(img_file);
img = img * color_calib;

A = (img(:,:,1) >= alphavalmin) & (img(:,:,2) >= alphavalmin) & (img(:,:,3) >= alphavalmin) & (img(:,:,1) <= alphavalmax) & (img(:,:,2) <= alphavalmax) & (img(:,:,3) <= alphavalmax);
img(:,:,4) = ~A .* 255;

siz = size(img);
tex = Screen('makeTexture', hwnd, img);
rec = [0, 0, siz(2), siz(1)];
