function [spinImgs descPtsN] = createDescriptorForFeaturePts ...
 (pts, descPts,  ...
  distance, alfaBins, betaBins, alfaAxes, betaAxes)
%Tworzy deskryptor o zadanych parametrach dla wybranego zestawu punktów.
%Parametry:
% pts - dane dla których zbudowaæ deskryptor
% descPts - punkty dla których wygenerowany zostanie deskryptor
%
% distance - promieñ s¹siedztwa stosowany przy liczeniu obrazów obrotu
% alfaBins/betaBins - rozdzielczoœæ deskryptorów
% alfaAxes/betaAxes - typy skali dla histogramów: 'lin'/'log'
%Zwracane:
% spinImgs - deskryptor w postaci macierzy. W wierszach zserializowane 
%  obrazy obrotów dla kolejnych punktów.
% descPtsN - kierunki normalnych


%--------------------------------------------------------------------------

%Estymacja kierunków normalnych: 
descPtsN = adaptiveNormalsForFeaturePts(pts, descPts);

%Zbudowanie deskryptora:
spinImgs = buildDescriptor(pts,  descPts, descPtsN, ...
     distance, alfaBins, betaBins, alfaAxes, betaAxes);
 
%--------------------------------------------------------------------------