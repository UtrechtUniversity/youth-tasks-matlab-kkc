
title_file = [media_path 'trustgame/munten.png'];
% [title_img, title_map, title_alpha] = imread(title_file);
% title_img(:,:,4) = title_alpha;
% title_size = size(title_img);
% title_tex = Screen('makeTexture', hwnd, title_img);
% title_rec = [0, 0, title_size(2), title_size(1)];
[title_tex, title_rec] = c_load_image(title_file, hwnd);

coin_file = [media_path 'trustgame/euro_10_cent_20x20.png'];
% [coin_img, coin_map, coin_alpha] = imread(coin_file);
% coin_img(:,:,4) = coin_alpha;
% coin_size = size(coin_img);
% coin_tex = Screen('makeTexture', hwnd, coin_img);
% coin_rec = [0, 0, coin_size(2), coin_size(1)];
[coin_tex, coin_rec] = c_load_image(coin_file, hwnd);

m1_file = [media_path 'trustgame/m1.bmp'];
% [m1_img, m1_map, m1_alpha] = imread(m1_file);
% %m1_img(:,:,4) = m1_alpha;
% m1_size = size(m1_img);
% m1_tex = Screen('makeTexture', hwnd, m1_img);
% m1_rec = [0, 0, m1_size(2), m1_size(1)];
[m1_tex, m1_rec] = c_load_image(m1_file, hwnd);

m2_file = [media_path 'trustgame/m2.bmp'];
% [m2_img, m2_map, m2_alpha] = imread(m2_file);
% %m2_img(:,:,4) = m2_alpha;
% m2_size = size(m2_img);
% m2_tex = Screen('makeTexture', hwnd, m2_img);
% m2_rec = [0, 0, m2_size(2), m2_size(1)];
[m2_tex, m2_rec] = c_load_image(m2_file, hwnd);

v1_file = [media_path 'trustgame/v1.bmp'];
% [v1_img, v1_map, v1_alpha] = imread(v1_file);
% %v1_img(:,:,4) = v1_alpha;
% v1_size = size(v1_img);
% v1_tex = Screen('makeTexture', hwnd, v1_img);
% v1_rec = [0, 0, v1_size(2), v1_size(1)];
[v1_tex, v1_rec] = c_load_image(v1_file, hwnd);

v2_file = [media_path 'trustgame/v2.bmp'];
% [v2_img, v2_map, v2_alpha] = imread(v2_file);
% %v2_img(:,:,4) = v2_alpha;
% v2_size = size(v2_img);
% v2_tex = Screen('makeTexture', hwnd, v2_img);
% v2_rec = [0, 0, v2_size(2), v2_size(1)];
[v2_tex, v2_rec] = c_load_image(v2_file, hwnd);

