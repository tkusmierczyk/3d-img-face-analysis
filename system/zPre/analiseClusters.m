function [clusterSize clusterCum] = analiseClusters(ptCluster)
% [clusterSize clusterCum] = analiseClusters(ptCluster)
% Analises cluster-assignment.
% Returns:
%  clusterSize - matrix; each row in format: [clusterNo clusterSize]
%  clusterCum - cumulative function of clusters' sizes (bigger clusters
%  first)

%finds max cluster number:
maxClusterNo = max(ptCluster);
%calculates clusters-to-points distribution:
clusterSize = [ [1:maxClusterNo]' countOccurences(ptCluster, 1, maxClusterNo) ];
%bigger clusters at top:
clusterSize = sortrows(clusterSize, 2); 
clusterSize = clusterSize(maxClusterNo:-1:1, :); %descending
%calculate cumulative sum for clusters-to-points sorted distribution:
clusterCum = cumsum( clusterSize(:,2) );