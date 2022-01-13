
%scale   = scrH / 480;
ofx     = (scrW - scale * 640) / 2;
ofy     = 2 * (scrH - scale * 480) / 3;
rec_ofs = [ofx, ofy, ofx, ofy];
rec_def = [  0,   0,  86,  30];
rec_p1  = rec_ofs + scale * ([ 13, 191,  13, 191] + rec_def);
rec_n1a = rec_ofs + scale * ([249,  21, 249,  21] + rec_def);
rec_n1b = rec_ofs + scale * ([249,  98, 249,  98] + rec_def);
rec_p2  = rec_ofs + scale * ([229, 308, 229, 308] + rec_def);
rec_t1a = rec_ofs + scale * ([406, 162, 406, 162] + rec_def);
rec_t1b = rec_ofs + scale * ([406, 240, 406, 240] + rec_def);
rec_t2a = rec_ofs + scale * ([406, 355, 406, 355] + rec_def);
rec_t2b = rec_ofs + scale * ([406, 435, 406, 435] + rec_def);

rec_nt = [rec_n1a(1)-18, rec_n1a(2)-16, rec_n1b(3)+scale*100+32, rec_n1b(4)+16];
rec_t1 = [rec_t1a(1)-18, rec_t1a(2)-16, rec_t1b(3)+scale*100+32, rec_t1b(4)+16];
rec_t2 = [rec_t2a(1)-18, rec_t2a(2)-16, rec_t2b(3)+scale*100+32, rec_t2b(4)+16];


line_p1_n1 = [rec_p1(3), (rec_p1(2)+rec_p1(4))/2, rec_n1a(1)-16, (rec_n1a(2)+rec_n1b(4))/2];
line_n1 = [rec_n1a(1)-16, (rec_n1a(2)+rec_n1a(4))/2, rec_n1a(1)-16, (rec_n1b(2)+rec_n1b(4))/2];
line_n1_n1a = [line_n1(1), line_n1(2), rec_n1a(1), line_n1(2)];
line_n1_n1b = [line_n1(3), line_n1(4), rec_n1b(1), line_n1(4)];

line_p1_p2 = [rec_p1(3), (rec_p1(2)+rec_p1(4))/2, rec_p2(1), (rec_p2(2)+rec_p2(4))/2];

line_p2_t1 = [rec_p2(3), (rec_p2(2)+rec_p2(4))/2, rec_t1a(1)-16, (rec_t1a(2)+rec_t1b(4))/2];
line_t1 = [rec_t1a(1)-16, (rec_t1a(2)+rec_t1a(4))/2, rec_t1a(1)-16, (rec_t1b(2)+rec_t1b(4))/2];
line_t1_t1a = [line_t1(1), line_t1(2), rec_t1a(1), line_t1(2)];
line_t1_t1b = [line_t1(3), line_t1(4), rec_t1b(1), line_t1(4)];

line_p2_t2 = [rec_p2(3), (rec_p2(2)+rec_p2(4))/2, rec_t2a(1)-16, (rec_t2a(2)+rec_t2b(4))/2];
line_t2 = [rec_t2a(1)-16, (rec_t2a(2)+rec_t2a(4))/2, rec_t2a(1)-16, (rec_t2b(2)+rec_t2b(4))/2];
line_t2_t2a = [line_t2(1), line_t2(2), rec_t2a(1), line_t2(2)];
line_t2_t2b = [line_t2(3), line_t2(4), rec_t2b(1), line_t2(4)];

%coin_dist = 24;
coin_size = 20;
coin_pos_ofsx = 16;
coin_pos_ofsy = 16;
coin_pos_n1a = [rec_n1a(3)+coin_pos_ofsx, (rec_n1a(2)+rec_n1a(4))/2-coin_size];
coin_pos_n1b = [rec_n1b(3)+coin_pos_ofsx, (rec_n1b(2)+rec_n1b(4))/2-coin_size];
coin_pos_t1a = [rec_t1a(3)+coin_pos_ofsx, (rec_t1a(2)+rec_t1a(4))/2-coin_size];
coin_pos_t1b = [rec_t1b(3)+coin_pos_ofsx, (rec_t1b(2)+rec_t1b(4))/2-coin_size];
coin_pos_t2a = [rec_t2a(3)+coin_pos_ofsx, (rec_t2a(2)+rec_t2a(4))/2-coin_size];
coin_pos_t2b = [rec_t2b(3)+coin_pos_ofsx, (rec_t2b(2)+rec_t2b(4))/2-coin_size];

coin_pos_p1 = [rec_p1(1)+coin_pos_ofsx, rec_p1(4)+coin_pos_ofsy];
coin_pos_p2 = [rec_p2(1)+coin_pos_ofsx, rec_p2(4)+coin_pos_ofsy];


rec_ch_p1_0 = [(line_p1_n1(1)+line_p1_n1(3))/2, (line_p1_n1(2)+line_p1_n1(4))/2, (line_p1_n1(1)+line_p1_n1(3))/2+32, (line_p1_n1(2)+line_p1_n1(4))/2+32];
rec_ch_p1_1 = [(line_p1_p2(1)+line_p1_p2(3))/2, (line_p1_p2(2)+line_p1_p2(4))/2-32, (line_p1_p2(1)+line_p1_p2(3))/2+32, (line_p1_p2(2)+line_p1_p2(4))/2];

rec_ch_p2_0 = [(line_p2_t1(1)+line_p2_t1(3))/2, (line_p2_t1(2)+line_p2_t1(4))/2, (line_p2_t1(1)+line_p2_t1(3))/2+32, (line_p2_t1(2)+line_p2_t1(4))/2+32];
rec_ch_p2_1 = [(line_p2_t2(1)+line_p2_t2(3))/2, (line_p2_t2(2)+line_p2_t2(4))/2-32, (line_p2_t2(1)+line_p2_t2(3))/2+32, (line_p2_t2(2)+line_p2_t2(4))/2];



rec_choice1 = rec_center + scale * 0.5 * [-140, 0, 0, 148] - [16, 0, 16, 0];
rec_choice2 = rec_center + scale * 0.5 * [0, 0, 140, 148] + [16, 0, 16, 0];
rec_choice_brd = [rec_choice1(1)-8, rec_choice1(2)-32, rec_choice2(3)+8, rec_choice2(4)+32];
rec_choice_p1t = [rec_choice1(1), rec_choice1(2)-32, rec_choice1(3), rec_choice1(2)];
rec_choice_p2t = [rec_choice2(1), rec_choice2(2)-32, rec_choice2(3), rec_choice2(2)];
rec_choice_p1b = [rec_choice1(1), rec_choice1(4)-8, rec_choice1(3), rec_choice1(4)+32];
rec_choice_p2b = [rec_choice2(1), rec_choice2(4)-8, rec_choice2(3), rec_choice2(4)+32];



