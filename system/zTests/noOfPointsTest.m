
%Liczby histogram liczby punktow plikow w katalogu

dirPath = 'in_gavab2\';

f = dir([dirPath '*.txt']);
noOfFiles = length(f);
noOfPts = zeros(noOfFiles, 1);

for fileNo = 1:noOfFiles
    pts = ioLoad3dData( [dirPath f(fileNo).name] );
    noOfPts(fileNo) = size(pts, 1);
end;    

