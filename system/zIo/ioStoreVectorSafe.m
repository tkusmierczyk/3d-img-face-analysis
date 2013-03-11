function ioStoreVectorSafe(filePath, v)
% Writes vector to the file.

try
    save(filePath, 'v', '-ascii', '-tabs');
catch e
end;    
