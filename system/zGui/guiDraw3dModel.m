function guiDraw3dModel(pts, n)

colormap('Gray');
scatter3(pts(:,1), pts(:,2), pts(:,3), 3, n*[1;1;1], 'filled' );
