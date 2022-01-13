function varargout = fPsPhotoTriggerIOPort( varargin )
% FPSPHOTOTRIGGERIOPORT M-file for fPsPhotoTriggerIOPort.fig
%   FPSPHOTOTRIGGERIOPORT, by itself, creates a new FPSPHOTOTRIGGERIOPORT or
%   raises the existing singleton*.
%
%   H = FPSPHOTOTRIGGERIOPORT returns the handle to a new FPSPHOTOTRIGGERIOPORT
%   or the handle to the existing singleton*.
%
%   FPSPHOTOTRIGGERIOPORT( 'CALLBACK', hObject, eventData, handles, ... )
%   calls the local function named CALLBACK in FPSPHOTOTRIGGERIOPORT.M with
%   the given input arguments.
%
%   FPSPHOTOTRIGGERIOPORT( 'Property', 'Value', ... ) creates a new
%   FPSPHOTOTRIGGERIOPORT or raises the existing singleton*.  Starting from
%   the left, property value pairs are applied to the GUI before
%   fPsPhotoTriggerIOPort_OpeningFcn gets called.  An unrecognized property
%   name or invalid value makes property application stop.  All inputs are
%   passed to fPsPhotoTriggerIOPort_OpeningFcn via varargin.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%   instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Edit the above text to modify the response to help fPsPhotoTriggerIOPort
%
% Last Modified by GUIDE v2.5 01-Sep-2014 09:53:17

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

  % Begin initialization code - DO NOT EDIT
  gui_Singleton = 1;
  gui_State = struct( ...
    'gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @fPsPhotoTriggerIOPort_OpeningFcn, ...
    'gui_OutputFcn',  @fPsPhotoTriggerIOPort_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
  if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
  end

  if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
  else
    gui_mainfcn(gui_State, varargin{:});
  end
  % End initialization code - DO NOT EDIT
end

% --- Executes just before fPsPhotoTriggerIOPort is made visible.
function fPsPhotoTriggerIOPort_OpeningFcn( ...
  hObject, ~, handles, varargin )
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fPsPhotoTriggerIOPort (see VARARGIN)

  % Choose default command line output for fPsPhotoTriggerIOPort
  handles.output = hObject;

  handles.timerObject = timer( ...
    'Period', 2.0, ...
    'ExecutionMode', 'fixedSpacing', ...
    'BusyMode', 'drop', ...
    'TimerFcn', {@fPsTimerCallBack, handles} );

  % Update handles structure
  guidata( hObject, handles );

  global gPsIOPortHandle;
  gPsIOPortHandle = [];

  global gPsSendCode;
  gPsSendCode = 0;

  global gPsMissedTransitions;
  gPsMissedTransitions = 0;

  set( handles.errorMessage, 'String', '' );
  fPsResetTimeLag( handles );

  % UIWAIT makes fPsPhotoTriggerIOPort wait for user response (see UIRESUME)
  % uiwait(handles.photoTrigger);
end

% --- Outputs from this function are returned to the command line.
function varargout = fPsPhotoTriggerIOPort_OutputFcn( ...
  ~, ~, handles )
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
  varargout{1} = handles.output;
end

% --- Executes on selection change in portPicker.
function portPicker_Callback( ~, ~, ~ ) %#ok
% hObject    handle to portPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get portPicker contents as cell array
%        contents = cellstr( get( hObject, 'String' ) );
%        get selected item from portPicker
%        contents{ get( hObject, 'Value' ) }
end

% --- Executes during object creation, after setting all properties.
function portPicker_CreateFcn( hObject, ~, ~ ) %#ok
% hObject    handle to portPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
  if ispc && isequal( get( hObject, 'BackgroundColor' ), ...
                      get( 0, 'defaultUicontrolBackgroundColor' ) )
    set( hObject, 'BackgroundColor', 'white' );
  end

  fPsRescanDevDir( hObject );
end

% --- Executes on selection change in baudratePicker.
function baudratePicker_Callback( ~, ~, ~ ) %#ok
% hObject    handle to baudratePicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints:  get baudratePicker contents as cell array
%         contents = cellstr( get( hObject, 'String' ) );
%         get selected item from baudratePicker
%         contents{ get( hObject, 'Value' ) };
end

% --- Executes during object creation, after setting all properties.
function baudratePicker_CreateFcn( hObject, ~, ~ ) %#ok
% hObject    handle to baudratePicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
  if ispc && isequal( get( hObject, 'BackgroundColor' ), ...
                      get( 0, 'defaultUicontrolBackgroundColor' ) )
    set( hObject, 'BackgroundColor', 'white' );
  end
end

function identifierField_Callback( ~, ~, ~ ) %#ok
% hObject    handle to identifierField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of identifierField as text
%        str2double(get(hObject,'String')) returns contents of
%             identifierField as a double
end

% --- Executes during object creation, after setting all properties.
function identifierField_CreateFcn( hObject, ~, ~ ) %#ok
% hObject    handle to identifierField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
  if ispc && isequal( get( hObject,'BackgroundColor' ), ...
                      get( 0,'defaultUicontrolBackgroundColor' ) )
      set( hObject, 'BackgroundColor', 'white' );
  end
end

% --- Executes on button press in rescanBtn.
function rescanBtn_Callback( ~, ~, handles ) %#ok
% hObject    handle to rescanBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  currentPort = fPsGetPickedItem( handles.portPicker );
  fPsRescanDevDir( handles.portPicker );
  portNames = get( handles.portPicker, 'String' );
  index = find( strcmp( portNames, currentPort ), 1 );
  if isempty( index )
    index = 1;
  end
  set( handles.portPicker, 'Value', index );
end

% --- Executes on button press in connectBtn.
function connectBtn_Callback( hObject, ~, handles ) %#ok
% hObject    handle to connectBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  global gPsIOPortHandle;
  fPsResetTimeLag( handles );
  portName = fPsGetPickedItem( handles.portPicker );
  baudrate = fPsGetPickedItem( handles.baudratePicker );
  identifier = get(handles.identifierField, 'String' );
  [handle, error, hasIdentifier] = ...
    fPsOpenIOPort( portName, baudrate, identifier );
  if isempty( error )
    gPsIOPortHandle = handle;
    if hasIdentifier
      set( handles.arduinoPanel, 'Visible', 'on' );
      set( handles.levelsPanel, 'Visible', 'on' );
      set( handles.barGraph, 'Visible', 'on' );
      set( handles.arduinoPanel, 'UserData', 1 );
    else
      set( handles.arduinoPanel, 'Visible', 'off' );
      set( handles.levelsPanel, 'Visible', 'off' );
      set( handles.barGraph, 'Visible', 'off' );
      set( handles.arduinoPanel, 'UserData', 0 );
    end
    set( handles.errorMessage, 'String', '' );
    set( hObject, 'Enable', 'off' );
    set( handles.disconnectBtn, 'Enable', 'on' );
    start( handles.timerObject );
  else
    set( handles.errorMessage, 'String', error );
  end
end

% --- Executes on button press in disconnectBtn.
function disconnectBtn_Callback( hObject, ~, handles )
% hObject    handle to disconnectBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  global gPsIOPortHandle;
  if strcmp( get( handles.timerObject, 'Running'), 'on' )
    stop( handles.timerObject );
  end
  gPsIOPortHandle = fPsCloseIOPort( gPsIOPortHandle );
  set( hObject, 'Enable', 'off' );
  set( handles.connectBtn , 'Enable', 'on' );
  fPsSetTriggerAreas( handles, [0.1 0.1 0.1] );
end

% --- Executes on button press in quitBtn.
function quitBtn_Callback( ~, eventdata, handles ) %#ok
% hObject    handle to quitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  photoTrigger_CloseRequestFcn( handles.photoTrigger, eventdata, handles );
end

% --- Executes when user attempts to close photoTrigger.
function photoTrigger_CloseRequestFcn( hObject, eventdata, handles )
% hObject    handle to photoTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete( hObject ) closes the figure

  disconnectBtn_Callback( handles.disconnectBtn, eventdata, handles );
  delete( handles.timerObject );
  delete( hObject );
end

% --- Executes on button press in resetBtn.
function resetBtn_Callback( ~, ~, handles ) %#ok
% hObject    handle to resetBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  global gPsIOPortHandle;
  IOPort( 'Write', gPsIOPortHandle, 'CCCC' );
  fPsResetTimeLag( handles );
end

% --- Executes on key press with focus on 'photoTrigger'
%     and none of its controls.
% If the background has the focus(click the background):
%  'shift'+'alt'+'command'+'s' = store current bright and dark levels
%  'shift'+'alt'+'command'+'f' = restore factory bright and dark levels
function secretKeyPressFcn( ~, eventdata, ~ ) %#ok
% hObject    handle to photoTrigger (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

  global gPsIOPortHandle;
  theModifiers = {'shift', 'alt', 'command'};
  if length( eventdata.Modifier ) == length( theModifiers )
    allPresent = sum( ismember( theModifiers, eventdata.Modifier ) );
    if allPresent == length( theModifiers )
      if eventdata.Key == 's'
        %fprintf( 'ssss\n' );
        IOPort( 'Write', gPsIOPortHandle, 'SSSS' );
      end
      if eventdata.Key == 'f'
        %fprintf( 'ffff\n' );
        IOPort( 'Write', gPsIOPortHandle, 'FFFF' );
      end
    end
  end
end

% *********************************************************

% --- Reset time lag fields
function fPsSetTriggerAreas( handles, inColor )
% handles    structure with handles and user data (see GUIDATA)
% inColor    ColorSpec

  set( handles.triggerArea1, 'Color', inColor );
  set( handles.triggerArea2, 'Color', inColor );
  set( handles.triggerArea3, 'Color', inColor );
  set( handles.triggerArea4, 'Color', inColor );
end

% --- Set time lag fields
function fPsSetField( hObject, inValue )
% hObject    handle to text field
% inValue    value

  set( hObject, 'Value', inValue );
  set( hObject, 'String', sprintf( '%d', round( inValue ) ) );
end

% --- Set max and min fields
function fPsSetMaxMin( maxObject, minObject, inValue )
% maxObject  handle to max text field
% minObject  handle to min text field
% inValue    new value

  maxValue = max( get( maxObject, 'Value'), inValue );
  fPsSetField( maxObject, maxValue );
  if inValue > 0
    minValue = min( get( minObject, 'Value'), inValue );
    fPsSetField( minObject, minValue );
  end
end

% --- Reset time lag fields
function fPsResetTimeLag( handles )
% handles    structure with handles and user data (see GUIDATA)

  global gPsMissedTransitions;
  fPsSetField( handles.maxMatLab, 0 );
  fPsSetField( handles.minMatLab, 999999 );
  fPsSetField( handles.maxArduino, 0 );
  fPsSetField( handles.minArduino, 999999 );
  set( handles.errorMessage, 'String', '' );
  gPsMissedTransitions = 0;
end

% --- Rescan device directory
function fPsRescanDevDir( hObject )
% hObject    handle to portPicker (see GCBO)
  if ismac
    portDevices = dir( '/dev/cu.*' );
  elseif isunix
    portDevices = dir( '/dev/serial/by-id/usb*' );
  end
  
  deviceList = strcat( {portDevices.folder}, filesep, {portDevices.name} );
  set( hObject, 'String', deviceList );
end

% --- Get picked item
function item = fPsGetPickedItem( hObject )
% hObject    handle to a picker (see GCBO)
% item       string of the picked item

  allItems = cellstr( get( hObject, 'String' ) );
  item = allItems{ get( hObject, 'Value' ) };
end

% --- Executes when the timer expires
function fPsTimerCallBack( hObject, eventdata, handles ) %#ok
% hObject    handle to the timer object
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  global gPsSendCode gPsIOPortHandle gPsMissedTransitions;
  % discard old reply codes
  bytesAvailable = IOPort( 'BytesAvailable', gPsIOPortHandle );
  if bytesAvailable > 0
    IOPort( 'Read', gPsIOPortHandle, 0, bytesAvailable );
  end
  gPsSendCode = bitor( mod( gPsSendCode, 128 ), 128 );
  IOPort( 'Write', gPsIOPortHandle, uint8( gPsSendCode ) );
  tic;
  fPsSetTriggerAreas( handles, 'white' );
  pause( 0.001 ); % effectuate set color
  bytesAvailable = 0;
  elapsed = toc;
  while ((elapsed < 2) && (bytesAvailable == 0))
    bytesAvailable = IOPort( 'BytesAvailable', gPsIOPortHandle );
    elapsed = toc;
  end
  if bytesAvailable > 0
    receivedWhat = IOPort( 'Read', gPsIOPortHandle, 0, bytesAvailable );
    if receivedWhat( length( receivedWhat ) ) ~= gPsSendCode
      set( handles.errorMessage, 'String', ...
        'Error from fPsTimerCallBack: Send/receive mismatch' );
    end
    elapsed = elapsed * 1000;
    fPsSetMaxMin( handles.maxMatLab, handles.minMatLab, elapsed );
    if get( handles.arduinoPanel, 'UserData' )
      IOPort( 'Write', gPsIOPortHandle, 'IIII' );
      receivedWhat = fPsGetsIOPort( gPsIOPortHandle );
      elapsed = str2double( receivedWhat );
      fPsSetMaxMin( handles.maxArduino, handles.minArduino, elapsed );
    end
    gPsSendCode = gPsSendCode + 1;
  else
    gPsMissedTransitions = gPsMissedTransitions + 1;
    set( handles.errorMessage, 'String', ...
        sprintf( 'Missed transitions: %d', gPsMissedTransitions) );
  end
  fPsSetTriggerAreas( handles, 'black' );
  if get( handles.arduinoPanel, 'UserData' )
    IOPort( 'Write', gPsIOPortHandle, 'LLLL' );
    receivedWhat = fPsGetsIOPort( gPsIOPortHandle );
    levels = sscanf( receivedWhat, '%d %d(%d %d)' );
    fPsSetField( handles.brightLevel, levels( 1 ) )
    fPsSetField( handles.darkLevel, levels( 2 ) )
    fPsSetField( handles.brightThreshold, levels( 3 ) )
    fPsSetField( handles.darkThreshold, levels( 4 ) )
    xWhere = [0.3 0.3];
    h = findall( handles.barGraph, 'type', 'line', 'Color', [0 1 0] );
    delete( h );
    h = findall( handles.barGraph, 'type', 'line', 'Color', [1 0 1] );
    delete( h );
    hold( handles.barGraph, 'on' );
    plot( handles.barGraph, xWhere, levels( 1:2 ) / 1000, ...
      'Color', [0 1 0], 'linewidth', 8 );
    plot( handles.barGraph, xWhere, levels( 3:4 ) / 1000, ...
      'Color', [1 0 1], 'linewidth', 6 );
    hold( handles.barGraph, 'off' );
  end
end
