
%Skrypt sprawdza jak bardzo modele s¹ do siebie podobne 

%DANE:
dirPath = 'dat\cutOutParamsPre\'; %katalog  danych 
%{
testPaths = {'cara1_frontal1', 'cara2_frontal2', 'cara3_arriba', ...
    'cara4_abajo', 'cara5_gesto', 'cara6_risa', ...
    'cara7_frontal1', 'cara8_abajo', 'cara9_frontal2', ...
    'cara10_risa'}; 
%}
testPaths = {'cara1_frontal1', 'cara2_frontal2', 'cara3_arriba', ...
    'cara4_abajo', 'cara5_gesto'};


%-------------------------------------------------------------------------
%Konfiguracja deskryptorów dla jakich liczone s¹ korelacje:

distance = 100;
alfaBins = 10;
betaBins = 10;
alfaAxes = 'log';
betaAxes = 'log';

rule = 'OR';
distanceType = 1;

noOfTry = 1; %ile prob dla kazdego pliku

seedPtsVals = [25 50 75 100  125 150 175 200]; %testowe zestawy punktów:

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
    
    fprintf('-------%i------\n', noOfSeedPts);
           
    for i = 1:length(testPaths) %dla ka¿dego pliku:%-----------        
         %-----------------------------------
         spinImgs1 = createDescriptor...
            (testPts{i}, noOfSeedPts, distance, ...
            alfaBins, betaBins, alfaAxes, betaAxes);
        
         for j = 1:noOfTry %dla 10 testowych deskryptorów
             
            spinImgs2 = createDescriptor...
                (testPts{i}, noOfSeedPts, distance, ...
                alfaBins, betaBins, alfaAxes, betaAxes);
            
            [costMatrix] = buildMatchingCost(spinImgs1, spinImgs2, ...
                rule, distanceType);
            [assignment cost] = matchDescriptors(costMatrix);                
            
            fprintf('%.4f ', cost);
         end; %for 
         %-----------------------------------       
         
       fprintf('\n');
    end; %for %-------------------------------------------------
    
    fprintf('-------------\n');

end; %for    

