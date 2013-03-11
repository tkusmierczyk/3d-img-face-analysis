function [neighNoMean neighNoStd radiusMean radiusStd refDirDevMean refDirDevStd refDirDevMax currDirMinRadCorrect] = testPCAInfluence(file, fractionOfSeedPoints, neighRadiusRange, referenceRadiusIx)
%Funkcja testuje wyniki obliczania wektorow normalnych do powierzchni
%wzgledem roznych wartosci promienia sasiedztwa. 
%Dla modelu wybiera sie podzbior punktow dla ktorego oblicza sie wektory
%normalne dla roznych promieni i na tej podstawie obliczane sa statystyki:
% dot. liczby sasiadow
% dot. promienia otoczenia
% dot. zgodnosci z kierunkiem odniesienia
% dot. zgodniosci z kierunkiem biezacym
%Sample parameters:
% file = 'db\face1.txt'; %file to be analysed
% fractionOfSeedPoints   = 0.005;
% neighRadiusRange    = 1:1:3;
% referenceRadiusIx   = 3;    %indeks elementu z pow. wektora dla ktorego 
% oblicza sie kierunki odniesienia    

%--------------------------------------------------------------------------

%Prepare model:
model   = ioLoad3dData( file );  
selIxs  = getSeedPoints(model, fractionOfSeedPoints);

%--------------------------------------------------------------------------

%Output stats:
emptyBuffer     = zeros(length(neighRadiusRange), 1);
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

%Find nomral vectors for radius values:
nv = cell(length(neighRadiusRange), 1); %normal vectors
for i = 1:length(neighRadiusRange);
    neigborhoodRadius = neighRadiusRange(i);    
    
    %estimates normal vectors:
    [n u v noOfNeighbors radius] = findNUV(model, neigborhoodRadius, selIxs);
    n = fixNormalVectors(model, n);

    %filters empty values:
    nv{i} = n( n(:,1)~=0 |  n(:,2)~=0 |  n(:,3)~=0, :);
    
    %output stats:
    neighNoMean(i)  = mean(noOfNeighbors);
    neighNoStd(i)   = std(noOfNeighbors);
    radiusMean(i)   = mean(radius);
    radiusStd(i)    = std(radius);
end;


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Reference directions
nvRef = nv{referenceRadiusIx};

%Analiza zmiany sredniego kierunku normalnej wzgledem kierunku odniesienia
for i = 1:length(neighRadiusRange)
    %odchylenia od przyjetego kierunku odniesienia:
    %naleza do przedzialu 0 do 2    
    refDirectionDevs    = abs( 1-sum(nvRef .* nv{i}, 2) );
    
    %statystyki odchylen:
    refDirDevMean(i)    = mean(refDirectionDevs);
    refDirDevStd(i)     = std(refDirectionDevs);
    refDirDevMax(i)     = max(refDirectionDevs);
end;        

%--------------------------------------------------------------------------

%Analiza na ile zmniejszajac promien sasiedztwa zachowuje sie zgodnosc
%biezacego kierunku normalnej
correctnessThresh = 0.2; %prog zgodnosci 

%Analiza zmiany sredniego kierunku normalnej wzgledem kierunku odniesienia
for i = 2:length(neighRadiusRange)
    
    %Reference direction
    nvRef = nv{i};
    
    for j = i-1: -1: 1
        %odchylenia od przyjetego kierunku odniesienia:
        %naleza do przedzialu 0 do 2
        refDirectionDevs = abs( 1-sum(nvRef .* nv{j}, 2) );
       
             
        %jesli srednie odchylen przekraczyly prog nalezy przerwac
        if ( mean(refDirectionDevs) > correctnessThresh  )
            break;
        end;
    end;
    
    %zapisanie dla jakiego promienia odchylenie srednie przekroczylo
    %progowa niezgodnosc z kierunkiem biezacym
    currDirMinRadCorrect(i) = neighRadiusRange(j+1);
    
end;        

%uzuplenienie dla pierwszego 
currDirMinRadCorrect( currDirMinRadCorrect<1 ) = neighRadiusRange(1);
