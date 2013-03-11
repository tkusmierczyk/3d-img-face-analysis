function [fgPts bgPts keptPointsMask] = connectionFiltering(fgPts, options)
%Filtruje punkty. Pozostawia punkty nale¿¹ce do du¿ych klastrów i usuwa te
%nale¿¹ce do ma³ych.
%Zwracane:
% fgPts - punkty zaklasyfikowane jako te do zatrzymania.
% bgPts - punkty odrzucone
% keptPointsMask - maska maj¹ca '1' w indeksach odpowiadaj¹cym punktom do
%  zatrzymania i '0' w indeksach do odrzucenia

%Test parametrów:
if size(fgPts, 1) <= 0
    bgPts = [];
    keptPointsMask = [];
    return;
end;    

%--------------------------------------------------------------------------
%Opcje:
connectivityCoeff	= getOption(options, 'connectivityCoeff', 0.7);
clusterFraction     = getOption(options, 'clusterFraction', 0.4);

%--------------------------------------------------------------------------

%analiza przypisania do segmentow:
ptCluster = connectionClustering(fgPts, connectivityCoeff); 
clusterSize = analiseClusters(ptCluster);

%Wersja zachowuj¹ca wszystkie odpowiednio du¿e segmenty:
[fgPts faceSeedPtsClusters keptPointsMask bgPts] = ...
    keepEnoughBigClusters(fgPts, ptCluster, clusterSize, clusterFraction);
