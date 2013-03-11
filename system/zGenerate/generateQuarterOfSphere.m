function [x y z] = generateQuarterOfSphere(noOfPts)


x = rand(noOfPts, 1);
y = rand(noOfPts, 1) .* sqrt(1-x.^2);
z = sqrt(1 - x.^2 - y.^2);