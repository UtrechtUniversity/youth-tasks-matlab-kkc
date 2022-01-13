

img_center = [rsrc_img{1,2,1}(3), rsrc_img{1,2,1}(4)] / 2;

rec_player1 = rec_center + ([   34,  600,   34+400,  600+440 ] - [img_center(1), img_center(2), img_center(1), img_center(2)]) / scale;
rec_player2 = rec_center + ([  965,   70,  965+400,   70+440 ] - [img_center(1), img_center(2), img_center(1), img_center(2)]) / scale;
rec_player3 = rec_center + ([ 1830,  600, 1830+400,  600+440 ] - [img_center(1), img_center(2), img_center(1), img_center(2)]) / scale;

rec_sel1 = rec_player1 + 4 * [-10, -10, 10, 10] / scale;
rec_sel2 = rec_player2 + 4 * [-10, -10, 10, 10] / scale;
rec_sel3 = rec_player3 + 4 * [-10, -10, 10, 10] / scale;

rec_txt1 = [rec_sel1(1), rec_sel1(4), rec_sel1(3), rec_sel1(4)+50];
rec_txt2 = [rec_sel2(1), rec_sel2(4), rec_sel2(3), rec_sel2(4)+50];
rec_txt3 = [rec_sel3(1), rec_sel3(4), rec_sel3(3), rec_sel3(4)+50];


ball_x_from = rec_center(1) + ([[    0,  102,  106,  206 ];
                                [ 1215,    0, 1106,  943 ];
                                [ 2115, 2157,    0, 2115 ];
                                [ 1252,  950, 1016,    0 ]] - img_center(1)) / scale;

ball_y_from = rec_center(2) + ([[    0,  602,  642,  792 ];
                                [ 1189,    0, 1289, 1263 ];
                                [  641,  600,    0,  641 ];
                                [   51,  125,   47,    0 ]] - img_center(2)) / scale;
           
ball_x_to =   rec_center(1) + ([[    0,  950, 1852,  950 ];
                                [  360,    0, 1852,  950 ];
                                [  360, 1265,    0, 1265 ];
                                [  360,  943, 1852,    0 ]] - img_center(1)) / scale;

ball_y_to =   rec_center(2) + ([[    0, 1222,  675,  125 ];
                                [  673,    0,  675,  125 ];
                                [  673, 1225,    0,  126 ];
                                [  673, 1263,  675,    0 ]] - img_center(2)) / scale;
         
         
% 1 2 102 602 950 1222
% 1 3 106 642 1852 675
% 1 4 106 642 950 125
% 2 1 1215 1700 360 673
% 2 3 1006 1189 1852 675
% 2 4 943 1263 950 125
% 3 1 2115 641 360 673
% 3 2 2157 600 1265 1225
% 3 4 2115 641 1265 126
% 4 1 1252 51 360 673
% 4 2 950 125 943 1263
% 4 3 1016 47 1852 675

