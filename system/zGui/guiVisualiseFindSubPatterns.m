function guiVisualiseFindSubPatterns(subPts, bgPts, ...
    hBgSeedPts, hBgSeedBadPts, hFaceSeedPts, hFaceSeedBadPts)
%guiVisualiseFindSubPatterns(subPts, bgPts, hBgSeedPts, hFaceSeedPts, hFaceSeedBadPts) 
%Wizualizuje wyniki dzia³ania metody findSubPatterns.
%Przyjmowane parametry jak dane zwracane przez metodê findSubPatterns.

if size(subPts, 1) == 0
    subPts = mean(bgPts);
end;    

hold on;
scatter3(subPts(:,1), subPts(:,2), subPts(:,3), 1, subPts(:,3), 'filled'); 
scatter3(bgPts(:,1), bgPts(:,2), bgPts(:,3), 1, 'k', 'filled');

% zielone - niedopasowane, niebieskie - dopasowane i pozostawione po segmentacji, 
% czerwone - dopasowane jako twarz po czym odrzucone i ustawione jako
% niedopasowane
maxz = max( [ max(subPts(:,3)) max(bgPts(:,3)) ] ) + 10;

scatter3(hBgSeedPts(:,1), hBgSeedPts(:,2), maxz*ones(size(hBgSeedPts,1),1), 10, 'g', 'filled' );
scatter3(hFaceSeedPts(:,1), hFaceSeedPts(:,2), maxz*ones(size(hFaceSeedPts,1),1), 10, 'b', 'filled' );

if size(hBgSeedBadPts, 1) > 0
    scatter3(hBgSeedBadPts(:,1), hBgSeedBadPts(:,2), maxz*ones(size(hBgSeedBadPts,1),1), 30, 'm', 'filled' );
end;   

if size(hFaceSeedBadPts, 1) > 0
    scatter3(hFaceSeedBadPts(:,1), hFaceSeedBadPts(:,2), maxz*ones(size(hFaceSeedBadPts,1),1), 30, 'r', 'filled' );
end;
