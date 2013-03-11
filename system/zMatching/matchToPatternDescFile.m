function [fgSeedIxs bgSeedIxs  matchingCost matchingCostMatrix] = ...
matchToPatternDescFile( patternDescFile, patternSeedPtsNo, ...
                        spinImgs, selIxs, options)
%Dopasowuje deskryptory analizowanego obrazu do deskryptorów wzorca.
%
%Parametry:
% patternDescFile - plik zawieraj¹cy deskryptory wzorca.
% patternSeedPtsNo - liczba deskryptorów wzorca która powinna zostaæ u¿yta 
%  przy dopasowywaniu.
% spinImgs - deskryptory analizowanego obrazu które bêd¹ dopasowywane do
%  wzorca.
% selIxs - zbiór numerów punktów analizowanego obrazu dla których
%  wygenerowano deskryptory 'spinImgs'.
% options - opcje
%
%Zwracane:
% fgSeedIxs - indeksy punktów z 'selIxs' które dopasowano do wzorca
% bgSeedIxs - indeksy punktów z 'selIxs' których nie dopasowano do wzorca
% matchingCost - sumaryczny koszt dopasowania
% matchingCostMatrix - macierz kosztów dopasowania

%--------------------------------------------------------------------------
%Parametry:

% force creation of options:
options.null = 0; 

% dopasowywanie:
matchingRule = getOption(options, 'matchingRule', 'OR');
matchingDistanceType = getOption(options, 'matchingDistanceType', 1);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Za³adowanie deskryptorów wzorca:

% ³adowanie punktów wzorcowych:
patternSpinImgs = ioRestoreModelDescriptor(patternDescFile);

% wyciêcie deskryptorów w wymaganej liczbie:
patternSeedPtsNo = min([patternSeedPtsNo size(patternSpinImgs,1)]); %granica
patternSpinImgs = patternSpinImgs(1:patternSeedPtsNo, :);  

%------------------------------------------------    
%------------------------------------------------    
%Dopasowanie deskryptorów:

%macierz kosztów dopasowania:
matchingCostMatrix = buildMatchingCost(patternSpinImgs, spinImgs, ...
                                       matchingRule, matchingDistanceType);
%dopasowanie:
[assignment matchingCost] = matchDescriptors(matchingCostMatrix);  

%----------------

%podzial na punkty zaklasyfikowane do podwzorca (~twarzy):
assigned = assignment(assignment~=0);
fgSeedIxs = selIxs( assigned );

%znalezienie punktow odrzuconych:
notAssigned = ones( length(selIxs), 1);
notAssigned(assigned) = 0;
bgSeedIxs   = selIxs( notAssigned == 1 );
