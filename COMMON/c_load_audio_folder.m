function [aud, snd, fs, nchan] = c_load_audio_folder(audiopath)

lstAud = dir([audiopath '/*.wav']);
n_aud = length(lstAud);
aud = cell(1,n_aud);
snd = cell(1,n_aud);
fs = zeros(1,n_aud);
nchan = zeros(1,n_aud);
for i = 1 : n_aud
    [aud{i}, snd{i}, fs(i), nchan(i)] = c_load_audio([audiopath '/' lstAud(i).name]);
end


