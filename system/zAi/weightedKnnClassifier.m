function [markerValue neighbourIxs] = weightedKnnClassifier ...
    (pt, featurePts, markers, ...
     negativeWeight, positiveWeight, k)
% Assigns point with marker (==label) value basing on its neigbours.
% Parameters:
%  pt = [x y z] - point to be classified.
%  featurePts - potential neighbours
%  markers - assignment values for featurePts 
%   ASSUMPTION: there are only two classes: 0 (negative) and 1 (positive). 
%  negativeWeight - weight assigned to class 0 
%  positiveWeight - weight assigned to class 1
%  k - how many neighbours should be considered
% Returns:
%  markerValue -  assigned marker value
%  neighbourIxs - neihbours' indexes in featurePts vector
% 
% Klasyfikator k-nn dwóch klas (0/1). Klasy maj¹ ró¿ne wagi. 


    %calculate (Euclidean) distances:
    distances = sqrt( sum( (featurePts-repmat(pt, size(featurePts, 1), 1)).^2, 2) );
    
    %add column of indexes and sort using distance values:
    indexedDistances = sortrows( [(1:size(distances,1))' distances], 2);   
    
    %get neigbours:
    neighbourIxs    = indexedDistances(1:k, 1);
    noOfPositives   = sum( markers(neighbourIxs) );
    
    %neighbourhood class estimation:
    positiveValue = positiveWeight * (    noOfPositives);
    negativeValue = negativeWeight * (k - noOfPositives);
    
    %voting for marker value:
    markerValue = double( positiveValue > negativeValue );

    
    