function [facePts faceCost faceMatchingCosts optimalMaxDistanceCoeff ...
    removedToSmall neigborhoodRadius] = ...
    modelPreprocessing(pts, options)
%Przeprowadza wstêpne przetwarzanie danych. 
%Parametry:
% pts - zbiór punktów. Macierz wierszy [x y z].
%Zwracane:
% facePts - punkty segmentu zawieraj¹cego twarz (dopasowanie do wzorca).
% faceCost - koszt dopasowania do wzorca.
% faceMatchingCosts - koszty dopasowania poszczególnych semgentów do
% wzorca.
% optimalMaxDistanceCoeff - jaki wspó³czynnik segmentacji (przez po³¹czenie
% wybrano) np. 1.0 lub 0.5
% removedToSmall - ile punktów zosta³o usuniêtych w fazie przed dopasowywaniem.
% neigborhoodRadius - ustalony promieñ s¹siedztwa dla obliczenia kierunków
% normalnych do powierzchni.

%--------------------------------------------------------------------------
%configuration:

% force creation of options:
options.null = 0; 

%filtrowanie wstêpne poprzez odrzucenie zbyt ma³ych plików:
minFractionOfPtsInCluster = getOption(options, 'minFractionOfPtsInCluster', 0.1);

%wzorzec twarzy:
patternFile = getOption(options, 'patternFile', ...
    'patterns\faceClusterDb\cara7_frontal1_filtered_raw.txt');
patternDescFile = getOption(options, 'patternDescFile', ...
    'patterns\faceClusterDb\cara7_frontal1_filtered_desc.txt');
noOfSeedPoints = getOption(options, 'noOfSeedPoints', 100);

%deskryptory:
spinDistance = getOption(options, 'spinDistance', 100);
alfaBins = getOption(options, 'alfaBins', 10);
betaBins = getOption(options, 'betaBins', 10);
alfaAxes = getOption(options, 'alfaAxes', 'log');
betaAxes = getOption(options, 'betaAxes', 'log');

%dopasowywanie:
matchingRule = getOption(options, 'matchingRule', 'OR');
matchingDistanceType = getOption(options, 'matchingDistanceType', 1);

%wartosci promienia bezposredniego sasiedztwa do przetestowania:
maxDistanceCoeffSet = [0.5 1.0];

%pts = ioLoad3dData(rawFile);  
%--------------------------------------------------------------------------

%model wzorcowy:
%[facePatternSpinImgs] = ioRestoreModelDescriptor(patternDescFile);
facePatternSpinImgs  = getDescriptorFile(patternDescFile, patternFile, ...
    noOfSeedPoints, spinDistance, alfaBins, betaBins, alfaAxes, betaAxes);

%estymata optymalnego promienia sasiedztwa dla liczenia kierunku normalnych
[neigborhoodRadius] = estimatePCANeighborhoodRadius(pts);

%output buffer:
faceMatchingCostsSet = cell(length(maxDistanceCoeffSet), 1);
faceCostsSet         = zeros(length(maxDistanceCoeffSet), 1);
removedToSmallSet    = zeros(length(maxDistanceCoeffSet), 1);
faceClusterPtsSet    = cell(length(maxDistanceCoeffSet), 1);

%dla roznych wartosci promienia sasiedztwa bezposredniego:
for i = 1: length(maxDistanceCoeffSet)
    maxDistanceCoeff = maxDistanceCoeffSet(i);
        
    [faceClusterNo faceCostsSet(i) faceClusterPtsSet{i} ...
        faceMatchingCostsSet{i} removedToSmallSet(i)] ...
        = preprocess(pts, maxDistanceCoeff,  ...
        minFractionOfPtsInCluster, facePatternSpinImgs, noOfSeedPoints, ...
        neigborhoodRadius, spinDistance, alfaBins, betaBins, alfaAxes, ...
        betaAxes, matchingRule, matchingDistanceType);
end;

%wybranie najlepszego z rozwiazan:
[faceCost minIx] = min(faceCostsSet);

optimalMaxDistanceCoeff = maxDistanceCoeffSet(minIx);
facePts = faceClusterPtsSet{minIx};
faceMatchingCosts = faceMatchingCostsSet{minIx};
removedToSmall = removedToSmallSet(minIx);


%--------------------------------------------------------------------------
function [faceClusterNo faceCost faceClusterPts faceMatchingCosts ...
    removedToSmall] = ...
preprocess(pts,  maxDistanceCoeff, minFractionOfPtsInCluster, ...
facePatternSpinImgs, noOfSeedPoints, neigborhoodRadius, ...
spinDistance, alfaBins, betaBins, alfaAxes, betaAxes, ...   
matchingRule, matchingDistanceType)

    %Wstêpne przetwarzanie danych:
    [pts ptsClusters removedToSmall] = filterData(pts, ...
        struct('connectivityCoeff', maxDistanceCoeff, ...
        'clusterFrac', minFractionOfPtsInCluster) );

    %face cluster searching:
    [faceClusterNo faceMatchingCosts noOfClusters clusterPts ] ...
        = findPatternCluster(pts, ptsClusters, facePatternSpinImgs, ...
        noOfSeedPoints, neigborhoodRadius, spinDistance, alfaBins, ...
        betaBins, alfaAxes, betaAxes, matchingRule, matchingDistanceType);
    
    %Wybranie segmentu twarzy:
    faceClusterPts = clusterPts{faceClusterNo};
    faceCost = faceMatchingCosts(faceClusterNo);
