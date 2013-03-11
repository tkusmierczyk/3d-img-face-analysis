function [pts markers] = loadMarkedData(dirPath, fileName)
%£aduje plik oraz maskê. 
%Plik i maska powinny ró¿niæ siê tylko rozszerzeniem. 
%U¿ywane w obliczaniu parametrów dla wycinania danych.

pts = ioLoad3dData([dirPath fileName '.txt']);
mask = imread([dirPath fileName '.png']);

markers = markData(pts, mask, 0, 0, 0); 