function [p] = probability(value, mu, sigma)
%Oblicza wiarygodnoœæ probabilistyczn¹ zdarzenia.

p = 2*(1-cdf('Normal', abs(mu-value)+mu, mu, sigma));