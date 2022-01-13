
coin_count = [ 1,  1,  0,  6,  3,  3;
               2,  2,  0, 12,  6,  6;
               2,  0,  0,  6,  3,  3;
               4,  0,  0, 12,  6,  6];
           
coin_count = repmat(coin_count, 6, 1);


names = cell(1,24);

names{1} = 'Jordy W.';
names{2} = 'Chris B.';
names{3} = 'Arthur E.';
names{4} = 'Michiel B.';
names{5} = 'Frank G.';
names{6} = 'Oliver K.';
names{7} = 'Oscar T.';
names{8} = 'Reinout M.';
names{9} = 'Onno L.';
names{10} = 'Patrick I.';
names{11} = 'Govert H.';
names{12} = 'Gustaaf V.';

names{13} = 'Denise L.';
names{14} = 'Tessa H.';
names{15} = 'Carola G.';
names{16} = 'Mandy B.';
names{17} = 'Lotte U.';
names{18} = 'Madeleine V.';
names{19} = 'Sophie D.';
names{20} = 'Linda H.';
names{21} = 'Annelieke I.';
names{22} = 'Justine K.';
names{23} = 'Elsemieke C.';
names{24} = 'Iris D.';


params = [0, 1, 1000;
1, 2, 1000;
1, 3, 1000;
1, 1, 1000;
1, 1, 1000;
1, 3, 1000;
0, 4, 1000;
1, 3, 1000;
1, 4, 1000;
1, 1, 1000;
1, 1, 1000;
0, 2, 1000;
0, 1, 1000;
1, 3, 1000;
1, 3, 1000;
1, 3, 1000;
1, 4, 1000;
1, 2, 1000;
0, 4, 1000;
1, 3, 1000;
1, 2, 1000;
1, 1, 1000;
0, 2, 1000;
1, 3, 1000];


