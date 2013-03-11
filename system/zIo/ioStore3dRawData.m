function ioStore3dRawData(filePath, pts)
% Writes file with 3d points.

save(filePath, 'pts', '-ascii', '-tabs');
