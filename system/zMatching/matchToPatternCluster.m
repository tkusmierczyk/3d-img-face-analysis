function [selectedClusterNo selectedClusterCost clusterMatchingCosts] = ...
matchToPatternCluster(patterSpinImgs, noOfClusters, ...
 selIxs, spinImgs, ... 
 matchingRule, matchingDistanceType)
%Dopasowuje klaster do klastra wzorca.
% 
%Parametry:
% patterSpinImgs - deskryptory wzorca
% noOfClusters - liczba klasterów
% selIxs - komórki zawieraj¹ce wektory indeksów punktów w klasterach dla
%  których liczono deskryptory
% spinImgs - deskryptory dla kolejnych klasterów (w kolejnych komórkach) 
% matchingRule - regu³a dopasowywania klasterów do wzorca
% matchingDistanceType - metoda liczenia odleg³oœci miêdzy deskryptorami
% 
%Zwraca:
% selectedClusterNo - numer klastera najlepiej dopasowanego do wzorca
% selectedClusterCost - koszt dopasowania najlepiej pasuj¹cego klastera
% clusterMatchingCosts - wektor kosztów dopasowania dla wszystkich
%  klasterów

%retrieve number of descriptors in pattern desc
noOfPatternDescs = size(patterSpinImgs, 1);

%output buffers:
clusterMatchingCosts = zeros(noOfClusters, 1);

%for every cluster:
for clusterNo = 1:noOfClusters    
    
    %retrieve cluster's descriptor size
    clusterNoOfDescs = length( selIxs{clusterNo} );
    
    %filter empty clusters:
    if clusterNoOfDescs < 1
        clusterMatchingCosts(clusterNo) = inf;
        continue;
    end;    
     
    %build descriptor:
    patternSpin = patterSpinImgs(1:clusterNoOfDescs, :);
    matchingCostMatrix = buildMatchingCost(patternSpin, spinImgs{clusterNo}, ...
        matchingRule, matchingDistanceType);
    %try matching:
    [assignment clusterMatchingCosts(clusterNo)] = matchDescriptors(matchingCostMatrix);        
    
    %jesli udalo sie zrobic mniej deskryptorow niz bylo we wzorcu to
    %przeskaluj koszt dopasowania tak zeby liczba deskryptorow nie miala
    %wplywu na jakosc dopasowania:
    clusterMatchingCosts(clusterNo) = ...
        clusterMatchingCosts(clusterNo) * noOfPatternDescs/clusterNoOfDescs;
    
end;    

%find face cluster:
[selectedClusterCost selectedClusterNo] = min(clusterMatchingCosts);
