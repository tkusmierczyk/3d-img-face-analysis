function takeSnapshotForMarkingDir(dirPath)
%Dla wszystkich danych w katalogu generuje zrzut ekranu 
% w widoku przystosowanym do oznaczania regionów (maskData).

f = dir([dirPath '*.txt']);
noOfFiles = length(f);

for fileNo = 1:noOfFiles
    pts = ioLoad3dData([dirPath f(fileNo).name]);
	takeSnapshotForMarking(pts, [dirPath f(fileNo).name '.png']);
end;    
