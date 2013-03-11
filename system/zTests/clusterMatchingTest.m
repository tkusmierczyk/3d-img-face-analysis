
%--------------------------------------------------------------------------

outFile = 'clusterMatchingReport.txt';

%params:
testFiles = {'markedFiles\cara6_frontal1_filtered_raw.txt', 'markedFiles\cara6_frontal2_filtered_raw.txt', 'markedFiles\cara7_frontal1_filtered_raw.txt', 'markedFiles\cara32_frontal1_filtered_raw.txt', 'markedFiles\cara46_frontal1_filtered_raw.txt'};
%'markedFiles\cara48_frontal1_filtered_raw.txt',
%'markedFiles\cara50_frontal1_filtered_raw.txt',
%'markedFiles\cara50_frontal2_filtered_raw.txt', 'markedFiles\cara52_frontal2_filtered_raw.txt', 'markedFiles\cara53_frontal1_filtered_raw.txt', 'markedFiles\cara53_frontal2_filtered_raw.txt'
neigborhoodRadius = 4;
fractionOfSeedPoints = 0.05;

%--------------------------------------------------------------------------
files = testFiles;

wbar = guiStartWaitBar(0, 'Loading models...');
models = cell( size(files) );
for faceNo = 1:length(files)   
    models{faceNo} = ioLoad3dData( files{faceNo} );
    
    guiSetWaitBar( faceNo/length(files) );    
end;                                 
guiStopWaitBar(wbar);

%--------------------------------------------------------------------------

wbar = guiStartWaitBar(0, 'Processing models...');
n = cell( size(files) );
selIxs = cell( size(files) );
for faceNo = 1:length(files)   
    selIxs{faceNo} = getSeedPoints(models{faceNo}, fractionOfSeedPoints);
    n{faceNo} = findNUV(models{faceNo}, neigborhoodRadius, selIxs{faceNo});
    
    guiSetWaitBar( faceNo/length(files) );
end;                               
guiStopWaitBar(wbar);

%--------------------------------------------------------------------------

