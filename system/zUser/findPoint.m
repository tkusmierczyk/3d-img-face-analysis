function [subPts bgPts,  fgSeedPts, bgSeedPts, ...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  matchingCost subMask]...
= findPoint(pts, roiMask, ptNo)

%--------------------------------------------------------------------------
%Ustawienia:

%Ustawienia budowania deskrptorów:
distance = 70;
alfaBins = 10;
betaBins = 10;
alfaAxes = 'log';
betaAxes = 'log';

rule = 'OR';
distanceType = 1;

%otoczenie punktu [mm]
ptNeighbourhood = 5; 


%ile deskryptorów budowaæ we wzorcach:
%ile deskryptorów zastosowaæ we wszystkich wzorcach ³¹cznie:
%(musi ich byæ mniej ni¿ noOfSpinImgs*liczba wzorców)
switch ptNo
    case 5 %subnaasale
        noOfSpinImgs = 10; 
        options.useNoSeedPts = 50;
        
    otherwise %pozosta³e
        noOfSpinImgs = 10; 
        options.useNoSeedPts = 50;
end;

%filtrowanie punktów poszukiwanego regionu:
options.connectivityCoeff = 1.0;
options.clusterFraction = 0.3;

%filtrowanie punktów t³a:
options.k = 3;
options.positiveWeight = 5;
options.negativeWeight = 1;

%klasyfikator:
options.classifier = 'wknn';
options.classifierOptions.k = 3;
options.classifierOptions.positiveWeight = 5;
options.classifierOptions.negativeWeight = 1;
options.classifierOptions.noOfNetworks = 3;
options.classifierOptions.hiddenNeurons = 3;
options.classifierOptions.bpEpochs = 200;
options.classifierOptions.lmEpochs = 50;
options.classifierOptions.radius = 5;

%Filtrowanie wyników klasyfikacji
options.classifierOptions.connectivityCoeff = 0.7;
options.classifierOptions.clusterFraction = 0.5;

%ustawienie regionu zainteresowania:
if exist('roiMask', 'var')
    options.roiMask = roiMask;
end;    

%wybór punktów:
global seedMethod;
seedMethod = 'kmeans';

%--------------------------------------------------------------------------

options.spinDistance = distance;
options.alfaBins = alfaBins;
options.betaBins = betaBins;
options.alfaAxes = char(alfaAxes);
options.betaAxes = char(betaAxes);

%--------------------------------------------------------------------------
%Za³adowanie punktów zaznaczonych na nosie:
varNosePts;

%Wyciêcie czubków (prn) nosów i zbudowanie dla nich deskryptorów. 
buildDescriptorsForNosePts;

areasFile = ['patterns\punktyChar\patternAreas_pt_' num2str(ptNo)];
%--------------------------------------------------------------------------

%wybór punktów:
global seedMethod;
seedMethod = 'rand';

fs = { patternFiles{1}, patternFiles{2}, patternFiles{3}, patternFiles{4}, patternFiles{5} };
fds = { descFiles{1}, descFiles{2}, descFiles{3}, descFiles{4}, descFiles{5} };

patternAreas = estimateAndSaveFilesArea(areasFile, fs, 100, 2);
[subPts bgPts ...
fgSeedPts, bgSeedPts,...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ...
matchingCost subMask] = findSubPatterns(pts, patternAreas, fds, options);
