function [hist alfa beta r h alfaHist betaHist] = buildSpinImage(pt, pt_n, ...
    pts, distance, alfaBins, betaBins, alfaAxes, betaAxes)
% [hist alfa beta r h alfaHist betaHist] = buildSpinImage(pt, pt_n, pts,
% distance, alfaBins, betaBins, alfaAxes, betaAxes)
% Builds spin image of points arount pt point.
% Params:
%  pt - central point.
%  pt_n - normal to surface vector in pt.
%  pts - points to be analyzed
%  distance - neighborhood radius
%  alfaBins/betaBins - how many bins should be build
%  alfaAxes, betaAxes - axes type: 'log', 'lin'

    %find neigbors:
    neighbors = getNeighbours(pt, distance, pts);
    noOfNeigh = size(neighbors, 1);
    
    %calculate 2D coordinates:    
    r = ( neighbors - repmat(pt, noOfNeigh, 1) ); %wektor od pt do sasiadow
    
    %beta E (-distance, +distance)
    beta = r * pt_n'; %wspolrzedna wzgledem plaszczyzny stycznej 
                      %(rzut na wektor normalny)
                      
    %alfa E (0, distance)
    h = r - beta*pt_n; %skladowa prostopadla do normalnej
    alfa = sqrt( sum(h.*h, 2) ); %odleglosc od normalnej liczona 
                                 %jako dlugosc skladowej poziomiej
    %alfa = sqrt( sqrt( sum(r.*r, 2) )  -  beta.^2 ); %
                                 
    % alfa E [0, distance]
    % beta E [-distance distance]        
    
    %skalowanie zeby zminimalizowac
    %liczbe punktow wpadajacych w przedzial logarytmu
    %dajacy ujemne wyniki (tj. (0;1) )
    % bigNumber = 1000000;
    % alfa = bigNumber * alfa;
    % beta = bigNumber * beta;
    % distance = bigNumber * distance;
    
    %transform axes:
    %alfa axes:
    if strcmp(alfaAxes, 'lin')
        alfaDistance = distance;
    elseif strcmp(alfaAxes, 'log') 
        alfa = log(alfa + 1);
        alfaDistance = log(distance + 1);
    %elseif strcmp(alfaAxes, 'log2') 
    %    alfa = log2(alfa + 1);
    %    alfaDistance = log2(distance + 1);
    %elseif strcmp(alfaAxes, 'log10') 
    %    alfa = log10(alfa + 1);
    %    alfaDistance = log10(distance + 1);        
    else
        error('Bad argument for alfaAxes !');
    end;
    %beta axes:
    if strcmp(betaAxes, 'lin')
        betaDistance = distance;
    elseif strcmp(betaAxes, 'log') 
        beta = sign(beta) .* log(abs(beta) + 1);
        betaDistance = log(distance + 1);
    %elseif strcmp(betaAxes, 'log2') 
    %    beta = sign(beta) .* log2(abs(beta) + 1);
    %    betaDistance = log2(distance + 1);
    %elseif strcmp(betaAxes, 'log10') 
    %    beta = sign(beta) .* log10(abs(beta) + 1);
    %    betaDistance = log10(distance + 1);        
    else
        error('Bad argument for betaAxes !');
    end;   
            
    %validate:    
    %if sum(beta < -betaDistance | beta > betaDistance) ~= 0
    %    beta(beta < 0 | beta > betaDistance)
    %    error('Bad value for beta !');
    %end;    
    %if sum(alfa < -alfaDistance | alfa > alfaDistance) ~= 0
    %    alfa(alfa < 0 | alfa > alfaDistance)
    %    error('Bad value for alfa !');
    %end;    
                                 
    %build histogram:
    alfaHist = floor( alfa/alfaDistance * (alfaBins-1) ) + 1;
    betaHist = floor( ((beta*0.5)/betaDistance+0.5) * (betaBins-1) ) + 1;    
    hist = accumarray([alfaHist betaHist], ones(noOfNeigh, 1), [alfaBins betaBins]);