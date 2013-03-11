function [neigborhoodRadius ptsDensity]= estimatePCANeighborhoodRadius(pts)
%Oblicza wartosc promienia sasiedztwa (kuli otaczajacej punkty)
%ktory jest najlepszy do estymacji kierunkow normalnych do powierzchni w
%oparciu o PCA. Dodatkowo zwracane: ptsDensity - estymata gestosci powierzchniowej. 

%--------------------------------------------------------------------------
%parametry:

%ile punktow chcemy uzyskac srednio w promieniu optymalnym:
expectedNoOfPts     = 20;   
%na ilu punktach bedzie liczona estymata gestosci powierzchniowej:
noOfTestPts         = 100;       
%dla jakiego promienia estymowana bedzie gestosc powierzchniowa punktow:
referenceDistance	= 2; 

%--------------------------------------------------------------------------
%estymacja:

%gestosc powierzchniowa punktow:
ptsDensity = estimatePtsDensity(pts, noOfTestPts, referenceDistance);

%obliczenie optymalnego:
neigborhoodRadius = sqrt( expectedNoOfPts/ (ptsDensity * pi) );