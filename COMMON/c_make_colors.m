function c_make_colors(hwnd)

white = WhiteIndex(hwnd);
black = BlackIndex(hwnd);

assignin('base', 'white', white );
assignin('base', 'black', black );
assignin('base', 'lightgray', 3*(white+black)/4 );
assignin('base', 'gray', (white+black)/2 );
assignin('base', 'yellow', [255, 255, 0] );
assignin('base', 'orange', [255, 97, 1] );
