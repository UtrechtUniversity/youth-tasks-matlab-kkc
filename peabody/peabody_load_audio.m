

disp('Loading audio...');


lstFiles = dir([media_path 'peabody/audio_main/*.wav']);
audio_main = cell(2,204);
fs_main = zeros(2,204);

for i = 1 : length(lstFiles)
    [y,Fs] = audioread([media_path 'peabody/audio_main/' lstFiles(i).name]);
    tmp = lstFiles(i).name;
    ind = str2num(tmp(1:3));
    if (tmp(5) == 'a')
        ind2 = 1;
    else
        ind2 = 2;
    end
    audio_main{ind2,ind} = y;
    fs_main(ind2,ind) = Fs;
end

%--------------------------------------------------------------------------

audio_pract = cell(4,2,4);
fs_pract = zeros(4,2,4);

lstFiles = cell(4,2,4);
lstFiles{1,1,1} = 'exa_a_lepel.wav';
lstFiles{1,1,2} = 'exa_a_bal.wav';
lstFiles{1,1,3} = 'exa_a_banaan.wav';
lstFiles{1,1,4} = 'exa_a_hond.wav';
lstFiles{1,2,1} = 'exa_b_lepel.wav';
lstFiles{1,2,2} = 'exa_b_bal.wav';
lstFiles{1,2,3} = 'exa_b_banaan.wav';
lstFiles{1,2,4} = 'exa_b_hond.wav';

lstFiles{2,1,1} = 'exb_a_slapen.wav';
lstFiles{2,1,2} = 'exb_a_eten.wav';
lstFiles{2,1,3} = 'exb_a_kruipen.wav';
lstFiles{2,1,4} = 'exb_a_huilen.wav';
lstFiles{2,2,1} = 'exb_b_slapen.wav';
lstFiles{2,2,2} = 'exb_b_eten.wav';
lstFiles{2,2,3} = 'exb_b_kruipen.wav';
lstFiles{2,2,4} = 'exb_b_huilen.wav';

lstFiles{3,1,1} = 'exc_a_vlieger.wav';
lstFiles{3,1,2} = 'exc_a_bank.wav';
lstFiles{3,1,3} = 'exc_a_kip.wav';
lstFiles{3,1,4} = 'exc_a_jurk.wav';
lstFiles{3,2,1} = 'exc_b_vlieger.wav';
lstFiles{3,2,2} = 'exc_b_bank.wav';
lstFiles{3,2,3} = 'exc_b_kip.wav';
lstFiles{3,2,4} = 'exc_b_jurk.wav';

lstFiles{4,1,1} = 'exd_a_schoonmaken.wav';
lstFiles{4,1,2} = 'exd_a_fietsen.wav';
lstFiles{4,1,3} = 'exd_a_grasmaaien.wav';
lstFiles{4,1,4} = 'exd_a_verven.wav';
lstFiles{4,2,1} = 'exd_b_schoonmaken.wav';
lstFiles{4,2,2} = 'exd_b_fietsen.wav';
lstFiles{4,2,3} = 'exd_b_grasmaaien.wav';
lstFiles{4,2,4} = 'exd_b_verven.wav';

for i = 1 : 4
    for j = 1 : 2
        for k = 1 : 4
            [y,Fs] = audioread([media_path 'peabody/audio_pract/' lstFiles{i,j,k}]);
            audio_pract{i,j,k} = y;
            fs_pract(i,j,k) = Fs;
        end
    end
end

