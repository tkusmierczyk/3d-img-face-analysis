function [neighborhoodMask] = findNeighbors(ptIx, pts, neighbors, distance)

%create buffer:
selection = zeros( size(pts,1), 1);
%fill with seed:
selection( neighbors(:,1) == ptIx ) = 1;
%retrieve point coords:
pt = pts(ptIx,:);

%spread from lower to upper ixs among all neighbors:
for i = 1:size(neighbors,1) 
    if ( selection( neighbors(i,1) ) == 1)
        if (  sum((pts( neighbors(i,2), :) - pt).^2) < distance*distance)
            selection( neighbors(i,2) ) = selection( neighbors(i,1) );
        end;
    end;
end;


