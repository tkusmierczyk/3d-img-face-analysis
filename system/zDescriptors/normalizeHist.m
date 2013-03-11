function [nhist] = normalizeHist(hist)
% [nhist] = normalizeHist(hist)
% Transforms occurences matrix into distribution function using normalization.

nhist = hist ./ sum( sum(hist) );