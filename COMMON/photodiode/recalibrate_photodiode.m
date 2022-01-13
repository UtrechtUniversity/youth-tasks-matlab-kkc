clear all;
close all;
clc;


% Set-up PTB screen.
PsychDefaultSetup(2);
screens			= Screen('Screens');
screenNumber	= max(screens);

white	= WhiteIndex(screenNumber);
black	= BlackIndex(screenNumber);
grey	= white / 2;

hwnd = PsychImaging('OpenWindow', screenNumber, grey);
fprintf( 1, '\n' );


% Size for diode box.
diodesize = 70;


% Find the available devices.
if ismac
	portDevices = dir( '/dev/cu.*' );
elseif isunix
	portDevices = dir( '/dev/serial/by-id/usb*' );
else
	error( 'The operating system is not supported (yet).' );
end


% Select the first device.
if isempty( portDevices )
	error( 'No devices found.' );
else
	portDevices = portDevices(1);
end


% Open the phototrigger port.
portPath	= fullfile( portDevices.folder, portDevices.name );
baudrate	= '115200';
identifier	= 'PhotoTrigger';
[hTriggerBox, errorMessage] = fPsOpenIOPort( portPath, baudrate, identifier );


% Check for error message.
if errorMessage
	error( errorMessage );
else
	fprintf( 1, 'Port opened: %s\n', portPath );
end


% Draw a black box.
Screen('FillRect', hwnd, black, [0 0 diodesize diodesize]);
timeStamp = Screen('Flip', hwnd);


% Number of flashes.
nrFlashes	= 60;
nrTimeouts	= 0;
maxTimeouts = 3;
timeoutSize = 2;


% Array to store results.
intervalComputer	= NaN( 1, nrFlashes );
intervalArduino		= NaN( 1, nrFlashes );


try
	% Reset device.
	IOPort( 'Write', hTriggerBox, 'CCCC' );
	
	fprintf( 1, 'Running calibration ...\n' );
	
	
	% Let's flash!
	for flashNr = 1 : nrFlashes
		% Send a code above 128. Then the photodiode will wait until it measures a transition between dark and
		% light.
		codeToSend = bitor( mod( flashNr, 128 ), 128 );
		IOPort( 'Write', hTriggerBox, uint8( codeToSend ) );

		
		% Set some things.
		bytesAvailable	= 0;
		t0	= GetSecs;
		t	= 0;


		% Draw a white box.
		Screen('FillRect', hwnd, white, [0 0 diodesize diodesize]);
		startTime = Screen('Flip', hwnd);


		% Wait until a return code is available, or until a timeout.
		while bytesAvailable == 0 && t <= timeoutSize
			bytesAvailable	= IOPort( 'BytesAvailable', hTriggerBox );
			t = GetSecs - t0;
		end


		% Read the return code.
		if bytesAvailable
			returnBytes = IOPort( 'Read', hTriggerBox, 0, bytesAvailable );
		elseif t > 2
			fprintf( 1, 'Timeout.\n' );
			nrTimeouts = nrTimeouts + 1;
		else
			error( 'An unknown error occurred.' );
		end
		
		
		% Draw a black box.
		Screen('FillRect', hwnd, black, [0 0 diodesize diodesize]);
		stopTime = Screen('Flip', hwnd);
		
		
		% Calculate timing interval.
		intervalComputer(flashNr) = stopTime - startTime;
		
		
		% Get the interval from the Arduino. That is: the time from the instruction until the moment that the
		% transition between black and white was detected.
		IOPort( 'Write', hTriggerBox, 'IIII' );
		intervalArduino(flashNr) = str2double( fPsGetsIOPort( hTriggerBox ) );
		
		
		% Get bright and dark levels, and thresholds.
		IOPort( 'Write', hTriggerBox, 'LLLL' );
		levels = fPsGetsIOPort( hTriggerBox );
		
		
		% Wait for a random amount of time.
		pause( rand/3 );
		
		
		% If there are too much timeouts, ask for updating the thresholds in the device.
		if nrTimeouts >= maxTimeouts
			% Save thresholds.
			answer = 'y';
			while ~( strcmp( answer, 'y' ) || strcmp( answer, 'n' ) )
				answer = lower( input( 'Do you want to update the threshold values in the device [y/n]? ', 's' ) );
			end

			switch answer
				case 'y'
					IOPort( 'Write', hTriggerBox, 'SSSS' );
					fprintf( 1, 'Thresholds updated after %d timeouts.\n', nrTimeouts );
					nrTimeouts = 0;
			end
		end
	end
	
	
	% Save thresholds.
	IOPort( 'Write', hTriggerBox, 'SSSS' );
	fprintf( 1, 'Thresholds updated.\n' );
	
	fprintf( 1, 'Calibration complete.\n' );
	
catch
	% Close port if error.
	fPsCloseIOPort( hTriggerBox );
	sca;
end


% Close everything.
fPsCloseIOPort( hTriggerBox );
sca;