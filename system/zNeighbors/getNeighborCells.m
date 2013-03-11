function [neighborCells] = getNeighborCells(pt, distance, cells)
% Finds cells that are nearby to point pt.

x = pt(1);
y = pt(2);
z = pt(3);
x1 = cells(:,1);
y1 = cells(:,2);
z1 = cells(:,3);
x2 = cells(:,4);
y2 = cells(:,5);
z2 = cells(:,6);

%calculates point-to-cube distances 
xDistance = min( abs([(x1-x) (x2-x)]), [], 2);
yDistance = min( abs([(y1-y) (y2-y)]), [], 2);
zDistance = min( abs([(z1-z) (z2-z)]), [], 2);

%enough close to cube or inside in each dimension:
maskX = (xDistance<=distance | (pt(1)>=x1 & pt(1)<=x2) );
maskY = (yDistance<=distance | (pt(2)>=y1 & pt(2)<=y2) );
maskZ = (zDistance<=distance | (pt(3)>=z1 & pt(3)<=z2) );

%select cells:
neighborCells = cells(maskX & maskY & maskZ, :); 
