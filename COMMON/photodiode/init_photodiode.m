function outHandle = init_photodiode( inPortString )
%
% init_photodiode
%
% USAGE:
%   >> [outObject] = init_photodiode( inPortString )
%   >> [outObject] = init_photodiode( )
%
% Inputs:
%   inPortString - [string] device path
%                  if omitted look for a device with 'usbmodem' or
%                  'KeySerial1' in the name
%
% Outputs:
%   outHandle    - [handle] serial port handle

% Author: Pieter Schiphorst, August 2014.
% Copyright (C) 2014, Experimental Psychology,
% Utrecht University, The Netherlands.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  IOPort( 'CloseAll' ); % if possible remove this

  kPsKeyspan = 'KeySerial1';
  kPsArduino = 'usbmodem';
  kPsArduinoUSB = 'usb-Arduino';

  if ~nargin || isempty( inPortString )
    
    % For macOS and Linux, the devices are named slightly differently.
    if ismac
      theDeviceList = dir( '/dev/cu.*' );
    elseif isunix
      theDeviceList = dir( '/dev/serial/by-id/usb*' );
    else
      theDeviceList = dir( '/dev/cu.*' );
    end
    
    theDeviceNames = {theDeviceList.name};
    
    index = fPsFindDevice( theDeviceNames, kPsKeyspan );
    if isempty( index )
      index = fPsFindDevice( theDeviceNames, kPsArduino );
    end
    if isempty( index )
      index = fPsFindDevice( theDeviceNames, kPsArduinoUSB );
    end
    
    if ~isempty( index )
        thePortString = fullfile( theDeviceList(index(1)).folder, theDeviceList(index(1)).name );
    else
      error( '\n%s\n%s\n', ...
        'No serial device was found.', ...
        'Make sure the serial device is plugged in.' );
    end
  else
    thePortString = inPortString;
  end

  isKeySpan = strfind( thePortString, kPsKeyspan );
  if ~isempty( isKeySpan )
    [outHandle, errmsg] = ...
      fPsOpenIOPort( thePortString, 19200 );
  else
    [outHandle, errmsg] = ...
      fPsOpenIOPort( thePortString, 115200, 'PhotoTrigger' );
  end

  if ~isempty( errmsg )
    error( errmsg );
  end
end

% /*
% **
% */

function outIndex = fPsFindDevice( inDeviceList, inPortString )
%
% fPsFindDevice
%
% USAGE:
%   >> [outIndex] = fPsFindDevice( inDeviceList, inPortString )
%
% Inputs:
%   inDeviceList - [cell] device list
%   inPortString - [string] serial port
%
% Outputs:
%   outIndex     - [double] array of found matches

  theMatches = strfind( inDeviceList, inPortString );
  outIndex = find( ~cellfun( @isempty, theMatches ) );
end
