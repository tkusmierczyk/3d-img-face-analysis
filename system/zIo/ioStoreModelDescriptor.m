function ioStoreModelDescriptor(filePath, spinImage, selIxs)
% Saves to file spin images table.

data = [selIxs spinImage];
save(filePath, 'data', '-ascii');