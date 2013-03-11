
%Testuje dzialanie fazy wstepnego filtrowania modeli bez selekcji segmentu twarzy.

dirPath = 'dat\preTest\in_pre_test\';
outPath = 'dat\filterTest\out_pre_test\';

f = dir([dirPath '*.txt']);
noOfFiles = length(f);

for fileNo = 1:noOfFiles
    inFile = [dirPath f(fileNo).name];
    outFile = [outPath f(fileNo).name];
    
    pts = ioLoad3dData(inFile);
    tic;
    [fpts ptsClusters removedToSmall clusterSize] = filterData(pts);    
    t = toc;
    ioStore3dRawData(outFile, fpts);
    
    fprintf('%s\n', [inFile ' ' ...
        num2str( size(pts,1) ) ' ' ...
        num2str(removedToSmall) ' ' ...
        num2str( length(clusterSize) ) ' ' ...
        num2str(t)]);
end;    
