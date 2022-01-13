function [buttonKB] = c_find_redbutton()

buttonKB = -1;

if ismac
	devs = PsychHID('devices');
	
	for i = 1 : length(devs)
		if (devs(i).usageValue == 2)
			if (devs(i).vendorID == 8262)
				buttonKB = devs(i).index;
			end
		end
	end
elseif isunix
	% On Linux systems, you should ask explicitly for slave keyboard
	% devices ('4'). The vendorID is not used, so we search for the product name
	% 'SWITCH CLICK'.
	devs = PsychHID('devices', 4); % 4 means: keyboard slave devices
	
	% Look for the row with the button.
	rowNr = find( contains( {devs.product}, 'SWITCH CLICK') );
	
	% Pick the first one (because maybe there are more.
	if numel(rowNr) > 1
		warning('More than one red button connected.');
		rowNr = rowNr(1);
	end
	
	% Get the device index.
	if ~isempty(rowNr)
		buttonKB = devs(rowNr).index;
	end
else
	fprintf(1, '\nThis operating system is not supported! Ask the lab technician.\n' );
end