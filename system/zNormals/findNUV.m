function [n u v noOfNeighbors radius] = findNUV(pts, neigborhoodRadius, selIxs)
%---------------------------Wrapper----------------------------------------
% [n u v] = findNUV(pts, neigborhoodRadius, selIxs)
%
% Estimates (n,u,v) parameters for selected points.
% Parameters:
%  pts - points [x y z]
%  neigborhoodRadius - what area should be considered during (n,u,v)
%  estimation for every point
%  selIxs - selected points
% Returns:
%  n - normal vectors for selected points (for others = 0)
%  (u,v) - best fitted plane.
%  noOfNeighbors - vector of numbers of neighbors for selected points
%  radius - vector of radius values for  selected points 
% 
%  Warning: length of (n,u,v) == length of pts; 
%           length of noOfNeighbors radius == length of selIxs

%--------------------------------------------------------------------------

%check data:
ptsSize = size(pts, 1);
if ptsSize == 1
    n = [0 0 0];
    u = [0 0 0];
    v = [0 0 0];
    noOfNeighbors = 0;
    radius = neigborhoodRadius;
    return ;
end;

%--------------------------------------------------------------------------

%Find normal vectors for selected points:
[nSel uSel vSel noOfNeighbors radius] = findNormals(pts, neigborhoodRadius, pts(selIxs,:) );

%Transform (n,u,v) in a way that value is given for every point:
n = zeros(ptsSize, 3);
u = zeros(ptsSize, 3);
v = zeros(ptsSize, 3);
n(selIxs,:) = nSel;
u(selIxs,:) = uSel;
v(selIxs,:) = vSel;

%--------------------------------------------------------------------------

