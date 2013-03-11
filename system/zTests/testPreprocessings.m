
%Testuje dzialanie fazy wstepnego filtrowania modeli.

dirPath = 'C:\dev\MATLAB\R2008a\work\dat\preTest\in_pre_profile\';
outPath = 'C:\dev\MATLAB\R2008a\work\dat\preTest\out_pre_profile_oct\';

f = dir([dirPath '*.txt']);
noOfFiles = length(f);

for fileNo = 1:noOfFiles
    fprintf('%s', testPreprocessing([dirPath f(fileNo).name], ...
        [outPath f(fileNo).name]));
    fprintf('\n')
end;    
