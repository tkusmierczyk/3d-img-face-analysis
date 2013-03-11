function selIxs = getSeedPointsNoKMeans(pts, noOfSeedPoints)
% Wybiera z punktów 'pts' podzbiór punktów (indeksy) wykorzystuj¹c 
% segmentacjê k-means.
% Dane s¹ dzielone na 'noOfSeedPoints' grup. Dla ka¿dej grupy wybierany
% jest jeden punkt najbli¿szy œrodkowi.

%----------------------------

noOfSeedPoints = min([noOfSeedPoints size(pts,1)]);

%----------------------------
%Metod¹ k-œrednich:
[clusters centroids] = kmeans(pts, noOfSeedPoints);
distMatrix = buildDistanceMatrix(centroids, pts);
[pt selIxs] = min(distMatrix');
selIxs = selIxs';
