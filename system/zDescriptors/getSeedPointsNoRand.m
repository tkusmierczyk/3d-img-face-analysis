function selIxs = getSeedPointsNoRand(pts, noOfSeedPoints)
% Wybiera z punktów 'pts' losowy podzbiór 'noOfSeedPoints' punktów (indeksy).

%----------------------------

noOfSeedPoints = min([noOfSeedPoints size(pts,1)]);

%----------------------------
%Losowy wybór punktów:

selIxs = randperm( size(pts,1) );
selIxs = selIxs( 1:noOfSeedPoints )';