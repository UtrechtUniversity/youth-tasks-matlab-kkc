


img_files = cell(17, 12, 4);
%img_size = cell(17, 12, 4);
img_tex = cell(17, 12, 4);
img_rec = cell(17, 12, 4);
l = 0;
%cnt = 0;
for i = 1 : 17
    for j = 1 : 12
        l=l+1;
        for k = 1 : 4
            img_files{i,j,k} = [media_path 'peabody/img_sets/peabody_' num2str(i) '_' num2str(j) '_' num2str(l) '_' num2str(k) '_.jpg'];
            %[img_tmp] = imread(img_files{i,j,k});
            %if (min(min(min(img_tmp))) == 0)
            %    cnt=cnt+1;
            %    img_tmp(:,:,1) = 255 - (1 - img_tmp(:,:,1)/255) * (255-51);
            %    img_tmp(:,:,2) = 255 - (1 - img_tmp(:,:,2)/255) * (255-71);
            %    img_tmp(:,:,3) = 255 - (1 - img_tmp(:,:,3)/255) * (255-191);
            %end
            %img_tmp(:,:,4) = 255 - 255 .* (img_tmp(:,:,1) == 255) .* (img_tmp(:,:,2) == 255) .* (img_tmp(:,:,3) == 255);
            %%%img_tmp(:,:,4) = (img_tmp(:,:,1) .* img_tmp(:,:,2) .* img_tmp(:,:,3)) / 16581375;
            %cur_size = size(img_tmp);
            %img_size{i,j,k} = cur_size;
            %img_tex{i,j,k} = Screen('makeTexture', hwnd, img_tmp);
            %img_rec{i,j,k} = [0, 0, cur_size(2), cur_size(1)];
            
            [img_tex{i,j,k}, img_rec{i,j,k}] = c_load_image(img_files{i,j,k}, hwnd);
        end
    end
    
    Screen('FillRect', hwnd, black, rec_center+[-100,-8,-100+200*i/17,8]);
    Screen('FrameRect', hwnd, black, rec_center+[-100,-8,100,8], 1);
    Screen('Flip', hwnd);
end
%cnt





img_pract_files = cell(4, 4);
%img_pract_size = cell(4, 4);
img_pract_tex = cell(4, 4);
img_pract_rec = cell(4, 4);
l = 0;
%cnt = 0;
for i = 1 : 4
    l=l+1;
    for k = 1 : 4
        img_pract_files{i,k} = [media_path 'peabody/img_pract/peabody_pract_' num2str(i) '_' num2str(k) '.jpg'];
        %[img_pract_tmp] = imread(img_pract_files{i,k});
        %if (min(min(min(img_pract_tmp))) == 0)
        %    cnt=cnt+1;
        %    img_pract_tmp(:,:,1) = 255 - (1 - img_pract_tmp(:,:,1)/255) * (255-51);
        %    img_pract_tmp(:,:,2) = 255 - (1 - img_pract_tmp(:,:,2)/255) * (255-71);
        %    img_pract_tmp(:,:,3) = 255 - (1 - img_pract_tmp(:,:,3)/255) * (255-191);
        %end
        %img_pract_tmp(:,:,4) = 255 - 255 .* (img_pract_tmp(:,:,1) == 255) .* (img_pract_tmp(:,:,2) == 255) .* (img_pract_tmp(:,:,3) == 255);
        %%%img_tmp(:,:,4) = (img_tmp(:,:,1) .* img_tmp(:,:,2) .* img_tmp(:,:,3)) / 16581375;
        %cur_size = size(img_pract_tmp);
        %img_pract_size{i,k} = cur_size;
        %img_pract_tex{i,k} = Screen('makeTexture', hwnd, img_pract_tmp);
        %img_pract_rec{i,k} = [0, 0, cur_size(2), cur_size(1)];
        
        [img_pract_tex{i,k}, img_pract_rec{i,k}] = c_load_image(img_pract_files{i,k}, hwnd);
    end
    
    Screen('FillRect', hwnd, black, rec_center+[-100,-8,-100+200*i/4,8]);
    Screen('FrameRect', hwnd, black, rec_center+[-100,-8,100,8], 1);
    Screen('Flip', hwnd);
end
%cnt



%[img_sound, map_sound, alpha_sound] = imread([media_path 'img/sound.png']);
%img_sound(:,:,4) = alpha_sound;
%cur_size = size(img_sound);
%sound_size{i,k} = cur_size;
%sound_tex = Screen('makeTexture', hwnd, img_sound);
%sound_rec = [0, 0, cur_size(2), cur_size(1)];

[sound_tex, sound_rec] = c_load_image([media_path 'peabody/img/sound.png'], hwnd);
[sndgray_tex, sndgray_rec] = c_load_image_grayed([media_path 'peabody/img/sound.png'], hwnd, 0.6);



