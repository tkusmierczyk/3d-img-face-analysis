function [minVals maxVals meanVals stdVals] = estimateDescStats(spinDesc, rule, distanceType)
% Oblicza statystyki odleglosci miedzy punktami dla pojedynczego
% deskryptora modelu. Dla kazdego z punktow modelu znajduje
% srednia/max/min/odchylenie odleglosci od pozostalych punktow. 

[autoCostMatrix] = buildMatchingCost(spinDesc, spinDesc, rule, distanceType);
n = size(spinDesc, 1);

minVals = zeros(n, 1);
maxVals = zeros(n, 1);
meanVals = zeros(n, 1);
stdVals = zeros(n, 1);

ixs = 1:n;
for i = ixs
    row = autoCostMatrix(i, ixs ~= i); %pomin wynik dla samego siebie
    
    minVals(i) = min(row);
    maxVals(i) = max(row);
    meanVals(i) = mean(row);
    stdVals(i) = std(row);
end;    
