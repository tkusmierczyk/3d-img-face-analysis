function n = fixNormalVectors(pts, n)
%function n = fixNormalVectors(pts, n)
%
%Koryguje zwroty wektorów normalnych wykorzystuj¹c po³o¿enie 
%œrodka ciê¿koœci danych. Ustawia zwroty na zgodne z wektorem od 
%œrodka ciê¿koœci do punktu zaczepenia normalnej do powierzchni.
%Parametery:
% pts - macierz wierszy (x,y,z) wspó³rzêdnych punktów 
% n - macierz wierszy (x,y,z) odpowiadaj¹cych wspó³rzêdnym wektorów
% normalnych
%Zwraca:
% n - skorygowana macierz (poprawione zwroty)

%--------------------------------------------------------------------------
%unify orientation according to data mean direction:
n = fixNormals(pts, pts, n);
%--------------------------------------------------------------------------