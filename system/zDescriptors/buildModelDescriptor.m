function spinImgs = buildModelDescriptor ...
    (pts, n, selIxs, ...
     distance, alfaBins, betaBins, alfaAxes, betaAxes)
%----------------------Wrapper---------------------------------------------
% Builds spin images for selected points of model. 
% Parameters:
%  pts - points (x,y,z) of model
%  n - directions of normal vectors (nx,ny,nz) for every point of model
%  selIxs - vector of selected point's indexes.
% Returns:
%  spinImgs - matrix of spin images for selected points. 
%  Each image in one row.

%--------------------------------------------------------------------------

%Filter bad indexes:
selIxs = selIxs(selIxs~=0);

%Build descriptor:
spinImgs = buildDescriptor (pts, pts(selIxs,:), n(selIxs,:), ...
     distance, alfaBins, betaBins, alfaAxes, betaAxes);
 
 %-------------------------------------------------------------------------
 