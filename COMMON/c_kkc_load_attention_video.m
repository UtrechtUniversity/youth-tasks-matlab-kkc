function [att_vids] = c_kkc_load_attention_video()

global common_media_path;

att_vids = cell(1, 8);
att_vids{1} = [common_media_path '/babytv1.mp4'];
att_vids{2} = [common_media_path '/babytv2.mp4'];
att_vids{3} = [common_media_path '/babytv3.mp4'];
att_vids{4} = [common_media_path '/bumba2.mp4'];
att_vids{5} = [common_media_path '/bumba3.mp4'];
att_vids{6} = [common_media_path '/bumba4.mp4'];
att_vids{7} = [common_media_path '/bumba5.mp4'];
att_vids{8} = [common_media_path '/bumba6.mp4'];

assignin('base', 'att_last_vid', 0);

