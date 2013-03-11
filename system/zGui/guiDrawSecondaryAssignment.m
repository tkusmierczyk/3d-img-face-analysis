function guiDrawSecondaryAssignment(pts2, n2, selIxs2, assignment)

hold on
colormap('Jet');
noOfPts = length(selIxs2);

%draw model:
scatter3(pts2(:,1), pts2(:,2), pts2(:,3), 2, n2*[1;1;1], 'filled' );

%labels:
selPts = pts2( selIxs2(assignment), :);
for i = 1:size(selPts,1)
    text( selPts(i,1), selPts(i,2), selPts(i,3), int2str(i), 'FontSize', 8);
end;    

%points:
scatter3(pts2(selIxs2,1), pts2(selIxs2,2), pts2(selIxs2,3), 10, 3*ones(noOfPts,1), 'filled');


