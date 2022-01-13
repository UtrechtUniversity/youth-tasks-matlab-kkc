

img_files = cell(4, 4, 8);
img_tex = cell(4, 4, 8);
rsrc_img = cell(4, 4, 8);
for i = 1 : 4
    for j = 1 : 4
        if (i ~= j)
            for k = 1 : 4
                img_files{i,j,k} = [media_path 'prosocial/prosocial_' num2str(i) 'to' num2str(j) '_' num2str(k) '.bmp'];
                [img_tex{i,j,k}, rsrc_img{i,j,k}] = c_load_image(img_files{i,j,k}, hwnd);
            end
        end
    end
end

ball_file = [media_path 'prosocial/ball.bmp'];
[ball_tex, rsrc_ball] = c_load_image(ball_file, hwnd);

player_file = [media_path 'prosocial/prosocial_player.bmp'];
[player_tex, rsrc_player] = c_load_image(player_file, hwnd);

scale = 2;
player_rec = rsrc_player;

ball_rec = rsrc_ball / scale;
draw_rec = rec_center + [-1150, -850, 1150, 850] / scale;
img_seq = [1 2 3 3 3 3 4 4];

