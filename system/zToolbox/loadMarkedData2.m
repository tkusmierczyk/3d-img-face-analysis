function [pts markers fpts] = loadMarkedData2(dataPath, maskPath)
%£aduje plik oraz maskê. Nastêpnie wykorzystuje maskê do wyboru czêœci
%punktów z danych. 

pts     = ioLoad3dData(dataPath);
mask    = imread(maskPath);

markers = markData(pts, mask, 0, 0, 0); 
fpts	= pts(markers, :);