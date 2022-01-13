function [outHandle, outErrMsg, outHasIdentifier] = fPsOpenIOPort( ...
    inPortString, inBaudrate, inIdentifier )
%
% fPsOpenIOPort
%
% USAGE:
%   >> [outHandle, outErrMsg, outHasIdentifier] = ...
%        fPsOpenIOPort( inPortString[, inBaudrate=115200][, inIdentifier] )
%
% Inputs:
%   inPortString - [string] serial port
%   inBaudrate   - [number] defaults to 115200
%   inIdentifier - [string] port identifier
%
% Outputs:
%   outHandle        - [handle] serial port handle
%   outErrMsg        - [string] error message
%   outHasIdentifier - [logical] identifier found

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

  kPsBaudRate = 115200;

  outHandle = [];
  outHasIdentifier = false;

  if nargin < 1 || isempty( inPortString ) || ~ischar( inPortString )
    outErrMsg = sprintf( ...
      'Error from fPsOpenIOPort: Invalid serial port string.' );
    return;
  end

  if (nargin < 2) || isempty( inBaudrate )
    inBaudrate = kPsBaudRate;
  else
    if ischar( inBaudrate )
      inBaudrate = str2double( inBaudrate );
    end
    if inBaudrate == 0
      inBaudrate = kPsBaudRate;
    end
  end

  try
    [outHandle outErrMsg] = IOPort( 'OpenSerialPort', inPortString, ...
      sprintf( 'BaudRate=%d', inBaudrate ) );
  catch exception %#ok
    outErrMsg = sprintf( ...
      'Error from fPsOpenIOPort: Could not open %s', inPortString );
    return;
  end;

  % Check if the serial interface sends the identifier string
  %   Note: waiting for an identifier string is a way to check
  %   if the baudrate of the connection is correct

  if nargin >= 3 && ~isempty( inIdentifier ) && ischar( inIdentifier )
    received = fPsGetsIOPort( outHandle );
    %fprintf( ':::(%d)%s', length(received), received );
    if ~isempty( received )
      if isempty( strfind( received, inIdentifier ) )
        outErrMsg = sprintf( ...
          'Error from fPsOpenIOPort: Wrong identifier(%s).', ...
          received( 1:end - 2 ) );
        outHandle = fPsCloseIOPort( outHandle );
      else
        outHasIdentifier = true;
      end
    else
      outErrMsg = sprintf( ...
        'Error from fPsOpenIOPort: Timeout occurred.' );
      outHandle = fPsCloseIOPort( outHandle );
    end
  else
    pause( 1 ); % arduino hangs if you send data to soon
  end
end
