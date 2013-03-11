function [sm] = subMask(outerMask, innerMask)
%Obie maski s¹ tego samego rozmiaru. Wyjœciowa maska ma rozmiar liczby
%elementów wybieranych przez zewnêtrzn¹ maskê i jedynki w miejscach w
%których wyznacza wewnêtrzna maska.

sm = innerMask(outerMask);