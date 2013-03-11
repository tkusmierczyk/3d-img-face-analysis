function guiVisualiseFindSubPatterns2(subPts, bgPts, fgSeedPts, bgSeedPts)
%Wizualizuje wyniki dzia³ania metody findSubPatterns.
%Przyjmowane parametry jak dane zwracane przez metodê findSubPatterns.

if size(subPts, 1) == 0
    subPts = mean(bgPts);
end;    

hold on;
scatter3(subPts(:,1), subPts(:,2), subPts(:,3), 1, subPts(:,3), 'filled'); 
scatter3(bgPts(:,1), bgPts(:,2), bgPts(:,3), 1, 'k', 'filled');


%maxz = max( [ max(subPts(:,3)) max(bgPts(:,3)) ] ) + 10;

%scatter3(bgSeedPts(:,1), bgSeedPts(:,2), maxz*ones(size(bgSeedPts,1),1), 10, 'g', 'filled' );
%scatter3(fgSeedPts(:,1), fgSeedPts(:,2), maxz*ones(size(fgSeedPts,1),1), 10, 'b', 'filled' );
