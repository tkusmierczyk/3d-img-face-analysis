
%Skrypt do analizy znajdowania punktów charakterystycznych w podejœciu
%bezpoœredniej identyfikacji punktów.

%--------------------------------------------------------------------------
%Wyciêcie nosów. 

f1  = 'patterns\punktyChar\cara8_abajo_pattern.txt';
fn1 = 'patterns\punktyChar\cara8_abajo_nose';
[pts1 markers1 fpts1] = loadAndStoreMarkedData2(f1, [fn1 '.png'], [fn1 '.txt']);

f2  = 'patterns\punktyChar\cara9_frontal2_pattern.txt';
fn2  = 'patterns\punktyChar\cara9_frontal2_nose';
[pts2 markers2 fpts2] = loadAndStoreMarkedData2(f2, [fn2 '.png'], [fn2 '.txt']);

f3  = 'patterns\punktyChar\cara10_risa_pattern.txt';
fn3  = 'patterns\punktyChar\cara10_risa_nose';
[pts3 markers3 fpts3] = loadAndStoreMarkedData2(f3, [fn3 '.png'], [fn3 '.txt']);

f4  = 'patterns\punktyChar\cara11_frontal1_pattern.txt';
fn4  = 'patterns\punktyChar\cara11_frontal1_nose';
[pts4 markers4 fpts4] = loadAndStoreMarkedData2(f4, [fn4 '.png'], [fn4 '.txt']);

f5  = 'patterns\punktyChar\cara12_frontal2_pattern.txt';
fn5  = 'patterns\punktyChar\cara12_frontal2_nose';
[pts5 markers5 fpts5] = loadAndStoreMarkedData2(f5, [fn5 '.png'], [fn5 '.txt']);
%--------------------------------------------------------------------------

%Ustawienia budowania deskrptorów:
distance = 70;
alfaBins = 5;
betaBins = 5;
alfaAxes = 'log';
betaAxes = 'log';

rule = 'OR';
distanceType = 1;

%--------------------------------------------------------------------------
%Wczytanie punktów na nosie:
varNosePts;
varNosePts2;

%--------------------------------------------------------------------------
%Odleg³oœci miêdzy tymi samymi punktami:
r1 = dist(p1', p1a');
r2 = dist(p2', p2a');
r3 = dist(p3', p3a');
r4 = dist(p4', p4a');
r5 = dist(p5', p5a');

r = [r1; r2; r3; r4; r5];
mean(r)
std(r)

%--------------------------------------------------------------------------
%Deskryptory punktów na nosie:
si1 = createDescriptorForFeaturePts (pts1, p1, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si2 = createDescriptorForFeaturePts (pts2, p2, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si3 = createDescriptorForFeaturePts (pts3, p3, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si4 = createDescriptorForFeaturePts (pts4, p4, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si5 = createDescriptorForFeaturePts (pts5, p5, distance, alfaBins, betaBins, alfaAxes, betaAxes);

si1a = createDescriptorForFeaturePts (pts1, p1a, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si2a = createDescriptorForFeaturePts (pts2, p2a, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si3a = createDescriptorForFeaturePts (pts3, p3a, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si4a = createDescriptorForFeaturePts (pts4, p4a, distance, alfaBins, betaBins, alfaAxes, betaAxes);
si5a = createDescriptorForFeaturePts (pts5, p5a, distance, alfaBins, betaBins, alfaAxes, betaAxes);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Koszty miêdzy 2 punktami zaznaczonymi przez cz³owieka:
%1 na ca³ej twarzy, 1 na nosie: pokazuje jakie b³êdy robiê zaznaczaj¹c
cost11a = buildMatchingCost(si1, si1a, rule, distanceType);
xcost11a = cost11a([1 7 13 19 25])

cost22a = buildMatchingCost(si2, si2a, rule, distanceType);
xcost22a = cost22a([1 7 13 19 25])

cost33a = buildMatchingCost(si3, si3a, rule, distanceType);
xcost33a = cost33a([1 7 13 19 25])

cost44a = buildMatchingCost(si4, si4a, rule, distanceType);
xcost44a = cost44a([1 7 13 19 25])

cost55a = buildMatchingCost(si5, si5a, rule, distanceType);
xcost55a = cost55a([1 7 13 19 25])

xcc = [xcost11a;xcost22a; xcost33a; xcost44a; xcost55a]

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Koszty miêdzy 2 punktami zaznaczonymi przez cz³owieka na tej samej twarzy:
cost11 = buildMatchingCost(si1, si1, rule, distanceType)

cost22 = buildMatchingCost(si2, si2, rule, distanceType)

cost33 = buildMatchingCost(si3, si3, rule, distanceType)

cost44 = buildMatchingCost(si4, si4, rule, distanceType)

cost55 = buildMatchingCost(si5, si5, rule, distanceType)

%--------------------------------------------------------------------------
%Koszty dopasowañ miêdzy punktami nosa dla ró¿nych twarzy:

%czubek nosa:
prn = [si1(1,:); si2(1,:); si3(1,:); si4(1,:); si5(1,:) ];
autoPrn_Cost = buildMatchingCost(prn, prn, rule, distanceType)
prna  = [si1a(1,:); si2a(1,:); si3a(1,:); si4a(1,:); si5a(1,:) ];
autoPrna_Cost = buildMatchingCost(prna, prna, rule, distanceType)

%nasion:
n = [si1(2,:); si2(2,:); si3(2,:); si4(2,:); si5(2,:) ];
autoN_Cost = buildMatchingCost(n, n, rule, distanceType)

%lewy al:
lal = [si1(3,:); si2(3,:); si3(3,:); si4(3,:); si5(3,:) ];
autoLal_Cost = buildMatchingCost(lal, lal, rule, distanceType)

%prawy al:
ral = [si1(4,:); si2(4,:); si3(4,:); si4(4,:); si5(4,:) ];
autoRal_Cost = buildMatchingCost(ral, ral, rule, distanceType)

%subnasale:
sn = [si1(5,:); si2(5,:); si3(5,:); si4(5,:); si5(5,:) ];
autoSn_Cost = buildMatchingCost(sn, sn, rule, distanceType)

%LEWY AL vs PRAWY AL:
LalVsRal_Cost = buildMatchingCost(lal, ral, rule, distanceType)

%--------------------------------------------------------------------------

dataPath = 'patterns\punktyChar\cara1_frontal1_faceCutOut.txt';
maskPath = 'patterns\punktyChar\cara1_frontal1_faceCutOut.png';
outPath  = 'patterns\punktyChar\cara1_frontal1_faceCutOut_nose.txt';
[pts mask fpts] = loadAndStoreMarkedData2(dataPath, maskPath, outPath);

%--------------------------------------------------------------------------

[spinImgs selIxs] = getDescriptorSub(pts, mask, '', ...
    sum(mask), distance, ...
    alfaBins, betaBins, alfaAxes, betaAxes);

%--- 
%Dopasowanie prn:
options.matchingRule = rule;
options.matchingDistanceType = distanceType;
[no cost spinNo spinCost] = matchPoint(prn, spinImgs, options);

%ilustracja:
ix = 1;
hold on;guiDraw3d(fpts);scatter3(fpts(spinNo(ix),1), fpts(spinNo(ix),2), fpts(spinNo(ix),3), 90, 'g', '*' );
