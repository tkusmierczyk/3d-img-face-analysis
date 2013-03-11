function [areas] = estimateFilesArea(files, areaNoOfTestPts, areaReferenceDistance)
%Estymacja powierzchni dla listy plików. 

noOfFiles = length(files);
wbar = guiStartWaitBar(0, ['Estimating area of ' num2str(noOfFiles) ...
                                        ' file(s) ...']);
areas = zeros(noOfFiles, 1);
for fileNo = 1: noOfFiles    
    guiSetWaitBar(fileNo / noOfFiles);
    
    %wczytanie wzorca:
    filePts      = ioLoad3dData( files{fileNo} );
    %zestymowanie powierzchni wzorca:
    areas(fileNo) = estimateArea(filePts, areaNoOfTestPts, areaReferenceDistance);      
end;    
guiStopWaitBar(wbar);