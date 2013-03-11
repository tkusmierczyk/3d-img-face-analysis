function guiDraw3dModelN(pts, n)

colormap('Gray');
scatter3(pts(:,1), pts(:,2), pts(:,3), 3, n*[1;1;1], 'filled' );

x = ([pts(:,1) pts(:,1)+n(:,1)]);
y = ([pts(:,2) pts(:,2)+n(:,2)]);
z = ([pts(:,3) pts(:,3)+n(:,3)]);

for i = 1:50:size(x,1)
    line(x(i,:), y(i,:), z(i,:));
end;

