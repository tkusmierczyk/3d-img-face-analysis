function [neighbors selMask] = getNeighbours(pt, distance, pts)
% Finds neigbor points.
% Parameters:
%  pt - center point
%  distance - max distance to neighbor
%  pts - points to be tested set 
% Returns: 
%  neighbors - neigbor points
%  selMask - binary map of selected points

selMask = getDistances(pt, pts)<=distance;
neighbors = pts(selMask, :);