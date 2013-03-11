function [n u v pts spts mu] = smoothData(pts, neigborhoodRadius)

%progress bar:
wbar = guiStartWaitBar(0, 'Smoothing model and estimating (n,u,v) params...');

%split points' space into cells:
cellSize = min([neigborhoodRadius*3, max( max(pts)-min(pts) )/20]);
[cells pts] = groupPoints(pts, cellSize);

%--------------------------------------------------------------------------
spts = pts; %smoothed points
mu = pts;   %groups' means
u = zeros(3, size(pts,1));
v = zeros(3, size(pts,1));
noOfPts = size(pts, 1);
for i = 1:noOfPts
    
    %progress bar:
    guiSetWaitBar(i/noOfPts);
    
    %find neighbors:
    currentDistance = neigborhoodRadius;
    neighbors = getNeighborPts( pts(i,:), currentDistance, pts, cells);   
    while size(neighbors, 1) == 1 %neigbours not found
        currentDistance = currentDistance * 1.5;
        neighbors = getNeighborPts( pts(i,:), currentDistance, pts, cells);            
    end;
   
    %retrieve (u,v) plane coordinates:
    [evec mu(i,:)] = getPcaVec(neighbors);        
    u(:,i) = evec(:, 1);
    v(:,i) = evec(:, 2);    
    
    %calculate point smoothed coords:
    trmx = evec(:, [1 2]);	
    uvCoords = (pts(i,:)-mu(i,:)) * trmx; %coordinates on (u,v) plane
	spts(i,:) = mu(i,:) + uvCoords*trmx';		
end;

%transform to typical form:
u = u';
v = v';

%calculate normals as perpendicular to surface:
n = cross(u,v);

%progress bar:
guiStopWaitBar(wbar);
