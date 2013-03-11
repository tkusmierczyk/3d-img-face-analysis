function [n u v noOfNeighbors radius] = findNormals(pts, ...
    neigborhoodRadius, descPts)
%  [n u v noOfNeighbors radius] = findNormals(pts, neigborhoodRadius,
%  descPts)
%
% Estimates (n,u,v) parameters for given points.
% Parameters:
%  pts - points [x y z]
%  neigborhoodRadius - what area should be considered during (n,u,v)
%   estimation for every point
%  descPts - points for which normal vectors will be estimated.
% Returns:
%  n - normal vectors calculated for given (descPts) points
%  (u,v) - calculated best fitted planes.
%  noOfNeighbors - vector of numbers of neighbors for selected (descPts) points
%  radius - vector of radius values for selected (descPts) points 

%--------------------------------------------------------------------------

%check data:
ptsSize = size(pts, 1);
if ptsSize == 1
    n = [];
    u = [];
    v = [];
    noOfNeighbors = [];
    radius = neigborhoodRadius;
    return ;
end;

%--------------------------------------------------------------------------

%progress bar:
noOfDescPts = size(descPts, 1);
wbar = guiStartWaitBar(0, ['Estimating (n,u,v) params for ' ...
    num2str(noOfDescPts) ' of ' num2str(ptsSize) ' points...']);

%prepare buffers:
u = zeros(3, noOfDescPts);
v = zeros(3, noOfDescPts);
noOfNeighbors = zeros(noOfDescPts, 1);
radius = zeros(noOfDescPts, 1);

%estimate for each seed point
for i = 1:noOfDescPts
    
    %progress bar:
    guiSetWaitBar(i/noOfDescPts);
    
    %find neighbors:
    pt = descPts(i,:);
    currentDistance = neigborhoodRadius;    
    neighbors = getNeighbours(pt, currentDistance, pts);   
    while size(neighbors, 1) == 1 %neigbours not found
        currentDistance = currentDistance * 1.5;
        neighbors = getNeighbours(pt, currentDistance, pts);       
    end;
    
    %save information about neighbors:
    noOfNeighbors(i) = size(neighbors, 1);
    radius(i) = currentDistance;
    
    %retrieve (u,v) plane coordinates:
    evec = getPcaVec(neighbors);        
    u(:,i) = evec(:, 1);
    v(:,i) = evec(:, 2);            
end;    

%transform to typical form:
u = u';
v = v';

%calculate normals as perpendicular to surface:
n = cross(u,v);

%progress bar:
guiStopWaitBar(wbar);

