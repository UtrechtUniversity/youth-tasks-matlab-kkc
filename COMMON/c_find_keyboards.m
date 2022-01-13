function [normalKB, barcodeKB] = c_find_keyboards()

% Depending on the operating system, determine the device indices of the keyboard and the barcode
% scanner.
% On a Mac, you can ask for all PsychHID info, and then select the one with vendor number 1504 as
% the barcode scanner.
if ismac
	devs = PsychHID('devices');

	normalKB = -1;
	barcodeKB = -1;
	nFeatures = 0;
	for i = 1 : length(devs)
		if (devs(i).usageValue == 6)
			if (devs(i).vendorID == 1504)
				if (barcodeKB == -1)
					barcodeKB = devs(i).index;
				end
			else
				if ((normalKB == -1) || (nFeatures == 0))
					normalKB = devs(i).index;
					nFeatures = devs(i).features;
				end
			end
			if ((normalKB > -1) && (barcodeKB > -1))
				break;
			end
		end
	end
	
	
% On Linux, at least on Ubuntu 16.04, the 'devs' structure returned by PsychHID is incomplete:
% apparently, this works differently here. You can use the second argument, and ask explicitly for
% the master keyboard and slave keyboard devices. We then select the barcode scanner based on
% product name, as the vendorID is now not available, strangely enough.
elseif isunix
	% Ask for master keyboard devices (second argument '2').
	devMasterKeyboard = PsychHID( 'devices', 2 );
	
	% Get the index number.
	normalKB = [];%devMasterKeyboard(1).index;
	
	% Ask for slave keyboards ('4').
	devSlaveKeyboard = PsychHID( 'devices', 4 );
	
	% Get the right one, with "Bar Code" in its name.
	barcodeScannerIndices = ~cellfun( @isempty, regexp({devSlaveKeyboard.product}, 'Bar Code', 'match', 'once') );
	
	% Check if there is only one.
	if nnz( barcodeScannerIndices ) == 1
		barcodeKB = devSlaveKeyboard( barcodeScannerIndices ).index;
	elseif nnz( barcodeScannerIndices ) > 1
		barcodeKB = devSlaveKeyboard( barcodeScannerIndices(1) ).index;
		warning('More than one bar code scanner found!' );
	else
		barcodeKB = -1;
	end
end