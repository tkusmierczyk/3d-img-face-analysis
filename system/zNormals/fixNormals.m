function [n] = fixNormals(pts, descPts, n)
%function [n] = fixNormals(pts, descPts, n)
%
%Koryguje zwroty wektorów normalnych wykorzystuj¹c po³o¿enie 
%œrodka ciê¿koœci danych. Ustawia zwroty na zgodne z wektorem od 
%œrodka ciê¿koœci do punktu zaczepenia normalnej do powierzchni.
%Parametery:
% pts - macierz wierszy (x,y,z) wspó³rzêdnych punktów 
% descPts - punkty dla których policzono kierunki normalnych
% n - macierz wierszy (x,y,z) odpowiadaj¹cych wspó³rzêdnym wektorów
% normalnych
%Zwraca:
% n - skorygowana macierz (poprawione zwroty)

%--------------------------------------------------------------------------

%unify orientation according to data mean direction:
centroid = getCentroid(pts);
cDirection = descPts - repmat(centroid, size(descPts,1), 1); %centroid direction
invNIxs = dot(n, cDirection, 2)<0; %wrong normal orientation
n(invNIxs, :) = -n(invNIxs, :);    %inverts wrongly oriented normal vectors

%--------------------------------------------------------------------------