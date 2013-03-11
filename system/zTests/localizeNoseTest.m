
%Skrypt pomocniczny do testowania zachowania wycinania nosa za pomoc¹
%ró¿nej liczby wzorców.

clear;

%--------------------------------------------------------------------------

testFile = 'inDane\in_gavab\cara4_frontal1.txt';
pts = ioLoad3dData(testFile);
[cpts roiMask] = centerAreaFilter(pts, 70);

%--------------------------------------------------------------------------

tic;
[subPts bgPts,  fgSeedPts, bgSeedPts, ...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  matchingCost subMask]...
= findNose(pts);
t = toc;

%---------------

fprintf('fgSeed=%i(rej=%i)  bgSeed=%i(rej=%i) | fg=%i bg=%i | cost = %.4f | time=%.2f\n', ...
    size(hFaceSeedPts,1), size(hFaceSeedBadPts,1),  size(hBgSeedPts,1), size(hBgSeedBadPts,1), ...
    size(subPts,1), size(bgPts,1), matchingCost, t );
   
figure;
guiVisualiseFindSubPatterns(subPts, bgPts, ...
    hBgSeedPts, hBgSeedBadPts, hFaceSeedPts, hFaceSeedBadPts)    
figure;
guiVisualiseFindSubPatterns2(subPts, bgPts, fgSeedPts, bgSeedPts)