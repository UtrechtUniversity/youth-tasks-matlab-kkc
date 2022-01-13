function write_csv(filename, labels, M)


if (iscell(M))
    write_csv_cell(filename, labels, M);
else
    %header_string = ['''' labels{1} ''''];
    %for i = 2:length(labels)
    %    header_string = [header_string,',','''',labels{i},''''];
    %end
    
    fid = fopen(filename,'w');
    %fprintf(fid,'%s\r\n',header_string);
    write_csv_header(fid, labels);
    
    %fclose(fid);
    
    %dlmwrite(filename, M, '-append', 'delimiter', ',', 'newline', 'pc');
    
    [n, m] = size(M);
    for i = 1 : n
        row_string = ['"', num2str(M(i,1)), '"'];
        for j = 2 : m
            row_string = [row_string, ',', '"', num2str(M(i,j)), '"'];
        end
        fprintf(fid, '%s\r\n', row_string);
    end
    
    fclose(fid);
    
end
