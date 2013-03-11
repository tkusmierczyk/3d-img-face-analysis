function [subPts bgPts,  fgSeedPts, bgSeedPts, ...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  matchingCost subMask]...
= findFace(pts)

%--------------------------------------------------------------------------
%Ustawienia:

%deskryptory:
distance = 100;
alfaBins = 10;
betaBins = 10;
alfaAxes = 'log';
betaAxes = 'log';

options.matchingRule = 'AND';
options.matchingDistanceType = 1;

%po ile deskryptorów zbudowaæ we wzorcach:
noOfSpinImgs = 67;

%ile deskryptorów u¿yæ we wszystkich wzorcach ³¹cznie:
%(musi ich byæ nie wiêcej ni¿ noOfSpinImgs*liczba wzorców)
options.useNoSeedPts = 200;
%options.maxSeedPtsNo = 300; 

%filtrowanie punktów poszukiwanego regionu:
options.connectivityCoeff = 0.5;
options.clusterFraction = 0.4;

%filtrowanie punktów t³a:
options.k = 3;
options.positiveWeight = 5;
options.negativeWeight = 1;

%klasyfikator:
options.classifier = 'nn';
options.classifierOptions.noOfNetworks = 3;
options.classifierOptions.hiddenNeurons = 3;
options.classifierOptions.bpEpochs = 150;
options.classifierOptions.lmEpochs = 25;

options.force = 1;
options.altClassifier = 'knn';
options.classifierOptions.k = 5;

%Filtrowanie wyników klasyfikacji
options.classifierOptions.connectivityCoeff = 1.0;
options.classifierOptions.clusterFraction = 0.4;

%----------------------------------
%Wzorce:

areasFile = 'patterns\wycWieloma\patternsAreas';

f1  = 'patterns\wycWieloma\cara8_abajo_pattern.txt';
fd1 = 'patterns\wycWieloma\facedesc_cara8_abajo_pattern.txt';

f2  = 'patterns\wycWieloma\cara9_frontal2_pattern.txt';
fd2 = 'patterns\wycWieloma\facedesc_cara9_frontal2_pattern.txt';

f3  = 'patterns\wycWieloma\cara10_risa_pattern.txt';
fd3 = 'patterns\wycWieloma\facedesc_cara10_risa_pattern.txt';
%{
f4  = 'patterns\wycWieloma\cara11_frontal1_pattern.txt';
fd4 = 'patterns\wycWieloma\facedesc_cara11_frontal1_pattern.txt';

f5  = 'patterns\wycWieloma\cara12_frontal2_pattern.txt';
fd5 = 'patterns\wycWieloma\facedesc_cara12_frontal2_pattern.txt';
%}
%------------------------------------------------

options.spinDistance = distance;
options.alfaBins = alfaBins;
options.betaBins = betaBins;
options.alfaAxes = char(alfaAxes);
options.betaAxes = char(betaAxes);

%--------------------------------------------------------------------------

%ustawienie metody wyboru punktów:
global seedMethod;
seedMethod = 'kmeans';

pts_w1 = ioLoad3dData(f1);
buildAndStoreDescriptor(pts_w1, fd1, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

pts_w2 = ioLoad3dData(f2);
buildAndStoreDescriptor(pts_w2, fd2, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);


pts_w3 = ioLoad3dData(f3);
buildAndStoreDescriptor(pts_w3, fd3, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

%{
pts_w4 = ioLoad3dData(f4);
buildAndStoreDescriptor(pts_w4, fd4, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);


pts_w5 = ioLoad3dData(f5);
buildAndStoreDescriptor(pts_w5, fd5, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);
%}

%--------------------------------------------------------------------------


%ustawienie metody wyboru punktów:
global seedMethod;
seedMethod = 'oct';

patternAreas = estimateAndSaveFilesArea(areasFile, {f1, f2, f3}, 100, 2);    
[subPts bgPts ...
fgSeedPts, bgSeedPts,...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ...
matchingCost subMask] = findSubPatterns ...
    (pts, patternAreas, {fd1, fd2, fd3}, options);

%--------------------------------------------------------------------------
