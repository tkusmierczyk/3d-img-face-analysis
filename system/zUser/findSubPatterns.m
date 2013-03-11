function [subPts bgPts ...
          fgSeedPts, bgSeedPts, ...
		  hBgSeedPts bgSeedPtsMovedToFace hFaceSeedPts facePointsMovedToBg ...
		  matchingCost subMask] = findSubPatterns ...
		  (pts, patternAreas, patternDescFiles, options)
%Znajduje w zbiorze punktów obrazu 3D podzbiór mo¿liwie zgodny z wzorcem danym
%w postaci zestawu plików. Implementuje algorytm hierarchicznej lokalizacji
%regionów.
% 
%Parametry:
% pts - chmura punktów (obraz 3D) w której poszukiwany bêdzie wzorzec.
% patternAreas - wektor powierzchni wzorców.
% patternDescFiles - œcie¿ki plików zawieraj¹cych deskryptory wzorców
% (równie¿ w postaci komórek). 
% options - struktura zawieraj¹ca konfiguracjê zachowania siê procedury. 
%  Obs³ugiwane pola (w przypadku braku pola u¿ywana jest wartoœæ domyœlna):
%  roiMask(ang. region of interest) - wektor binarny o d³ugoœci równej 
%   liczbie punktów: |roiMask| = |pts|. S³u¿y on identyfikacji punktów 
%   które nale¿¹ do przeszukiwanego regionu i dla których podzbioru 
%   wygenerowane zostan¹ deskryptory. 
%  useNoSeedPts - sumaryczna dla wszystkich wzorców liczba deskryptorów do
%   wygenerowania.
%  classifier - typ stosowanego klasyfikatora. Mo¿liwe wartoœci: 
%   nn - sieæ neuronowa, knn - k-najbli¿szych s¹saidów, wknn - wa¿one k-nn.
%  classifierOptions - parametry specyficzne dla danego klasyfikatora.
% 
%Zwracane:
% subPts - punkty zaklasyfikowane jako nale¿¹ce do wzorca
% bgPts - punkty zaklasyfikowane jako nienale¿¹ce do wzorca
%
% fgSeedPts - punkty ucz¹ce (takie dla których wygenerowano deskryptory) 
%  dopasowane w wyniku wykonania algorytmu wêgierskiego do wzroców.
% bgSeedPts - punkty ucz¹ce, które nie zosta³y dopasowane do wzorców. 
%  Pos³u¿y³y one identyfikacji otoczenia poszukiwanego regionu - t³a.
%
% hBgSeedPts = bgSeedPts.
% hBgSeedBadPts - zbiór punktów zaklasyfikowany jako t³o ale odrzuconych
%  w filtrowaniu.
% hFaceSeedPts = fgSeedPts.
% hFaceSeedBadPts - zbiór punktów ucz¹cych zaklasyfikowanych jako
%  odpowiadaj¹ce wzorcowi, ale odrzuconych po analizie spójnoœci.
%
% matchingCost - sumaryczny koszt dopasowania deskryptorów wzorców do
%  deskryptorów obrazu analizowanego.


%------------------------------------------------ 

% force creation of options:
options.null = 0; 

