function [n u v] = adaptiveNormalsForFeaturePts(pts, descPts)
%Pe³na procedura generacji kierunków normalnych i p³aszczyzn stycznych dla
%wybranych punktów.
%Parametry:
% pts - punkty (x,y,z).
% descPts - punkty dla których wygenerowane zostan¹ kierunki normalnych.
%Zwracane:
% n,u,v - macierze wartoœci wspó³rzêdnych kierunków normalnych i wektorów 
% okreœlaj¹cych kierunki stycznych do powierzchni w punkcie. 

%--------------------------------------------------------------------------

neigborhoodRadius = estimatePCANeighborhoodRadius(pts);
[n u v] = findNormals(pts, neigborhoodRadius, descPts);
n = fixNormals(pts, descPts, n);

%--------------------------------------------------------------------------