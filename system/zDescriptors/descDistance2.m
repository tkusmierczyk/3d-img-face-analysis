function distance = descDistance2(h, k)
% distance = descDistance2(h, k)
% Calculates distance between two histograms (single points' descriptors).

    c = cov(h, k);
    try
        distance =  0.5 * (1 - c(1,2) / sqrt( c(1,1) * c(2,2) ));
    catch exception
        %warning('Failure while calculating distance, h= %i, k = %i', h, k);
        distance = descDistance(h, k);
    end;