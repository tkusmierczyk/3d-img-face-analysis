function [p] = probability(value, mu, sigma)
%Oblicza wiarygodność probabilistyczną zdarzenia.

p = 2*(1-cdf('Normal', abs(mu-value)+mu, mu, sigma));