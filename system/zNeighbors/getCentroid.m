function [centroid] = getCentroid(pts)
%Znajduje punkt ciê¿kosci zbioru punktów.
%Parametr:
% pts - punkty (x,y,z) w kolejnych wierszach macierzy.
%Wyjœcie
% centroid - wspó³rzêdne œrodka ciê¿koœci (wektor poziomy wspó³rzêdnych)

centroid = sum(pts, 1)/size(pts, 1);

end