%maska regionu dla którego budowaæ deskryptory (region of interest)
options.roiMask = getOption(options, 'roiMask', logical( 1:size(pts,1) )' );
roiMask = options.roiMask;

%deskryptory:
spinDistance = getOption(options, 'spinDistance', 100);
alfaBins     = getOption(options, 'alfaBins', 10);
betaBins     = getOption(options, 'betaBins', 10);
alfaAxes     = getOption(options, 'alfaAxes', 'log');
betaAxes     = getOption(options, 'betaAxes', 'log');

% parametry:
noOfPatterns	= min( [length(patternDescFiles) length(patternAreas)] );

%ile maksymalnie deskryptorów wygenerowaæ dla danych testowanych (na wzorzec):
maxSeedPtsNo            = getOption(options, 'maxSeedPtsNo', 10000);
%  ile obrazów obrotu u¿yæ z wzorców ³¹cznie:
useNoSeedPts            = getOption(options, 'useNoSeedPts', 150); 
% ustawienie liczby deskryptorów przypadaj¹cej na kazdy z plikow wzorca:
seedPtsPerPatternNo 	= round(useNoSeedPts/noOfPatterns);

% jakiego klasyfikatora u¿yæ:
classifier      = getOption(options, 'classifier', 'nn');
% klasyfikator awaryjny (gdy powy¿szy nie daje rady z klasyfikacj¹):
altClassifier   = getOption(options, 'altClassifier', 'knn');
% opcje przekazywane do klasyfikatora:
cOptions        = getOption(options, 'classifierOptions', struct);
forceFinding    = getOption(options, 'force', 0);

% parametry estymacji powierzchni:
areaNoOfTestPts = getOption(options, 'areaNoOfTestPts', 100);
areaReferenceDistance = getOption(options, 'areaReferenceDistance', 2);

%------------------------------------------------ 
%------------------------------------------------ 
%Wygenerowanie deskryptorów w analizowanych danych:

% estymacja powierzchni analizowanych danych:
area = estimateArea( pts(roiMask,:), areaNoOfTestPts, areaReferenceDistance);
                    
% wygenerowanie deskryptorów dla analizowanego obszaru:
seedPtsNo = round(seedPtsPerPatternNo * area./patternAreas);
[spinImgs selIxs] = getDescriptorSub(pts, roiMask, '', ...
    sum(seedPtsNo), spinDistance, alfaBins, betaBins, alfaAxes, betaAxes);     

%hold on;
%scatter3(pts(:,1), pts(:,2), pts(:,3), 1, pts(:,3), 'filled' );
%scatter3(pts(roiMask,1), pts(roiMask,2), pts(roiMask,3), 10, 'g', 'filled' );
%scatter3(pts(selIxs,1), pts(selIxs,2), pts(selIxs,3), 30, 'r','filled' );

% korekta gdy czasem nie ma wystarczajaco duzo punktow:
%noOfGeneratedDescs = length(selIxs);
%seedPtsNo = floor(seedPtsNo./sum(seedPtsNo) * noOfGeneratedDescs);
while length(selIxs) < sum(seedPtsNo)
    selIxs = [selIxs; selIxs];
    spinImgs = [spinImgs; spinImgs];
end; %while   


%------------------------------------------------ 
%------------------------------------------------ 
%Dopasowanie deskryptorów z analizowanych danych do deskryptorów wzorców:
%(Faza I budowania zbioru ucz¹cego).

% generacja z wzorców punktów do uczenia
fgSeedPts = [];
bgSeedPts = [];
matchingCost = 0;
selPointer = 1; 
for patternNo = 1: noOfPatterns

    %wyciêcie czêœci deskryptorów z deskryptorów analizowanego obrazu:
    ixs = selPointer: selPointer+seedPtsNo(patternNo)-1;
    selPointer = selPointer + seedPtsNo(patternNo);   
    spinImgsForPattern  = spinImgs(ixs,:);
    selIxsForPattern    = selIxs(ixs,:);
    
	%dopasowanie obliczonych deskryptorów do wzorca:
    [fgSeedIxs bgSeedIxs  matchingCost1] = ...
    matchToPatternDescFile( patternDescFiles{patternNo}, ...
     seedPtsPerPatternNo, spinImgsForPattern, selIxsForPattern, options);
    
	%zaktualizowanie deskryptorów:
	fgSeedPts = [fgSeedPts; pts(fgSeedIxs, :)];	
	bgSeedPts = [bgSeedPts; pts(bgSeedIxs, :)];
	matchingCost = matchingCost + matchingCost1;
    
end; %for		

%------------------------------------------------ 
%------------------------------------------------ 
%Przygotowanie zbioru ucz¹cego (filtrowanie danych):

%zapisanie punktów ucz¹cych (dane historyczne dla wizualizacji):
hBgSeedPts = bgSeedPts; %zapisanie do historii
hFaceSeedPts = fgSeedPts; %zapisanie do historii
%bgSeedPtsMovedToFace = [];
%facePointsMovedToBg = [];

%------------------------------------------------ 

%Reklasyfikacja punktów twarzy na podstawie po³¹czenia klastrów:
[fgSeedPts facePointsMovedToBg] = connectionFiltering(fgSeedPts, options);
bgSeedPts = [bgSeedPts; facePointsMovedToBg];

%-------

%Reklasyfikacja punktów t³a metod¹ k-nn:
[bgSeedPtsMovedToFace bgSeedPts] = ...
    weightedKnnClassify(bgSeedPts, fgSeedPts, bgSeedPts, options);
fgSeedPts = [fgSeedPts; bgSeedPtsMovedToFace];

%------------------------------------------------ 
%------------------------------------------------ 
%Klasyfikacja:
for iteration = 1:6
    switch classifier
        case 'nn'
            [subPts bgPts subMask] = nnClassify( pts(roiMask,:), ...
                fgSeedPts, bgSeedPts, cOptions);    
        case 'knn'
            [subPts bgPts subMask] = knnClassify( pts(roiMask,:), ...
                fgSeedPts, bgSeedPts, cOptions);
        case 'wknn'
             [subPts bgPts subMask] = weightedKnnClassify( pts(roiMask,:), ...
                 fgSeedPts, bgSeedPts, cOptions);
             
        otherwise
            error('Bad classifier name! Allowed values: nn/knn/wknn');
    end; %switch 
    
    %Warunek zakoñczenia: albo coœ znaleziono, albo nie trzeba znaleŸæ
    if size(subPts, 1) > 0 || forceFinding == 0
        break;
    end;
    
    %Warunek ratunkowego u¿ycia klasyfikatora:
    if iteration == 3
       classifier = altClassifier;
    end;
end; %for

bgPts = [bgPts; pts(~roiMask,:)];
[selIxs subMask] = doubleMask(roiMask, subMask, size(pts,1) );

%------------------------------------------------ 
%------------------------------------------------ 
%Filtrowanie koñcowe wyniku:

%Zachowuje wszystkie odpowiednio du¿e segmenty punktów:
[subPts  subPointsMovedToBg keptPts] = connectionFiltering(subPts, cOptions);
[selIxs subMask] = doubleMask(subMask, keptPts);
bgPts = [bgPts; subPointsMovedToBg];

