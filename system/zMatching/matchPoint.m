function [no cost spinNo spinCost] = matchPoint(patternSpinImgs, spinImgs, options)
%Znajduje punkt najbardziej podobny do punktów zadanych jako wzorce.
%Parametry:
% patternSpinImgs - deskryptory punktów wzorcowych. 
% spinImgs - deskryptory punktów z których wybierany bêdzie najlepiej
% pasuj¹cy punkt.
%Zwracane:
% no - numer deskryptora dla którego znaleziono najlepsze dopasowanie.
% cost - koszt dopasowania dla najlepszego punktu
% spinNo - pionowy wektor indeksów deskryptorów pocz¹wszy od tych z
%  najmniejszym kosztem
% spinCost - pionowy wektor posortowanych kosztów dla wszystkich 
%   testowanych deskryptorów 


%--------------------------------------------------------------------------
%Parametry:

% force creation of options:
options.null = 0; 

% dopasowywanie:
matchingRule = getOption(options, 'matchingRule', 'OR');
matchingDistanceType = getOption(options, 'matchingDistanceType', 1);

%--------------------------------------------------------------------------

%Koszt ca³kowity jako suma kosztów wzglêdem poszczególnych wzorców:
costMatrix = buildMatchingCost(spinImgs, patternSpinImgs, ...
    matchingRule, matchingDistanceType);
costs = sum(costMatrix, 2); 

%Posortowanie:
ix = ( 1:size(spinImgs,1) )';
costs = sortrows([ix costs], 2);

%Wybranie wyników:
spinNo = costs(:,1);
spinCost = costs(:,2);

no = spinNo(1);
cost = spinCost(1);



