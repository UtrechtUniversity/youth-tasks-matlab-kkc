
rec_btn_ok = [scrW-200, scrH-100, scrW-100, scrH-64];
rec_btn_ok_text = rec_btn_ok - [0, 4, 0, 4];

font_size_instruction = 24;
wrap_chars_instruction = 1.6 * (4*scrW/6) / font_size_instruction;
font_color_instruction = black;

title_scale = scrH / (3 * title_rec(4));
rec_center = [scrW/2, scrH/2, scrW/2, scrH/2];
rec_title_img = rec_center + title_scale * [-title_rec(3)/2, -title_rec(4)/2, title_rec(3)/2, title_rec(4)/2];

