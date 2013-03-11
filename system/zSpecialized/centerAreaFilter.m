function [pts mask] = centerAreaFilter(pts, radius)
%Wycina punkty le¿¹ce w kuli o œrodku w punkcie ciê¿koœci i zadanym
%promieniu. 

centroid = getCentroid(pts);
[pts mask] = getNeighbours(centroid, radius, pts);