f = fopen(outFile, 'w');
    
    axes = {'lin', 'log'};

    %loop over all descriptor's parameters:
    for alfaAxesNo = 1:length(axes)
        for betaAxesNo = 1:length(axes)
            for distance = 20:40:200
                for alfaBins = [2 4 6 8 10 14 18 20]
                    for betaBins = [2 4 6 8 10 14 18 20]
                        a = axes{alfaAxesNo};
                        b = axes{betaAxesNo};
                        
                        fprintf('Calculating desc for: (%i %i %i %i %i)\n', alfaAxesNo, betaAxesNo, distance, alfaBins, betaBins);  
                                         
                        %building descriptors:
                        descriptor = cell( size(files) );
                        for faceNo = 1:length(files)     
                            descriptor{faceNo} = buildModelDescriptor(models{faceNo}, n{faceNo}, selIxs{faceNo}, distance, alfaBins, betaBins, a, b);                            
                        end;     
                        
                        fprintf('Estimating stats for: (%i %i %i %i %i)\n', alfaAxesNo, betaAxesNo, distance, alfaBins, betaBins);  
                        
                        %testing for all models:
                        for face1Ix = 1:(length(files)-1)
                            for face2Ix = (face1Ix+1):length(files)

                                selIxs1 = selIxs{face1Ix};
                                selIxs2 = selIxs{face2Ix};
                                                                
                                %------------------------------------------
                                %build cost matrices:
                                costMatrix1 = buildMatchingCost(descriptor{face1Ix}, descriptor{face2Ix}, 'OR', 1);
                                costMatrix2 = buildMatchingCost(descriptor{face1Ix}, descriptor{face2Ix}, 'OR', 2);
                                %costMatrix3 = buildMatchingCost(descriptor{face1Ix}, descriptor{face2Ix}, 'AND', 1);
                                %costMatrix4 = buildMatchingCost(descriptor{face1Ix}, descriptor{face2Ix}, 'AND', 2);
                                %costMatrix5 = buildMatchingCost(descriptor{face1Ix}, descriptor{face2Ix}, 'NONE', 1);
                                %costMatrix6 = buildMatchingCost(descriptor{face1Ix}, descriptor{face2Ix}, 'NONE', 2);
                                
                                %wbar = guiStartWaitBar(0, 'Building dependant distances...');
                                %costMatrix7 = 0.5*(costMatrix1 + costMatrix2);  guiSetWaitBar(0.16);
                                %costMatrix8 = costMatrix1; 
                                %costMatrix8( costMatrix1>costMatrix2 ) = costMatrix2( costMatrix1>costMatrix2 ); 
                                %guiSetWaitBar(0.32);
                                %costMatrix9 = costMatrix1; 
                                %costMatrix9( costMatrix1<costMatrix2 ) = costMatrix2( costMatrix1<costMatrix2 );
                                %guiSetWaitBar(0.50);
                                
                                %costMatrix10 = 0.5*(costMatrix3 + costMatrix4); guiSetWaitBar(0.66);
                                %costMatrix11 = costMatrix3;
                                %costMatrix11( costMatrix3>costMatrix4 ) = costMatrix4( costMatrix3>costMatrix4 );
                                %guiSetWaitBar(0.82);
                                %costMatrix12 = costMatrix3;
                                %costMatrix12( costMatrix3<costMatrix4 ) = costMatrix4( costMatrix3<costMatrix4 );
                                %guiSetWaitBar(1.00);                                
                                %guiStopWaitBar(wbar);
                                
                                %------------------------------------------
                                % assigns descriptor points:
                                wbar = guiStartWaitBar(0, 'Matching...');
                                %matchingTotalCost = zeros(12, 1);
                                [assignment1 matchingTotalCost(1)] = matchDescriptors(costMatrix1); guiSetWaitBar(0.08);
                                [assignment2 matchingTotalCost(2)] = matchDescriptors(costMatrix2); guiSetWaitBar(0.16);
                                %[assignment3 matchingTotalCost(3)] = matchDescriptors(costMatrix3); guiSetWaitBar(0.24);
                                %[assignment4 matchingTotalCost(4)] = matchDescriptors(costMatrix4); guiSetWaitBar(0.32);                                
                                %[assignment5 matchingTotalCost(5)] = matchDescriptors(costMatrix5); guiSetWaitBar(0.40);
                                %[assignment6 matchingTotalCost(6)] = matchDescriptors(costMatrix6); guiSetWaitBar(0.50);
                                %[assignment7 matchingTotalCost(7)] = matchDescriptors(costMatrix7); guiSetWaitBar(0.58);
                                %[assignment8 matchingTotalCost(8)] = matchDescriptors(costMatrix8);  guiSetWaitBar(0.66);
                                %[assignment9 matchingTotalCost(9)] = matchDescriptors(costMatrix9);  guiSetWaitBar(0.74);  
                                %[assignment10 matchingTotalCost(10)] = matchDescriptors(costMatrix10);  guiSetWaitBar(0.82);
                                %[assignment11 matchingTotalCost(11)] = matchDescriptors(costMatrix11);  guiSetWaitBar(0.90);        
                                %[assignment12 matchingTotalCost(12)] = matchDescriptors(costMatrix12);  guiSetWaitBar(1.00);
                                guiStopWaitBar(wbar);
                                
                                %------------------------------------------
                                %store matching quality:                             
                                fprintf(f, ' %i %i ', face1Ix, face2Ix);   
                                fprintf(f, ' %i %i %i %i %i ', alfaAxesNo, betaAxesNo, distance, alfaBins, betaBins);   
                                fprintf(f, ' %f ', matchingTotalCost);   
                                %fprintf(f, ' %s %s', files{face1Ix}, files{face2Ix});
                                fprintf(f, '\n');
                                
                                %------------------------------------------
                                %------------------------------------------
                            end;
                        end;
                    end;
                end;    
            end; 
        end;
    end;    


fclose(f);

