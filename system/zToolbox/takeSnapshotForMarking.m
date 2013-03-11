function takeSnapshotForMarking(pts, path)
%Wykonuje zrzut widoku danych z przodu przystosowany do budowy maski dla
%funkcji markData. 

xmin = min( pts(:,1) );
xmax = max( pts(:,1) );

ymin = min( pts(:,2) );
ymax = max( pts(:,2) );

figure;
hold on;
guiDraw3d(pts);
set(gca, 'XLim', [xmin xmax]);
set(gca, 'YLim', [ymin ymax]);
f = getframe;
imwrite(f.cdata, path);      

