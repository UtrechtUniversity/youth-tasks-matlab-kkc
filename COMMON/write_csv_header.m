function write_csv_header(fileID, labels)

header_string = ['"' labels{1} '"'];
for i = 2:length(labels)
    header_string = [header_string,',','"',labels{i},'"'];
end

fprintf(fileID, '%s\r\n', header_string);

