function c_kkc_load_common_images(hwnd)

global common_media_path;

[tex_pauze rsrc_pauze] = c_load_image([common_media_path 'pauzescreen.jpg'], hwnd);
assignin('base', 'tex_pauze', tex_pauze);
assignin('base', 'rsrc_pauze', rsrc_pauze);


