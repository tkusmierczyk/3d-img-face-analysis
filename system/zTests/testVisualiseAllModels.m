
%Wizualizuje wszystkie modele z katalogu.

dirPath = 'C:\dev\MATLAB\R2008a\work\dat\preTest\out_pre_test_oct\';

f = dir([dirPath '*.txt']);
noOfFiles = length(f);

for fileNo = 1:noOfFiles
    pts = ioLoad3dData([dirPath f(fileNo).name]);
    hold on;
    cla;
    guiDraw3d(pts);
    title(f(fileNo).name);
    pause;
end;    
