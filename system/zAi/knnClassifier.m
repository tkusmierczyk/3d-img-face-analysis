function [markerValue neighbourIxs] = knnClassifier(pt, featurePts, markers, k)
% Assigns point with marker (==label) value basing on its neigbours.
% Parameters:
%  pt = [x y z] - point to be classified.
%  featurePts - potential neighbours
%  markers - assignment values for featurePts
%  k - how many neighbours should be considered
% Returns:
%  markerValue -  assigned marker value
%  neighbourIxs - neihbours' indexes in featurePts vector

    %calculate (Euclidean) distances:
    %distances = sqrt( sum( (featurePts-repmat(pt, size(featurePts, 1), 1)).^2, 2) );
    distances =      ( sum( (featurePts-repmat(pt, size(featurePts, 1), 1)).^2, 2) );
    
    %add column of indexes and sort using distance values:
    indexedDistances = sortrows( [(1:size(distances,1))' distances], 2); 
    
    %get neigbours:
    neighbourIxs = indexedDistances(1:k, 1);
    
    %voting for marker value:
    markerValue = mode( markers(neighbourIxs) );  
    