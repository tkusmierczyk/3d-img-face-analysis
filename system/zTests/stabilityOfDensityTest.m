
%sprawdzenie stabilnosci uzyskiwanej gestosci pow punktow
%wzgledem zmieniajacej sie promienia dla jakiego analizuje sie wycinek pow.



pts = ioLoad3dData('in_mechatronika\20090622_135941.txt');

noOfTestPts = 100;
densities = [];
for referenceDistance = 0.5:0.5:5
        [ptsDensity] = estimatePtsDensity ...
                                (pts, noOfTestPts, referenceDistance)
        densities = [densities; ptsDensity];    
end;                    
                    
                    