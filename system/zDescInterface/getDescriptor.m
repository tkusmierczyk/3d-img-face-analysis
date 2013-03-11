function [spinImgs selIxs] = getDescriptor(pts, filePath, ...
    noOfSeedPoints, distance, ...
    alfaBins, betaBins, alfaAxes, betaAxes)
%Wczytuje deskryptor z pliku. 
%Jeœli plik nie istnieje to deskryptor jest tworzony zgodnie z parametrami.

if exist(filePath, 'file')
    %Za³adowanie z pliku:
    [spinImgs selIxs] = ioRestoreModelDescriptor(filePath);
    
    %Walidacja:
    noOfSeedPoints = min([noOfSeedPoints length(selIxs)]);
    if size(spinImgs, 2) ~= alfaBins* betaBins
        error(['Bad length of descriptors! Is ' num2str(size(spinImgs,2)) ...
            ' and should be ' num2str(alfaBins) 'x' num2str(betaBins)]);
    end;
    
    %Wyciêcie tylu deskryptorów ilu potrzeba:
    spinImgs = spinImgs(1:noOfSeedPoints, :);
    selIxs = selIxs(1:noOfSeedPoints, :);
else
    %Stworzenie nowego:
    [spinImgs selIxs] = createDescriptor(pts, noOfSeedPoints, ...
        distance, alfaBins, betaBins, alfaAxes, betaAxes);    

    %Zapisanie deskryptora do pliku
    %ioStoreModelDescriptor(filePath, spinImgs, selIxs);
end;
