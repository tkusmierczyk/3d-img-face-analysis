function [height length width heightSnPrn wl wr ... %wynikowe d³ugoœci
          heightP lengthP widthP heightSnPrnP wlP wrP... %prawdopodobieñstwa
          sex vaildDist validPt] = ...
          noseDistances(prn, nasion, sn, lal, ral)
%Na podstawie informacji o punktach oblicza wymiary nosa wraz z
%prawdopodobieñstwami ich uzyskania, oraz przewidywan¹ p³ci¹.
%Weryfikuje te¿ wiarygodnoœæ punktów.
% vaildDist - bitowy wektor 6 elementowy okreœlaj¹cy wiarygodnoœæ d³ugoœci.
% vaildDist - wektor 5 elementowy okreœlaj¹cy wiarygodnoœæ kolejnych punktów.

%-------------

height = dist(nasion, sn);
length = dist(nasion, prn);
width = dist(lal, ral);
heightSnPrn = dist(sn, prn);
wl = dist(lal, prn);
wr = dist(ral, prn);

%-------------

mi1M = 51.00; si1M = 3.37;
mi2M = 47.51; si2M = 3.44;
mi3M = 32.17; si3M = 2.8;
mi4M = 24.61; si4M = 2.32;

heightP_Male = probability(height, 51.00, 3.37);
lengthP_Male = probability(length, 47.51, 3.44);
widthP_Male = probability(width, 32.17, 2.8);
heightSnPrnP_Male = probability(heightSnPrn, 24.61, 2.32);

mi1F = 55.08; si1F = 4.62;
mi2F = 50.92; si2F = 4.95;
mi3F = 35.82; si3F = 2.85;
mi4F = 26.77; si4F = 2.53;

heightP_Female = probability(height, 55.08, 4.62);
lengthP_Female = probability(length, 50.92, 4.95);
widthP_Female = probability(width, 35.82, 2.85);
heightSnPrnP_Female = probability(heightSnPrn, 26.77, 2.53);

%---

mi5 = 32;
si5 = 4;
mi6 = 32;
si6 = 4;

wlP = probability(wl, 32, 4);
wrP = probability(wr, 32, 4);

%-------------

maleInd = mean([heightP_Male  lengthP_Male  widthP_Male  heightSnPrnP_Male]);
femaleInd = mean([heightP_Female lengthP_Female widthP_Female heightSnPrnP_Female]);

%-------------

if maleInd > femaleInd
    sex = 'M';
    
    heightP = heightP_Male; 
    lengthP = lengthP_Male; 
    widthP = widthP_Male; 
    heightSnPrnP = heightSnPrnP_Male; 
    
    mi1 = mi1M;
    si1 = si1M;
    mi2 = mi2M;
    si2 = si2M;
    mi3 = mi3M;
    si3 = si3M;
    mi4 = mi4M;
    si4 = si4M;
else
    sex = 'F';
    
    heightP = heightP_Female; 
    lengthP = lengthP_Female; 
    widthP = widthP_Female; 
    heightSnPrnP = heightSnPrnP_Female; 
    
    mi1 = mi1F;
    si1 = si1F;
    mi2 = mi2F;
    si2 = si2F;
    mi3 = mi3F;
    si3 = si3F;
    mi4 = mi4F;
    si4 = si4F;
end;    

%-------------

safetyBorder = 2;

vaildDist(1) = abs(height-mi1) <= 3*si1 + safetyBorder;
vaildDist(2) = abs(length-mi2) <= 3*si2 + safetyBorder;
vaildDist(3) = abs(width-mi3) <= 3*si3 + safetyBorder;
vaildDist(4) = abs(heightSnPrn-mi4) <= 3*si4 + safetyBorder;
vaildDist(5) = abs(wl-mi5) <= 3*si5 + safetyBorder;
vaildDist(6) = abs(wr-mi6) <= 3*si6 + safetyBorder;

%-------------

validPt(1) = vaildDist(1) + vaildDist(2) + vaildDist(4) + vaildDist(5) + vaildDist(6);
validPt(2) = vaildDist(1) + vaildDist(2);
validPt(3) = vaildDist(1) + vaildDist(4);
validPt(4) = vaildDist(3) + vaildDist(5);
validPt(5) = vaildDist(3) + vaildDist(6);


