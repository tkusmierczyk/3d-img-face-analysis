function [n u v] = adaptiveNUV(pts, selIxs)
%---------------------------Wrapper----------------------------------------
%Pe³na procedura generacji kierunków normalnych i p³aszczyzn stycznych dla
%wybranego podzbioru punktów.
%Parametry:
% pts - punkty (x,y,z).
% selIxs - wektor indeksów dla których wygenerowaæ wartoœci (n,u,v).
%Zwracane:
% n,u,v - macierze wartoœci wspó³rzêdnych kierunków normalnych i wektorów 
% okreœlaj¹cych kierunki stycznych do powierzchni w punkcie. 
% Uwaga: d³ugoœci (n,u,v) == d³ugoœæ pts.

%--------------------------------------------------------------------------
[nSel uSel vSel] = adaptiveNormalsForFeaturePts(pts, pts(selIxs,:) );

ptsSize = size(pts, 1);
n = zeros(ptsSize, 3);
u = zeros(ptsSize, 3);
v = zeros(ptsSize, 3);
n(selIxs,:) = nSel;
u(selIxs,:) = uSel;
v(selIxs,:) = vSel;
%--------------------------------------------------------------------------

%{
neigborhoodRadius = estimatePCANeighborhoodRadius(pts);
[n u v] = findNUV(pts, neigborhoodRadius, selIxs);
n = fixNormalVectors(pts, n);
%}
