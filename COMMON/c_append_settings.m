function c_append_settings(logpath, logtag, name, value)

fid = fopen([logpath logtag '_settings.txt'], 'a');

row_string = ['"', name, '",'];
if (ischar(value))
    row_string = [row_string, '"', value, '"'];
else
    row_string = [row_string, '"', num2str(value), '"'];
end

fprintf(fid, '%s\r\n', row_string);

fclose(fid);

