function [spinImgs selIxs n] = createDescriptor ...
 (pts, noOfSpinImgs, distance,  ...
  alfaBins, betaBins, alfaAxes, betaAxes)
%----------------------Wrapper--------------------------------------------
%Tworzy deskryptor o zadanych parametrach dla wybranego zestawu punktów.
%Parametry:
% pts - dane dla których zbudowaæ deskryptor
% noOfSpinImgs - jaki powiniene byæ rozmiar deskryptora (tj. ile punktów
%   dla których liczone bêd¹ obrazy obrotu powinno zostaæ wylosowanych)
% distance - promieñ s¹siedztwa stosowany przy liczeniu obrazów obrotu
% alfaBins/betaBins - rozdzielczoœæ deskryptorów
% alfaAxes/betaAxes - typy skali dla histogramów: 'lin'/'log'
%Zwracane:
% spinImgs - deskryptor w postaci macierzy. W wierszach zserializowane 
%  obrazy obrotów dla kolejnych punktów.
% selIxs - wektor indeksów punktów dla których zbudowano obrazy obrotów.
% n - kierunki normalnych

%--------------------------------------------------------------------------

%Wybranie punktów do deskryptora:
selIxs = getSeedPointsNo(pts, noOfSpinImgs);

%Utwórz deskryptor:
[spinImgs nSel] = createDescriptorForFeaturePts(pts, pts(selIxs,:),  ...
  distance, alfaBins, betaBins, alfaAxes, betaAxes);

%Transform (n,u,v) in a way that value is given for every point:
ptsSize = size(pts, 1);
n = zeros(ptsSize, 3);
n(selIxs,:) = nSel;

%--------------------------------------------------------------------------
%{
%Estymacja kierunków normalnych: 
n = adaptiveNUV(pts, selIxs);

%Zbudowanie deskryptora:
spinImgs = buildModelDescriptor ...
    (pts, n, selIxs, distance, alfaBins, betaBins, alfaAxes, betaAxes);
%}