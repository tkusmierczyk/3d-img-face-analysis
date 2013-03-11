function [distMatrix] = buildDistanceMatrix(pts1, pts2)
%Buduje macierz odleglosci miedzy dwoma grupami punktow.

pts1x = repmat( pts1(:,1), 1, size(pts2,1) );
pts1y = repmat( pts1(:,2), 1, size(pts2,1) );
pts1z = repmat( pts1(:,3), 1, size(pts2,1) );

pts2x = repmat( pts2(:,1)', size(pts1,1), 1 );
pts2y = repmat( pts2(:,2)', size(pts1,1), 1 );
pts2z = repmat( pts2(:,3)', size(pts1,1), 1 );

dx2 = (pts1x - pts2x) .* (pts1x - pts2x);
dy2 = (pts1y - pts2y) .* (pts1y - pts2y);
dz2 = (pts1z - pts2z) .* (pts1z - pts2z);

distMatrix = sqrt(dx2 + dy2 + dz2);