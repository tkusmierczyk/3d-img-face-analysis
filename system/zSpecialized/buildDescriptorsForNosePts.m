
%Skrypt który ³aduje modele z plików. Wyszukuje otoczenie zaznaczonych
%punktów. Buduje deskryptory dla otoczenia.

%argumenty:
%ptNo - numer punktu na nosie
%descExt - rozszerzenie doklejane do nazwy pliku przy budowaniu
% deskryptorów
%...

%pliki do których zapisane zostan¹ wyciête fragmenty wzorców:
patternFiles = {['patterns\punktyChar\pts_pointRegion_ptNo_' num2str(ptNo) '_1.txt'], ...
                ['patterns\punktyChar\pts_pointRegion_ptNo_' num2str(ptNo) '_2.txt'], ...
                ['patterns\punktyChar\pts_pointRegion_ptNo_' num2str(ptNo) '_3.txt'], ...
                ['patterns\punktyChar\pts_pointRegion_ptNo_' num2str(ptNo) '_4.txt'], ...
                ['patterns\punktyChar\pts_pointRegion_ptNo_' num2str(ptNo) '_5.txt']};

%wzorce twarzy z których wycinane s¹ fragmenty wzorców (otoczenia punktów):
f1  = 'patterns\punktyChar\cara8_abajo_pattern.txt';
f2  = 'patterns\punktyChar\cara9_frontal2_pattern.txt';
f3  = 'patterns\punktyChar\cara10_risa_pattern.txt';
f4  = 'patterns\punktyChar\cara11_frontal1_pattern.txt';
f5  = 'patterns\punktyChar\cara12_frontal2_pattern.txt';

%pliki do których zapisywane s¹ deksyrptory:
descExt = ['_pointdesc_ptNo_' num2str(ptNo) '_.txt']; %rozszerzenie pliku zawierajacego deskryptor
descFiles = {[f1 descExt], [f2 descExt], [f3 descExt], [f4 descExt], [f5 descExt]};

%--------------------------------------------------------------------------

pts1 = ioLoad3dData(f1);
[fpts1 mask1] = getNeighbours(p1(ptNo,:), ptNeighbourhood, pts1);
ioStore3dRawData(patternFiles{1}, fpts1);
[spinImgs1, selIxs1] =  buildAndStoreDescriptorSub(pts1, mask1, descFiles{1}, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

%hold on;
%scatter3(pts1(:,1), pts1(:,2), pts1(:,3), 1, pts1(:,3), 'filled' );
%scatter3(pts1(selIxs1,1), pts1(selIxs1,2), pts1(selIxs1,3), 30, 'r', 'filled' );

pts2 = ioLoad3dData(f2);
[fpts2 mask2] = getNeighbours(p2(ptNo,:), ptNeighbourhood, pts2);
ioStore3dRawData(patternFiles{2}, fpts2);
[spinImgs2, selIxs2] =  buildAndStoreDescriptorSub(pts2, mask2, descFiles{2}, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

pts3 = ioLoad3dData(f3);
[fpts3 mask3] = getNeighbours(p3(ptNo,:), ptNeighbourhood, pts3);
ioStore3dRawData(patternFiles{3}, fpts3);
[spinImgs3, selIxs3] =  buildAndStoreDescriptorSub(pts3, mask3, descFiles{3}, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

pts4 = ioLoad3dData(f4);
[fpts4 mask4] = getNeighbours(p4(ptNo,:), ptNeighbourhood, pts4);
ioStore3dRawData(patternFiles{4}, fpts4);
[spinImgs4, selIxs4] =  buildAndStoreDescriptorSub(pts4, mask4, descFiles{4}, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);

pts5 = ioLoad3dData(f5);
[fpts5 mask5] = getNeighbours(p5(ptNo,:), ptNeighbourhood, pts5);
ioStore3dRawData(patternFiles{5}, fpts5);
[spinImgs5, selIxs5] =  buildAndStoreDescriptorSub(pts5, mask5, descFiles{5}, ...
    noOfSpinImgs, distance, alfaBins, betaBins, alfaAxes, betaAxes);
