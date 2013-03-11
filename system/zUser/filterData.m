function [pts ptsClusters removedToSmall clusterSize] = filterData(pts, options)
%Filtruje i wstêpnie przetwarza dane w celu usuniêcia szumu. Implementuje
%filtracjê przez segmentacjê w grupy po³¹czone.
%Parametry:
% pts - dane do przefiltrowania
% options - opcje filtrowania
%Zwraca:
% pts - przefiltrowane dane
% ptsClusters - przyporz¹dkowanie punktów do klasterów
% removedToSmall - liczba usuniêtych (odfiltrowanych punktów)
% clusterSize - wektor rozmiarów klasterów

%--------------------------------------------------------------------------

%Wymuœ utworzenie struktury opcji:
if nargin<2
    options.null = 0; 
end;

maxDistanceCoeff = getOption(options, 'connectivityCoeff', 0.7);
minFractionOfPtsInCluster = getOption(options, 'clusterFrac', 0.1);

%--------------------------------------------------------------------------

%clustering:
ptsClusters = connectionClustering(pts, maxDistanceCoeff);
clusterSize = analiseClusters(ptsClusters);

%simple filtering:
beforeRemovalSize = size(pts, 1);
[pts ptsClusters] = keepEnoughBigClusters(pts, ptsClusters, ...
        clusterSize, minFractionOfPtsInCluster);
removedToSmall = beforeRemovalSize - size(pts, 1);

