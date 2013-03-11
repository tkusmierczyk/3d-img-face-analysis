function [cells, rpts] = groupPoints(pts, cellSize)
% Groups points into cubes in 3D space.
% Parameters:
%  pts - matrix of points [x y z]
%  cellSize - cube edge length
% Returns:
%  cells - describes cells allocation; vector:
%   xstart ystart zstart xend yend zend firstPointIx lastPointIx
%   where: xstart ystart zstart xend yend zend - cube coords
%          firstPointIx - index of the first point in rpts that belongs to cell
%          lastPointIx - index of the last point belonging to cell
%  rpts - reordered points

%moves points to (more than) positive coords:
minVal = min(pts);
mpts = pts + repmat(-minVal, size(pts,1), 1) + cellSize;

%calculates no of needed cells:
maxVal = max(mpts);
xCells = ceil(maxVal(1)/cellSize);
yCells = ceil(maxVal(2)/cellSize);
zCells = ceil(maxVal(3)/cellSize);

%calculates cell assignment:
cCoords = floor(mpts/cellSize);

%prepares output buffers:
cells = zeros(xCells*yCells*zCells, 8);
rpts = zeros( size(mpts) );

%reorders points and assign to cells:
cellNo = 0;
rptsFirstIx = 1;
for xC = 1:xCells %loops over cells:
    for yC = 1:yCells
        for zC = 1:zCells
            
            %cell No:
            cellNo = cellNo + 1;
            
            %coordinates:
            x = xC*cellSize;
            y = yC*cellSize;
            z = zC*cellSize;
            
            %assignment:
            cellPtsMask = cCoords(:,1)==xC & cCoords(:,2)==yC & cCoords(:,3)==zC;
            rptsLastIx = rptsFirstIx + sum(cellPtsMask) - 1;
            cells(cellNo, :) = [x y z x+cellSize y+cellSize z+cellSize rptsFirstIx rptsLastIx];            
            
            %copying            
            if rptsLastIx >= rptsFirstIx
                cellPts = mpts(cCoords(:,1)==xC & cCoords(:,2)==yC & cCoords(:,3)==zC, :);
                rpts(rptsFirstIx:rptsLastIx, :) = cellPts;
                rptsFirstIx = rptsLastIx + 1;                
            end;    
            
        end;
    end;
end;