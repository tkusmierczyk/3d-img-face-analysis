function [npts] = getNeighborPts(pt, distance, pts, cells)
% Finds neigbor points using cell information.
% Parameters:
%  pt - center point
%  distance - max distance to neighbor
%  pts - grouped points to be tested 
%  cells - information about groups of points


neighborCells = getNeighborCells(pt, distance, cells);
selectionMask = zeros( size(pts,1), 1);

for i=1:size(neighborCells,1)
    selectionMask( neighborCells(i, 7):neighborCells(i, 8) ) = 1;
end;

npts = pts(selectionMask==1, :);
npts = getNeighbours(pt, distance, npts);