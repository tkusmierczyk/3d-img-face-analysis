function [areas] = estimateAndSaveFilesArea(storageFile, ...
        files, areaNoOfTestPts, areaReferenceDistance)
%Estymacja powierzchni dla listy plików. Jeœli istnieje to jest wczytywana
%z pliku. Jeœli nie to jest tworzona i zapisywana w pliku.

if exist(storageFile, 'file')
    areas = ioReadVector(storageFile);
else    
    areas = estimateFilesArea(files, areaNoOfTestPts, areaReferenceDistance);   
    ioStoreVector(storageFile, areas);
end;

