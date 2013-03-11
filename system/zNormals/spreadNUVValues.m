function [n u v] = spreadNUVValues(pts, n, u, v, selIxs)
% [n u v] = spreadNUVValues(pts, n, u, v, selIxs)
% Estimates (n,u,v) values for every point basing on the (n,u,v) information
% calculated for selected points. 

wbar = guiStartWaitBar(0, 'Spreading (n,u,v) params...');

featurePts = pts(selIxs, :);
noOfFPts = size(featurePts, 1);
noOfPts = size(pts, 1);

for i = 1:noOfPts
    
     guiSetWaitBar(i/noOfPts);
    
    %find nearest neighbor in feature points
    pt = pts(i, :);    
    distances = sum(  (featurePts - repmat(pt, noOfFPts, 1)).^2, 2);
    [nnDist, nnIx] = min(distances);
    
    %copy from nearest neighbor
    featurePtIx = selIxs(nnIx);
    n(i, :) = n(featurePtIx, :);
    u(i, :) = u(featurePtIx, :);
    v(i, :) = v(featurePtIx, :);
    
end;    

guiStopWaitBar(wbar);