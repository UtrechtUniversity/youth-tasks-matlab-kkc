function send_code( t_box_handle, code )
%
% send_code - Prevent too rapid writes
%
% USAGE:
%   >> send_code( t_box_handle, code )
%
% Inputs:
%   t_box_handle - [handle] serial port handle
%   code         - [integer] code
%
% Outputs:
%   none

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

  kPsMinDelay = 0.05;

  persistent gPsLastTime
  if isempty( gPsLastTime )
    gPsLastTime = 0;
  end

  for index = 1 : length( code )
    % wait min delay between two consecutive writes
    now = GetSecs;
    while (now - gPsLastTime) < kPsMinDelay
      now = GetSecs;
    end
    gPsLastTime = now;

    [nwritten, when, errmsg] = ...
      IOPort( 'Write', t_box_handle, uint8( code( index ) ) );

  end
end
