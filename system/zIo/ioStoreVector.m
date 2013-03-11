function ioStoreVector(filePath, v)
% Writes vector to the file.

save(filePath, 'v', '-ascii', '-tabs');
