function [aud, snd, fs, nchan] = c_load_audio(audiofile)
	
	% Get the master audio handle and its status.
	global hAudioMaster
	audioStatus = PsychPortAudio( 'GetStatus', hAudioMaster );
	

	[snd, fs]	= audioread(audiofile);
	nchan		= size(snd, 2);


	% Make sound in stereo, as the master audio handle always has two channels.
	if nchan ~= 2
		snd		= [ snd(:,1), snd(:,1) ];
		nchan	= size(snd, 2);
	end


	% Resample the sound to match the master audio handle. This is needed 
	% on our Linux task computers; with a 'random' sample frequency, you
	% get an error.
	% First, determine integers p and q to find the resampling factor.
	fTarget		= audioStatus.SampleRate;
	tolerance	= 1e-6;
	[p, q]		= rat( fTarget / fs, tolerance );


	% Resample audio signal using the integers p and q.
	snd = resample( snd, p, q );
	fs	= fTarget;


	% Open audio ports as slave.
	aud = PsychPortAudio('OpenSlave', hAudioMaster);
	PsychPortAudio('FillBuffer', aud, snd');