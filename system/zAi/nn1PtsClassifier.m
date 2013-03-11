function [classes] = nn1PtsClassifier(pts, selClasses, selIxs)
%Klasyfikuje punkty 1-nn na podstawie przypisania do klas podzbioru punktów.
%Parametry:
% pts - wszystkie punkty
% selIxs - indeksy wybranych punktów
% selClasses - klasy podzbioru punktów
%Zwracane:
% classes - przypisanie do klas dla wszystkich punktów

wbar = guiStartWaitBar(0, 'Points classification...');

featurePts = pts(selIxs, :);
noOfFPts = size(featurePts, 1);
noOfPts = size(pts, 1);

classes = zeros(noOfPts, 1);
for i = 1:noOfPts
    
    guiSetWaitBar(i/noOfPts);
    
    %find nearest neighbor in feature points
    pt = pts(i, :);    
    distances = sum(  (featurePts - repmat(pt, noOfFPts, 1)).^2, 2);
    [nnDist, nnIx] = min(distances);
    
    %copy from nearest neighbor
    classes(i, :) = selClasses(nnIx, :);   
end;    

guiStopWaitBar(wbar);