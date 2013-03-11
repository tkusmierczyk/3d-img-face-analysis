function distance = descDistance(h, k)
% distance = descDistance(h, k)
% Calculates distance between two histograms (single points' descriptors).

    distance = 0.5 * sum( ((h-k).^2) ./ (h+k) );