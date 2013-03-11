
%Skrypt testuje wplyw losowego wyboru punktow.
%Dla kazdej wartosci ulamka wybieranych punktow i dla kazdej twarzy 
%generuje noOfSamples zestawow punktow wraz z deskryptorami ktore potem
%dopasuje dla danego modelu obliczajac koszty dopasowania.

%DANE:
dirPath = 'dat\correlation\'; %katalog  danych 
testPaths = {'cara1_frontal1', 'cara2_frontal2', 'cara3_arriba', ...
    'cara4_abajo', 'cara5_gesto', 'cara6_risa', ...
    'cara7_frontal1', 'cara8_abajo', 'cara9_frontal2', ...
    'cara10_risa'}; %pliki
%testPaths = {'cara1_frontal1', 'cara2_frontal2', 'cara3_arriba'}; %pliki

%--------------------------------------------------------------------------
%Konfiguracja deskryptorów dla jakich liczone s¹ korelacje:

distance = 100;
alfaBins = 10;
betaBins = 10;
alfaAxes = 'log';
betaAxes = 'log';

rule = 'OR';
distanceType = 1;

seedPtsVals = [25 50 75 100 125 150 175 200]; %testowe zestawy punktów:
%seedPtsVals = [300];

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

%£adowanie danych:
testPts = cell( length(testPaths), 1);
markers = cell( length(testPaths), 1);
w = guiStartWaitBar(0, 'Data loading...');
for i = 1:length(testPaths)
    [pss markers{i}] = loadMarkedData(dirPath, testPaths{i});
    testPts{i} = pss(markers{i}, :); %UWAGA: ta korekta nie by³a u¿ywana w liczeniu _1
end;    
guiStopWaitBar(w);

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
warning off;
%-------------------------------------------------------------------------

for noOfSeedPts = seedPtsVals %Dla ró¿nej liczby punktów testowych:
    
    %----------------------------------------------------------
    %Zbudowanie deskryptorów:
    desc = cell( length(testPaths), 1);
    for i = 1:length(testPaths) %dla ka¿dego pliku:%-----------   
        desc{i} = createDescriptor...
            (testPts{i}, noOfSeedPts, distance, ...
            alfaBins, betaBins, alfaAxes, betaAxes); 
    end;
    %----------------------------------------------------------            
        
    %----------------------------------------------------------
    fprintf('-------%i------\n', noOfSeedPts);
    for i = 1:length(testPaths)-1
        for j = i+1:length(testPaths)
            [costMatrix] = buildMatchingCost(desc{i}, desc{j}, ...
                rule, distanceType);
            [assignment cost] = matchDescriptors(costMatrix);
                
            fprintf(' %i %i  %.4f \n', i, j, cost);
        end;
    end;    
    fprintf('-------------\n');
    %----------------------------------------------------------

end; %for    





