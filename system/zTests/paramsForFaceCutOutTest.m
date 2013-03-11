
%Skrypt analizuj¹cy parametry przy wycinaniu modelu z twarzy.

%dirPath = 'dat\cutOutParams\'; %katalog dla danych po filteringu (bez
%wyboru twarzy
dirPath = 'dat\cutOutParamsPre\'; %katalog dla danych po preprocessingu

testPaths = {'cara1_frontal1', 'cara2_frontal2', 'cara3_arriba', ...
    'cara4_abajo', 'cara5_gesto', 'cara6_risa', ...
    'cara7_frontal1', 'cara8_abajo', 'cara9_frontal2', ...
    'cara10_risa', 'cara11_frontal1_pattern', 'cara12_frontal2_pattern'};

%-------------------------------------------------------------------------	
	
%£adowanie danych:
testPts = cell( length(testPaths), 1);
markers = cell( length(testPaths), 1);
w = guiStartWaitBar(0, 'Data loading...');
for i = 1:10
    [testPts{i} markers{i}] = loadMarkedData(dirPath, testPaths{i});
end;    
testPts{11} = ioLoad3dData( [dirPath testPaths{11} '.txt']);
testPts{12} = ioLoad3dData( [dirPath testPaths{12} '.txt']);
guiStopWaitBar(w);

%-----------------------------

%Ustawienie:
warning off all;
maxSpinImgs = 500;

%-----------------------------

%Analiza danych:
for noOfSpinImgs = [150]
for alfaAxes = {'log'}
for betaAxes = {'log'}
for distance = [100]
for alfaBins = [10]
for betaBins = [10]
        
    %Wstêpne zbudowanie deskryptorów dla ustawieñ:
    filePath = cell( length(testPaths), 1);
    for i = 1:length(testPaths)
        filePath{i} = [dirPath '_' testPaths{i} '_' num2str(maxSpinImgs) 'pt_' ...
            num2str(distance) '_' num2str(alfaBins) char(alfaAxes) '_' ...
            num2str(betaBins) char(betaAxes) '.txt'];
        
        buildAndStoreDescriptor(testPts{i}, filePath{i}, maxSpinImgs, ...
            distance, alfaBins, betaBins, alfaAxes, betaAxes);
    end;    
    
    %Ustawienia opcji:
    options.useNoSeedPts = noOfSpinImgs;           
    options.spinDistance = distance;
    options.alfaBins = alfaBins;
    options.betaBins = betaBins;
    options.alfaAxes = char(alfaAxes);
    options.betaAxes = char(betaAxes);

for matchingRule = {'OR'}     % 'OR', 'AND', 'NONE'
for matchingDistanceType = [1]
for hiddenNeuronsNo = [3]
    
    %Ustawienia opcji:
    options.threshold = 0.5;
    options.hiddenNeurons = hiddenNeuronsNo;
    options.matchingRule = char(matchingRule);
    options.matchingDistanceType = matchingDistanceType;
    
    fprintf('--------------------------------\n');
    fprintf('%i  %.4f %i %s %i %s  %i %s %i\n', options.useNoSeedPts, ...
        options.spinDistance, options.alfaBins, options.alfaAxes, ...
        options.betaBins, options.betaAxes, ...
        options.hiddenNeurons, options.matchingRule, options.matchingDistanceType);
    
    %Testowanie:
    cumOkPositive = 0;
    cumOkNegative = 0;
    cumBadPositive  = 0; %Te które uznane za pozytywne (nale¿¹ce do twarzy a w niej nie bêd¹ce)
    cumBadNegative = 0;
    for patternFileNo = 11:12
        options.patternFile = [dirPath testPaths{11} '.txt'];
        options.patternDescFile = filePath{11};
        fprintf(' %s\n', options.patternFile);
        for i = 1:10        

            options.descFile = filePath{i};

            [subPts bgPts hBgSeedPts hFaceSeedPts ...
            hFaceSeedBadPts matchingCost matchingFaceCost subMask] = ...
            findSubPattern( testPts{i}, options);            
        
            figure; guiVisualiseFindSubPattern(subPts, bgPts, hBgSeedPts, hFaceSeedPts, hFaceSeedBadPts);
            

            okPositive      = sum(markers{i} & subMask);
            okNegative      = sum(~markers{i} & ~subMask);
            badPositive     = sum(~markers{i} & subMask);
            badNegative     = sum(markers{i} & ~subMask);
            
            cumOkPositive = cumOkPositive + okPositive;
            cumOkNegative = cumOkNegative + okNegative;
            cumBadPositive = cumBadPositive + badPositive;
            cumBadNegative = cumBadNegative + badNegative;

            fprintf('  %i: %i %i %i \t%.4f %.4f \t%i %i  \t%i %i %i %i\n', i, ...
                size(hBgSeedPts,1), size(hFaceSeedPts,1), size(hFaceSeedBadPts, 1), ... %ile punktów ucz¹cych w grupach
                matchingCost, matchingFaceCost, ...%koszt dopasowania przed i po ciêciu
                sum(subMask), length(subMask), ... %ile uznane za twarz w modelu/ca³oœæ
                okPositive, okNegative, badPositive, badNegative); %jakoœæ klasyfikacji
        end;
    end;
    allPtsSize = cumOkPositive + cumOkNegative + cumBadPositive + cumBadNegative;
    facePtsSize = cumOkPositive + cumBadNegative;
    bgPtsSize = cumOkNegative + cumBadPositive;
    
    fprintf('ok: %.2f %.2f bad: %.2f %.2f\n', 100*cumOkPositive/allPtsSize, 100*cumOkNegative/allPtsSize, ...
        100*cumBadPositive/allPtsSize, 100*cumBadNegative/allPtsSize);
    fprintf('face: %.2f %.2f bg: %.2f %.2f\n', 100*cumOkPositive/facePtsSize, 100*cumBadNegative/facePtsSize, ...
        100*cumOkNegative/bgPtsSize, 100*cumBadPositive/bgPtsSize);
    fprintf('--------------------------------\n');

end;    
end;    
end;
end;
end;    
end;
end;
end;    
end;   