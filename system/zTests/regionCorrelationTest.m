
%Sprawdza jak deskryptory s¹ skorelowane z deskryptorami w otoczeniu.

%--------------------------------------------------------------------------

%Sciezka pliku do analizy:
filePath = 'dat\regLoc\cara10_risa_pattern.txt';
descPath = 'dat\regLoc\cara10_risa_1300pt_100_10log_10log.txt';
%--------------------------------------------------------------------------

%Konfiguracja:
noOfSpinImgs = 1300;
distance = 100;

alfaBins = 10;
betaBins = 10;
alfaAxes = 'log';
betaAxes = 'log';

filteringRule = 'OR';
distanceType = 1;

%Szerokosc okna gaussowskiego (odchylenie std w mm odleglosci)
gaussDev = 500; %67% w takiej odleglosci 99% w 3odleglosciach

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%£adowanie danych
pts = ioLoad3dData(filePath);
[spin selIxs] = buildAndStoreDescriptor(pts, descPath, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

%Obliczanie odleglosci
[costMatrix] = buildMatchingCost(spin, spin, filteringRule, distanceType);
[distMatrix] = buildDistanceMatrix(pts(selIxs,:), pts(selIxs,:));

%Analiza korelacji w otoczeniu (oknie gaussowskim)
regLoc = zeros(size(spin,1), 1);
for i = 1: size(spin, 1)
    
    %Usuniecie indeksu biezacego elementu
    neighIxs = 1: size(spin, 1) ~= i;
    %Przefiltrowanie obu macierzy usuwaj¹c element analizowany:
    distances = distMatrix(i, neighIxs);
    costs = costMatrix(i, neighIxs);
    
    %Obliczenie wagi na podstawie odleglosci geometrycznej
    p = pdf('Normal', distances, 0, gaussDev);
    weights = p/sum(p); %normalizacja
    
    %Obliczenie 
    regLoc(i) = sum(costs .* weights);
    
end; %---------------------------------------------

meanCost = mean(mean(costMatrix))

%---------------------------------------------
 
 
%hold on;
%scatter3(pts(:,1), pts(:,2), pts(:,3)*0, 3, pts(:,3), 'filled'); 
%range = max(regLoc) - min(regLoc)
%scatter3(pts(selIxs,1), pts(selIxs,2), pts(selIxs,3), 30, (regLoc-min(regLoc))/range, 'filled');          

%scatter3(pts(selIxs,1), pts(selIxs,2), pts(selIxs,3), 30, regLoc, 'filled');          

[classes] = nn1PtsClassifier(pts, regLoc, selIxs);
hold on;
colorbar;
xlabel('x [mm]'); ylabel('y [mm]'); zlabel('z [mm]'); 
scatter3(pts(:,1), pts(:,2), pts(:,3), 3, classes, 'filled'); 
%set(gca, 'XLim', [-60 60]);
