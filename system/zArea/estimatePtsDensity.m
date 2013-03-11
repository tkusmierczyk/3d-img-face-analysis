function [ptsDensity] = estimatePtsDensity ...
                        (pts, noOfTestPts, referenceDistance)
%function [ptsDensity] = estimatePtsDensity(pts, noOfTestPts, referenceDistance) 
%
%Estymuje œredni¹ gestoœæ powierzchniow¹ punktów.
%Parametry:
% pts - punkty modelu.
% noOfTestPts - liczba punktów na których wykonywany bêdzie test gêstoœci.
% referenceDistance - promieñ s¹siedztwa (kuli otaczaj¹cej) dla ka¿dego z 
% 	testowanych punktów.

%-------------------------------------------------------------------------

%wybieramy punkty testowe:
[selIxs noOfTestPts] = getSeedPointsNo(pts, noOfTestPts, 'rand');  %!

noOfNeighbors = zeros(noOfTestPts, 1); %liczba punktow w obszarze testowym
for i = 1:noOfTestPts
    pt = pts(selIxs(i), :);
    [neighbors] = getNeighbours(pt, referenceDistance, pts); 
    noOfNeighbors(i) = size(neighbors, 1);
end;

%estymata gestosci powierzchniowej liczby punktow:
noOfPts = mean(noOfNeighbors);
area = pi * referenceDistance * referenceDistance;
ptsDensity = noOfPts / area;
