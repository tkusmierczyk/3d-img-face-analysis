function [distances] = getDistances(pt, pts)
% Calculates distances between point (pt) and set of points {pts}.
% Each point = [x y z].
distances = sqrt( sum( (repmat(pt, size(pts,1), 1) - pts) .^ 2, 2) );
