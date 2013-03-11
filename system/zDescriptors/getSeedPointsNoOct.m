function selIxs = getSeedPointsNoOct(pts, noOfSeedPoints)
% Wybiera z punktów 'pts' podzbiór punktów (indeksy) wykorzystuj¹c 
% segmentacjê octClustering.
% Dane s¹ dzielone na 'noOfSeedPoints' grup. Dla ka¿dej grupy wybierany
% jest jeden punkt najbli¿szy œrodkowi.

%----------------------------

noOfSeedPoints = min([noOfSeedPoints size(pts,1)]);

%----------------------------
%Metod¹ segmentacji octClustering

clusters =  octClustering(pts, noOfSeedPoints);

centroids = zeros(noOfSeedPoints, 3);
for i = 1:noOfSeedPoints
    centroids(i,:) = mean( pts(clusters==i, :) );
end;    

%----------------------------
%Rozwi¹zanie które zjada za du¿o pamiêci:
%distMatrix = buildDistanceMatrix(centroids, pts);
%[pt selIxs] = min(distMatrix');
%Permutacja powoduje ¿e wynik nie jest deterministyczny.
%selIxs = selIxs( randperm( length(selIxs) ) )'; 

%-------

%Rozwi¹zanie wolniejsze ale oszczêdniejsze pamiêciowo:
selIxs = zeros(noOfSeedPoints, 1);
for i = 1: noOfSeedPoints
    distMatrix      = buildDistanceMatrix( centroids(i,:), pts);
    [pt selIxs(i)]	= min(distMatrix');
end;    
%Permutacja powoduje ¿e wynik nie jest deterministyczny.
selIxs = selIxs( randperm( length(selIxs) ) ); 

%----------------------------
