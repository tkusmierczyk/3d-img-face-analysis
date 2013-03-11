function d = dist(pt1, pt2)
%Oblicza odleg³oœæ euklidesow¹ miêdzy dwoma punktami.

d = sqrt( sum( (pt1 - pt2).^2 ) );
