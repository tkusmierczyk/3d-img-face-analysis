function [costMatrix] = buildMatchingCost(spinImgs1, spinImgs2, ...
    rule, distanceType)
% [costMatrix] = buildMatchingCost(spinImgs1, spinImgs2, ...
% rule, distanceType)
%
% Calculates matching costs between lists of spin images.
% Parameters:
%  spingImgs1/2 - matrix. Each row means single spin image (histogram).
%  rule - 'AND'/'OR'/'NONE' - Rule used for filtering histograms.
%  distanceType - 1/2 - Determines metric (1 -> shape context feautures'
%  measure, 2 -> 1-corellation).
% Returns:
%  costMatrix - matrix of matching costs between spin images from
%  first and second list.

%dimensions:
n = size(spinImgs1, 1);
m = size(spinImgs2, 1);

%output buffer:
costMatrix = zeros(n, m);

%progress bar:
wbar = guiStartWaitBar(0, ['Calculating [' rule ', ' num2str(distanceType)...
    '] distances for ' num2str(n) 'x' num2str(m) ' descriptors  ...']);

%measure:
switch distanceType 
    
    case 1  %algorithm 1:        
      
        for i = 1:n          
            guiSetWaitBar( i/n );    
            for j = 1:m                
                [h k] = filterDescriptors( spinImgs1(i,:), spinImgs2(j,:), rule);        
                costMatrix(i, j) = descDistance(h, k);
            end;
        end;
    
    case 2 %algorithm 2:
               
        for i = 1:n          
            guiSetWaitBar( i/n );    
            for j = 1:m          
                [h k] = filterDescriptors( spinImgs1(i,:), spinImgs2(j,:), rule);        
                costMatrix(i, j) = descDistance2(h, k);    
            end;
        end;
    
    otherwise    
        error('distanceType parameter must be equal to either 1 or 2 value.');
    
end; %switch
    
%progress bar:
guiStopWaitBar(wbar)

