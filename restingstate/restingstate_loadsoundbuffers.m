% Script to load or re-load audio buffers.

% Check if the sounds are already loaded. If so, we only need to make new
% slave audio handles and refill the buffers. If not, call the function
% c_load_audio_folder to load and resample the audio data.


if exist( 'snd_att', 'var' ) && exist( 'aud_att', 'var' )
	% Re-open slave audio handles and fill the buffers.
	
	% Attention grabbers.
	for i = 1 : numel(snd_att)
		aud_att{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_att{i}, snd_att{i}');
	end
	
	
else
	% Attention grabbers.
	[aud_att, snd_att, fs_att, nchan_att] = c_load_audio_folder([media_path 'restingstate/audio']);
end