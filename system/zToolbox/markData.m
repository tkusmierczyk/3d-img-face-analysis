function markers = markData(pts, mask, r, g, b)
%Przypisuje punktom 3D wartoœci w zale¿noœci od dwuwymiarowej maski.
%Maska powinna byæ macierz¹ trójwymiarow¹ odpowiadaj¹c¹ rzutowi
%punktów danych na p³aszczyznê (x,y). Obszar maski wyznaczony jest przez
%wartoœci ekstremalne (min, max) punktów danych. 
%Trzeci wymiar powinien odpowiadaæ kolorowi.
%Wartoœci 1 (true) przypisane zostan¹ punktom dla których wartoœæ maski 
%wynosi (r,g,b). Pozosta³ym punktom przypisane zostan¹ wartoœci 0 (false).    

%--------------------------------------------------------------------------
% Rozdzielenie maski na kolory

maskr = mask(:,:,1);
maskg = mask(:,:,2);
maskb = mask(:,:,3);

%--------------------------------------------------------------------------
% Skalowanie danych do szeœcianu 1x1x1 po³o¿onego w œrodku uk³adu wsp.

pts(:,1) = pts(:,1) - min( pts(:,1) );
pts(:,2) = pts(:,2) - min( pts(:,2) );
pts(:,3) = pts(:,3) - min( pts(:,3) );

xmax = max( pts(:,1) );
ymax = max( pts(:,2) );
zmax = max( pts(:,3) );

pts(:,1) = pts(:,1) / xmax;
pts(:,2) = pts(:,2) / ymax;
pts(:,3) = pts(:,3) / zmax;

%--------------------------------------------------------------------------
% Obliczenie odpowiadaj¹cych punktów w masce:

maskXRange = size(mask,2)-1;
maxkYRange = size(mask,1)-1;

x = round(pts(:,1) * maskXRange) + 1;
y = maxkYRange - round(pts(:,2) * maxkYRange) + 1;
ind = sub2ind(size(maskr), y, x);

%--------------------------------------------------------------------------
% Obliczanie kolorów dla punktów:

ptR = maskr(ind);
ptG = maskg(ind);
ptB = maskb(ind);

markers = ptR==r & ptG==g & ptB==b;
%--------------------------------------------------------------------------



