
%Testuje preprocessing dla zupelnie losowych modeli.

for i = 1:100
    try
        pts = [generateRandomModel(i * 1000,200); generateRandomModel(i * 1000,200)+i*300];
        [facePts faceCost faceMatchingCosts optimalMaxDistanceCoeff ...
        removedToSmall neigborhoodRadius] = ...
            modelPreprocessing(pts);
 
        fprintf('%i %.4f %i %i', i, faceCost, removedToSmall, size(facePts,1) );
        fprintf('\n');
    catch exception
    end;
end;    


