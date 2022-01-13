function write_csv_cell(filename, labels, M)

%header_string = ['''' labels{1} ''''];
%for i = 2:length(labels)
%    header_string = [header_string,',','''',labels{i},''''];
%end

fid = fopen(filename,'w');
%fprintf(fid,'%s\r\n',header_string);
write_csv_header(fid, labels)

[n, m] = size(M);
for i = 1 : n
    if (ischar(M{i,1}))
        row_string = ['"', M{i,1} , '"'];
    else
        row_string = ['"', num2str(M{i,1}), '"'];
    end
    for j = 2 : m
        if (ischar(M{i,j}))
            row_string = [row_string, ',', '"', M{i,j}, '"'];
        else
            row_string = [row_string, ',', '"', num2str(M{i,j}), '"'];
        end
    end
    fprintf(fid, '%s\r\n', row_string);
end

fclose(fid);

