function [truePositive trueNegative falsePositive falseNegative] = ...
    compareBinaryMasks(mask1, mask2)
%Porównuje zgodnoœæ dwóch masek binarnych:
% mask1 - wzorzec
% mask2 - maska porównywana

truePositive  = sum( mask1 &  mask2);
trueNegative  = sum(~mask1 & ~mask2);

falsePositive = sum(~mask1 &  mask2);
falseNegative = sum( mask1 & ~mask2);
