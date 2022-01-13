


scale = (scrH-100) / (2*400);

rec_img_size = scale * [0, 0, 400, 320];

if (task_type == 2)
    rec_dif_h = (scrW / 2 - rec_img_size(3)) / 2;
    rec_dif_v = (scrH / 2 - rec_img_size(4)) / 2;
else
    rec_dif_h = 10;
    rec_dif_v = 10;
end

rec_img1 = rec_center + [-rec_img_size(3), -rec_img_size(4), 0, 0] + [-rec_dif_h, -rec_dif_v, -rec_dif_h, -rec_dif_v];
rec_img2 = rec_center + [0, -rec_img_size(4), rec_img_size(3), 0]  + [ rec_dif_h, -rec_dif_v,  rec_dif_h, -rec_dif_v];
rec_img3 = rec_center + [-rec_img_size(3), 0, 0, rec_img_size(4)]  + [-rec_dif_h,  rec_dif_v, -rec_dif_h,  rec_dif_v];
rec_img4 = rec_center + [0, 0, rec_img_size(3), rec_img_size(4)]   + [ rec_dif_h,  rec_dif_v,  rec_dif_h,  rec_dif_v];


rec_img_size_small = scale * [0, 0, 200, 160];

rec_center_small = rec_center + [0, scrH/6, 0, scrH/6];

rec_img1_small = rec_center_small + [-rec_img_size_small(3), -rec_img_size_small(4), 0, 0] + 0.5 * [-10, -10, -10, -10];
rec_img2_small = rec_center_small + [0, -rec_img_size_small(4), rec_img_size_small(3), 0] + 0.5 * [10, -10, 10, -10];
rec_img3_small = rec_center_small + [-rec_img_size_small(3), 0, 0, rec_img_size_small(4)] + 0.5 * [-10, 10, -10, 10];
rec_img4_small = rec_center_small + [0, 0, rec_img_size_small(3), rec_img_size_small(4)] + 0.5 * [10, 10, 10, 10];


rec_snd_btn = [32, 32, 96, 96];

rec_snd_btn_mult{1} = [32, 32, 96, 96];
rec_snd_btn_mult{2} = [32, 128, 96, 192];
rec_snd_btn_mult{3} = [32, 224, 96, 288];
rec_snd_btn_mult{4} = [32, 320, 96, 384];



