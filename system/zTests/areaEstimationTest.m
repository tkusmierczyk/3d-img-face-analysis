
%Testuje estymacje powierzchni modelu.

dirPath = 'out_pre_test\';

%--------------------------------------------------------------------------
f = dir([dirPath '*.txt']);
noOfFiles = length(f);

for fileNo = 1:noOfFiles
    pts = ioLoad3dData([dirPath f(fileNo).name]);
    [estimatedArea ptsDensity] = estimateArea(pts, 100, 1.5);

    fprintf('%s %.4f %.4f', f(fileNo).name, estimatedArea, ptsDensity);
    fprintf('\n');
end;    
