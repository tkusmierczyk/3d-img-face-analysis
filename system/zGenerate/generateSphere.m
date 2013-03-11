function [pts] = generateSphere(noOfPts)
% Generates sphere made as cloud of points.
% Radius is equal to 1.

[x1 y1 z1] = generateQuarterOfSphere(noOfPts/8);
[x2 y2 z2] = generateQuarterOfSphere(noOfPts/8);
[x3 y3 z3] = generateQuarterOfSphere(noOfPts/8);
[x4 y4 z4] = generateQuarterOfSphere(noOfPts/8);
[x5 y5 z5] = generateQuarterOfSphere(noOfPts/8);
[x6 y6 z6] = generateQuarterOfSphere(noOfPts/8);
[x7 y7 z7] = generateQuarterOfSphere(noOfPts/8);
[x8 y8 z8] = generateQuarterOfSphere(noOfPts/8);

pts = [x1 y1 z1; x2 -y2 z2; -x3 y3 z3; x4 y4 -z4; -x5 -y5 z5; -x6 y6 -z6; x7 -y7 -z7; -x8 -y8 -z8];
pts = pts( randperm(size(pts,1)), :);