% Script to load or re-load audio buffers.

% Check if the sounds are already loaded. If so, we only need to make new
% slave audio handles and refill the buffers. If not, call the function
% c_load_audio_folder to load and resample the audio data.


if exist( 'snd_sent', 'var' ) && exist( 'aud_sent', 'var' )
	% Re-open slave audio handles and fill the buffers.
	
	% Attention grabbers.
	for i = 1 : numel(snd_sent)
		aud_sent{i} = PsychPortAudio('OpenSlave', hAudioMaster); %#ok<SAGROW>
		PsychPortAudio('FillBuffer', aud_sent{i}, snd_sent{i}');
	end
	
	
else
	n_words		= length( words );
	n_carr		= length( carrierSentences );
	aud_sent	= cell( n_words, n_carr );
	snd_sent	= cell( n_words, n_carr );
	fs_sent		= cell( n_words, n_carr );
	nchan_sent	= cell( n_words, n_carr );
	audio_names	= cell( n_words, n_carr );
	
	for i = 1 : n_words
		for j = 1 : n_carr
			audio_names{i,j} = [carrierSentences{j} '_' words{i} '_3secs.wav'];
			[aud_sent{i,j}, snd_sent{i,j}, fs_sent{i,j}, nchan_sent{i,j}] = c_load_audio([media_path 'looklisten/sentences/' audio_names{i,j}]);
		end
	end
end