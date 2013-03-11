function [spinImgs selIxs] = getDescriptorFile(fileDesc, ...
    filePts, noOfSeedPoints, distance, ...
    alfaBins, betaBins, alfaAxes, betaAxes)
%Wczytuje deskryptor z pliku. 
%Jeœli plik nie istnieje to deskryptor jest tworzony zgodnie z parametrami 
%po wczytaniu z pliku z danymi.
%Parametry:
% fileDesc - plik zawieraj¹cy deskryptor
% filePts - plik zawieraj¹cy model

if exist(fileDesc, 'file')
    pts = [];
    
    [spinImgs selIxs] = getDescriptor(pts, fileDesc, ...
        noOfSeedPoints, distance, ...
        alfaBins, betaBins, alfaAxes, betaAxes);
else
    pts = ioLoad3dData(filePts);
    
    [spinImgs selIxs] = getDescriptor(pts, fileDesc, ...
        noOfSeedPoints, distance, ...
        alfaBins, betaBins, alfaAxes, betaAxes);
    
    ioStoreModelDescriptor(fileDesc, spinImgs, selIxs);
end;

