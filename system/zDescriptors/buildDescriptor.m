function spinImgs = buildDescriptor(pts,  descPts, descPtsN, ...
     distance, alfaBins, betaBins, alfaAxes, betaAxes)
 % Builds spin images for given points. 
% Parameters:
%  pts - points of model
%  descPts - points (x,y,z) for which descriptors should be created.
%  descPtsN - normal vectors (nx,ny,nz) for points.
% Returns:
%  spinImgs - matrix of spin images for selected points. 
%   Each image in one row.


%--------------------------------------------------------------------------
%prepare initial data:
selectionSize = size(descPts, 1);
descriptorLength = alfaBins*betaBins;
spinImgs = zeros(selectionSize, descriptorLength);

%progress bar:
wbar = guiStartWaitBar(0, ['Building descriptors [' num2str(distance) ',' ...
    num2str(alfaBins) alfaAxes ' ' num2str(betaBins) betaAxes '] for ' ...
    num2str( selectionSize ) ' of ' num2str( size(pts, 1) ) ' pts...']);

%build point descriptors:
for ix = 1:selectionSize %over points
    
    %progress bar:
    guiSetWaitBar(ix/selectionSize);
    
    %build 2D histogram:
    hist = buildSpinImage( descPts(ix, :), descPtsN(ix, :), pts, ...
        distance, alfaBins, betaBins, alfaAxes, betaAxes);    
    nHist = normalizeHist(hist);
    
    %copy to the array:
    spinImgs(ix, :) = reshape(nHist, descriptorLength, 1);
end;

%progress bar:
guiStopWaitBar(wbar);
