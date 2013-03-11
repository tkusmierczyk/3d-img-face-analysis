function [fpts fptCluster keepPoints removedPts] = keepEnoughBigClusters(pts, ...
    ptCluster, clusterSize, minFractionOfPtsInCluster)
% [pts ptCluster] = keepEnoughBigClusters(pts, ptCluster, clusterSize,
% minFractionOfPtsInCluster)
% Filters points according to clusters' size.
% Returns: 
%  fpts - kept points.
%  fptCluster - cluster assignment for kept points.
%  keepPoints - mask that allows for filtering input data.
%  removedPts - removed points (those assigned to too small clusters).

minPtsInCluster = minFractionOfPtsInCluster * size(pts,1);
keepClusters = clusterSize( clusterSize(:,2)>minPtsInCluster, :);

%builiding filtering mask according to selected clusters:
keepPoints = zeros( size(pts,1), 1); %binary mask
for i=1:size(keepClusters, 1)
    keepPoints = keepPoints | ptCluster == keepClusters(i, 1);
end;

%filtering:
if sum(keepPoints) == 0 %jesli nie ma punktow do zachowania
    removedPts = pts;
    fpts = [];
    
    fptCluster = [];
else
    removedPts = pts(~keepPoints, :);
    fpts = pts(keepPoints, :);

    fptCluster = ptCluster(keepPoints, :); 
end; %if
