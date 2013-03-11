function guiDrawPrimaryAssignment(pts1, n1, selIxs1)

hold on
colormap('Jet');
noOfPts = length(selIxs1);

%model:
scatter3(pts1(:,1), pts1(:,2), pts1(:,3), 2, n1*[1;1;1], 'filled' );

%labels:
for i = 1:noOfPts
    text( pts1( selIxs1(i),1), pts1( selIxs1(i) ,2), pts1( selIxs1(i),3), int2str(i), 'FontSize', 8);
end;    

%points:
scatter3(pts1(selIxs1,1), pts1(selIxs1,2), pts1(selIxs1,3), 10, 3*ones(noOfPts,1), 'filled');
