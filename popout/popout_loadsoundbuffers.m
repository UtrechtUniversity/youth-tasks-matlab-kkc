% Script to load or re-load audio buffers.

% Check if the sounds are already loaded. If so, we only need to make new
% slave audio handles and refill the buffers. If not, call the function
% c_load_audio_folder to load and resample the audio data.


if exist( 'snd_att', 'var' ) && exist( 'aud_att', 'var' ) && ...
		exist( 'snd_trial', 'var' ) && exist( 'aud_trial', 'var' )
	% Re-open slave audio handles and fill the buffers.
	
	
	% Attention grabbers.
	for i = 1 : numel(snd_att)
		aud_att{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_att{i}, snd_att{i}');
	end
	
	
	% Buffer 'trial'.
	for i = 1 : numel(snd_trial)
		aud_trial{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_trial{i}, snd_trial{i}');
	end
	
	
else
	% Attention grabbers.
	[aud_att, snd_att, fs_att, nchan_att] = c_load_audio_folder([media_path 'popout/attention_grabber']);
	
	
	% Buffer 'trial'.
	aud_trial	= cell(1,8);
	snd_trial	= cell(1,8);
	fs_trial	= zeros(1,8);
	nchan_trial = zeros(1,8);
	
	for i = 1 : 8
		[aud_trial{i}, snd_trial{i}, fs_trial(i), nchan_trial(i)] = c_load_audio([media_path 'popout/SI_SONG' num2str(i+1) '.wav']);
	end
end