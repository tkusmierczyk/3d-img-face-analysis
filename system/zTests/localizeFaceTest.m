
%Skrypt pomocniczny do testowania zachowania wycinania twarzy za pomoc¹
%ró¿nej liczby wzorców.

clear;

%--------------------------------------------------------------------------

%testFile = 'inDane\in_mechatronika\20090625_104148.txt';
%testFile = 'patterns\wycWieloma\cara7_frontal1.txt';
%testFile = 'C:\dev\MATLAB\R2008a\work\inDane\in_gavab_profile\cara14_izquierda.txt';
%testFile = 'C:\dev\MATLAB\R2008a\work\inDane\in_gavab\cara28_frontal1.txt';
testFile = 'C:\dev\MATLAB\R2008a\work\inDane\in_gavab\cara48_frontal1.txt';
%testFile = 'C:\dev\MATLAB\R2008a\work\inDane\in_gavab\cara17_frontal1.txt';
%testFile = 'C:\dev\MATLAB\R2008a\work\patterns\preTest\out_pre_test_rand\cara5_sonrisa.txt';
%testFile = 'patterns\punktyChar\cara1_frontal1.txt';
pts = ioLoad3dData(testFile);

%--------------------------------------------------------------------------

tic;
[subPts bgPts,  fgSeedPts, bgSeedPts, ...
hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  matchingCost subMask]...
= findFace(pts);
t = toc;

%--------

fprintf('fgSeed=%i(rej=%i)  bgSeed=%i(rej=%i) | fg=%i bg=%i | cost = %.4f | time=%.2f\n', ...
    size(hFaceSeedPts,1), size(hFaceSeedBadPts,1),  size(hBgSeedPts,1), size(hBgSeedBadPts,1), ...
    size(subPts,1), size(bgPts,1), matchingCost, t );
   
figure;
guiVisualiseFindSubPatterns(subPts, bgPts, ...
    hBgSeedPts, hBgSeedBadPts, hFaceSeedPts, hFaceSeedBadPts)    

figure;
guiVisualiseFindSubPatterns2(subPts, bgPts, fgSeedPts, bgSeedPts)

