function [positiveSubData negativeSubData assignment] = knnClassify( ...
    data, positiveSeedData, negativeSeedData, options)
%Dokonuje podzia³u zbioru danych na dwie klasy wykorzysuj¹c k-nn.
%Parametry:
% data - dane do podzielenia. W wierszach kolejne encje.
% positiveSeedData - wzorce do klasyfikacji pozytywnej.
% negativeSeedData - wzorce do klasyfikacji negatywnej.
% options - opcje.
%Zwracane:
% positiveSubData - dane zaklasyfikowane jako klasa pozytywna.
% negativeSubData - dane zaklasyfikowane jako klasa negatywna.
% assignment - wektor 0/1 mówi¹cy o przypisaniu do klas.
    
%--------------------------------------------------------------------------
%Opcje:
options.null = 0;

k = getOption(options, 'k', 5);

%--------------------------------------------------------------------------
%Przygotowanie danych ucz¹cych i buforów:
dataSize = size(data,1);
posSize = size(positiveSeedData,1);
negSize = size(negativeSeedData,1);

assignment = zeros( dataSize, 1);
featurePts = [positiveSeedData; negativeSeedData];
markers = [ones(posSize, 1); zeros(negSize, 1)];

%--------------------------------------------------------------------------
%Klasyfikacja:
w = guiStartWaitBar(0, [num2str(k) '-nn [+' num2str(posSize) '/-' ...
  num2str(negSize) '] classification of ' num2str(dataSize) ' points ...']);

for ix = 1 : dataSize
    guiSetWaitBar(ix/dataSize);
    assignment(ix) = knnClassifier( data(ix,:), featurePts, markers, k);
end; %for

guiStopWaitBar(w);

%--------------------------------------------------------------------------
%Rozdzielenie danych po klasyfikacji:
assignment = logical(assignment);

positiveSubData = data(assignment, :);
negativeSubData = data(~assignment, :);

