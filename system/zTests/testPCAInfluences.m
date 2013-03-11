
%Skrypt testuje wyniki obliczania wektorow normalnych do powierzchni
%wzgledem roznych wartosci promienia sasiedztwa. 
%Dla modelu wybiera sie podzbior punktow dla ktorego oblicza sie wektory
%normalne dla roznych promieni i na tej podstawie obliczane sa statystyki:
% dot. liczby sasiadow
% dot. promienia otoczenia
% dot. zgodnosci z kierunkiem odniesienia

files = {'pcaTestIn\20090622_140322_filtered_raw.txt', 'pcaTestIn\20090623_113452_filtered_raw.txt', 'pcaTestIn\20090625_111725_filtered_raw.txt', 'pcaTestIn\20090625_112127_filtered_raw.txt', 'pcaTestIn\20090625_123233_filtered_raw.txt', 'pcaTestIn\cara46_frontal1_filtered_raw.txt', 'pcaTestIn\cara48_frontal1_filtered_raw.txt', 'pcaTestIn\cara50_frontal1_filtered_raw.txt', 'pcaTestIn\cara52_frontal2_filtered_raw.txt', 'pcaTestIn\cara53_frontal2_filtered_raw.txt' }; %files to be analysed
fractionOfSeedPoints   = 0.01;
neighRadiusRange    = 1: 1: 10;
referenceRadiusIx   = 5;%7;    %indeks elementu z pow. wektora dla ktorego 
                                % oblicza sie kierunki odniesienia    
          
%--------------------------------------------------------------------------                            
                            
%Output stats:
emptyBuffer     = cell(length(files), 1);
neighNoMean     = emptyBuffer;   %liczba sasiadow
neighNoStd      = emptyBuffer;
radiusMean      = emptyBuffer;   %promien otoczenia
radiusStd       = emptyBuffer;
refDirDevMean   = emptyBuffer;   %odchylenie normalnej od kierunku odniesienia
refDirDevStd    = emptyBuffer;
refDirDevMax    = emptyBuffer;      
currDirMinRadCorrect = emptyBuffer; %min wartosc promienia zachowujaca zgodnosc 
%z kierunkiem dla biezacego promienia

%--------------------------------------------------------------------------

%gathering results:
for fileNo = 1:length(files)    
    [neighNoMean{fileNo} neighNoStd{fileNo} radiusMean{fileNo} radiusStd{fileNo} refDirDevMean{fileNo} refDirDevStd{fileNo} refDirDevMax{fileNo} currDirMinRadCorrect{fileNo}] = testPCAInfluence(files{fileNo}, fractionOfSeedPoints, neighRadiusRange, referenceRadiusIx);    
end;    
