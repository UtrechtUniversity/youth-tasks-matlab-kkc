% Script to load or re-load audio buffers.

% Check if the sounds are already loaded. If so, we only need to make new
% slave audio handles and refill the buffers. If not, call the function
% c_load_audio_folder to load and resample the audio data.


if exist( 'snd_att', 'var' ) && exist( 'aud_att', 'var' ) && ...
		exist( 'snd_rew', 'var' ) && exist( 'aud_rew', 'var' )
	% Re-open slave audio handles and fill the buffers.
	
	
	% Attention grabbers.
	for i = 1 : numel(snd_att)
		aud_att{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_att{i}, snd_att{i}');
	end
	
	
	% Buffer 'rew'.
	for i = 1 : numel(snd_rew)
		aud_rew{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_rew{i}, snd_rew{i}');
	end
	
	
else
	% Attention grabbers.
	[aud_att, snd_att, fs_att, nchan_att] = c_load_audio_folder([media_path 'socialgaze/audio']);
	
	% Buffer 'rew'.
	[aud_rew, snd_rew, fs_rew, nchan_rew] = c_load_audio_folder([media_path 'socialgaze/audio']);
end