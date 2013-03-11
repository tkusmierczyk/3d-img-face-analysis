function ioStore3dData(filePath, pts, n, u, v)
% Writes file with 3d points.

data = [pts n u v];
save(filePath, 'data', '-ascii', '-tabs');
