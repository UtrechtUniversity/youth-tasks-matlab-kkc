% Script to load or re-load audio buffers.

% Check if the sounds are already loaded. If so, we only need to make new
% slave audio handles and refill the buffers. If not, call the function
% c_load_audio_folder to load and resample the audio data.


if exist( 'snd_att', 'var' ) && exist( 'aud_att', 'var' ) && ...
		exist( 'snd_cent', 'var' ) && exist( 'aud_cent', 'var' ) && ...
		exist( 'snd_peri', 'var' ) && exist( 'aud_peri', 'var' ) && ...
		exist( 'snd_rew', 'var' ) && exist( 'aud_rew', 'var' )
	% Re-open slave audio handles and fill the buffers.
	
	% Attention grabbers.
	for i = 1 : numel(snd_att)
		aud_att{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_att{i}, snd_att{i}');
	end
	
	
	% Buffer 'cent'.
	for i = 1 : numel(snd_cent)
		aud_cent{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_cent{i}, snd_cent{i}');
	end
	
	
	% Buffer 'peri'.
	for i = 1 : numel(snd_peri)
		aud_peri{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_peri{i}, snd_peri{i}');
	end
	
	
	% Buffer 'rew'.
	for i = 1 : numel(snd_rew)
		aud_rew{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_rew{i}, snd_rew{i}');
	end
	
	
else
	% Attention grabbers.
	[aud_att, snd_att, fs_att, nchan_att] = c_load_audio_folder([media_path 'saccade/attention_grabber']);
	
	
	% Buffer 'cent'.
	aud_cent	= cell(1,2);
	snd_cent	= cell(1,2);
	fs_cent		= zeros(1,2);
	nchan_cent	= zeros(1,2);
	
	for i = 1 : length(aud_cent)
		[aud_cent{i}, snd_cent{i}, fs_cent(i), nchan_cent(i)] = c_load_audio([media_path 'saccade/snd_gap_cs0' num2str(i) '.wav']);
	end
	
	
	% Buffer 'peri'.
	aud_peri	= cell(1,2);
	snd_peri	= cell(1,2);
	fs_peri		= zeros(1,2);
	nchan_peri	= zeros(1,2);
	
	for i = 1 : length(aud_cent)
		[aud_peri{i}, snd_peri{i}, fs_peri(i), nchan_peri(i)] = c_load_audio([media_path 'saccade/snd_gap_ps0' num2str(i) '.wav']);
	end
	
	
	% Buffer 'rew'.
	aud_rew		= cell(1,5);
	snd_rew		= cell(1,5);
	fs_rew		= zeros(1,5);
	nchan_rew	= zeros(1,5);
	
	for i = 1 : length(aud_rew)
		[aud_rew{i}, snd_rew{i}, fs_rew(i), nchan_rew(i)] = c_load_audio([media_path 'saccade/snd_gap_rew0' num2str(i) '.wav']);
	end
end