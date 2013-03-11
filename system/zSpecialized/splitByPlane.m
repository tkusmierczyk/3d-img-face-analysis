function leftMask = splitByPlane(pts,  n, sn, prn)
%Dzieli punkty 'pts' na le¿¹ce po lewej czêœci p³aszczyzny wyznaczonej
%przez 3 punkty (n, sn, prn) i na takie które le¿¹ z jej prawej strony.

% wektory wyznaczajace plaszczyzne:
lv = n - prn; 
hv = sn - prn;

% wektor prostopadly do plaszczyzny (skierowany w lewo):
indv = cross(lv, hv);

% wektory od czubka nosa do punktów na nosie:
dataLen =  size(pts,1);
pv = pts - repmat(prn, dataLen, 1);

% maska dziel¹ca nos na lew¹ i praw¹ czeœæ
leftMask = sum( pv .* repmat(indv, dataLen, 1), 2) > 0;