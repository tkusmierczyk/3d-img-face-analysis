function [ptCluster noOfClusters meanDistance clustRadius maxDistance] =...
connectionClustering(pts, maxDistanceMultiplier)
% Assigns points to clusters using connectivity criteria. 
% Parameters:
%  pts - matrix of points: each row = [x y z]
%  maxDistanceMultiplier - multiplier used for max distance calculation:
%    max allowed neigbors distance =
%     = maxDistanceMultiplier * mean(neigbors' distances)
% Returns: 
%  ptCluster - vector of clusters' numbers assigned to points.
%  noOfClusters - number of created clusters.
%  meanDistance - average distance between neighbor points. 
%  clustRadius - clustering radius.

%installJava;

%progress bar:
wbar = guiStartWaitBar(0, ['Clustering ' num2str(size(pts,1)) ...
    ' points (Dc = ' num2str(maxDistanceMultiplier) ') ...']);

%delanoy triangulation in 3D:
dt = delaunay3(pts(:,1), pts(:,2), pts(:,3));

%progress bar:
guiSetWaitBar(0.3);

%split triangulation into point-point relations:
%each relation occurs twice ( a -> b & b -> a):
%some edges may be part of several triangles -> keep unique:
neighbors = unique([ dt(:,[1 2]); dt(:,[1 3]); dt(:,[1 4]); ...
    dt(:,[2 3]); dt(:,[2 4]); dt(:,[3 4]); dt(:,[2 1]); dt(:,[3 1]); ...
    dt(:,[4 1]); dt(:,[3 2]); dt(:,[4 2]); dt(:,[4 3]) ], 'rows');
%calculate distances between neighbors:
distances = ...
    sqrt( sum( ( pts(neighbors(:,1),:) - pts(neighbors(:,2), :) ).^2, 2) );
%calculate stats of distances:
%minDistance      = min(distances)
maxDistance       = max(distances);
meanDistance      = mean(distances);
%calculate max distance:
clustRadius = meanDistance * maxDistanceMultiplier;

%progress bar:
guiSetWaitBar(0.6);

%remove relations with to big distances:
%second column must be bigger one:
keepIxs = distances < clustRadius; %indexes to be kept
neighbors = neighbors(keepIxs, :);
%distances = distances(keepIxs);

%progress bar:
guiSetWaitBar(0.8);

%clustering:
ptCluster = double( pl.quark.cc.cluster( size(pts,1), ...
    neighbors(:,1), neighbors(:,2) ) );

noOfClusters = max(ptCluster);

%progress bar:
guiStopWaitBar(wbar);
