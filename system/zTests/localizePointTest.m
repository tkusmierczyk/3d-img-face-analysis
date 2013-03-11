
clear all;
warning off;

%--------------------------------------------------

dataPath = 'patterns\punktyChar\cara1_frontal1_faceCutOut.txt';
maskPath = 'patterns\punktyChar\cara1_frontal1_nose.png';
outPath  = 'patterns\punktyChar\cara1_frontal1_faceCutOut_nose.txt';
[pts noseMask fpts] = loadAndStoreMarkedData2(dataPath, maskPath, outPath);
[fpts bgpts noseMask] = distanceClassify(pts, fpts, 10);

%--------------------------------------------------

ptNo = 2;
tic;
[subPts bgPts,  fgSeedPts, bgSeedPts, ...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  matchingCost subMask]...
= findPoint(pts, noseMask, ptNo);
t =  toc;

%--------

fprintf('fgSeed=%i(rej=%i)  bgSeed=%i(rej=%i) | fg=%i bg=%i | cost = %.4f | time=%.2f\n', ...
    size(hFaceSeedPts,1), size(hFaceSeedBadPts,1),  size(hBgSeedPts,1), size(hBgSeedBadPts,1), ...
    size(subPts,1), size(bgPts,1), matchingCost, t );
   
figure;
guiVisualiseFindSubPatterns(subPts, bgPts, ...
    hBgSeedPts, hBgSeedBadPts, hFaceSeedPts, hFaceSeedBadPts)    
figure;
guiVisualiseFindSubPatterns2(subPts, bgPts, fgSeedPts, bgSeedPts)

