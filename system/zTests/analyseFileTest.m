
%czêœæ podkwykonawcza skryptu: analysisTest
%Dokonuje testu dla pojedynczego pliku:
%Parametry: katalog:dirPath, nazwa pliku:fileName, punkty: prn, n, sn,
%lal, ral

%zbudowanie œcie¿ek:
filePath = [dirPath fileName];
resultsPath  = [dirPath 'results\' fileName];
snapshotPath = [dirPath fileName '_ana_snap.png'];
faceMaskPath = [dirPath 'faceMask\' fileName '.png'];
noseMaskPath = [dirPath 'noseMask\' fileName '.png']; 

%-------------------------

%za³adowanie dnaych:
pts = ioLoad3dData(filePath);

%{
%wykonanie analizy dnaych:
fprintf('Processing: %s \n', fileName);
[face_Mask center_FaceMask nose_FaceMask noseNear_FaceMask ... 
 leftNose_FaceMask rightNose_FaceMask ...
 prn_FaceMask n_FaceMask sn_FaceMask lal_FaceMask ral_FaceMask ...
 cprn cn csn clal cral ...
 costs t] = faceAnalysis(pts);

%zapisanie danych:
ioStoreAnalysisResults(resultsPath, ...
          face_Mask, center_FaceMask, nose_FaceMask, noseNear_FaceMask, ... 
          leftNose_FaceMask, rightNose_FaceMask, ...
          prn_FaceMask, n_FaceMask, sn_FaceMask, lal_FaceMask, ral_FaceMask, ...
          cprn, cn, csn, clal, cral, ...
          costs, t);
%}      
      
%odczytanie danych:      
[face_Mask, center_FaceMask, nose_FaceMask, noseNear_FaceMask, ... 
 leftNose_FaceMask, rightNose_FaceMask, ...
 prn_FaceMask, n_FaceMask, sn_FaceMask, lal_FaceMask, ral_FaceMask, ...
 cprn cn csn clal cral ...
 costs, t] = ioRestoreAnalysisResults(resultsPath, pts);


%{
%snapshot:      
figure;      
guiVisualiseAnalysis(pts, face_Mask, nose_FaceMask,  ... 
    prn_FaceMask, n_FaceMask, sn_FaceMask, lal_FaceMask, ral_FaceMask);
%xlabel('x [mm]'); ylabel('y [mm]'); 
f = getframe;
imwrite(f.cdata, snapshotPath);  
%close gcf;
%}   

%-------------------------

%za³adowanie masek:
[pts faceMaskPattern facePts] = loadMarkedData2(filePath, faceMaskPath);
[pts noseMaskPattern nosePts] = loadMarkedData2(filePath, noseMaskPath);

%zapisanie plikow:
%ioStore3dRawData( [filePath '_face.txt'], pts(faceMaskPattern,:) );
%ioStore3dRawData( [filePath '_nose.txt'], pts(noseMaskPattern,:) );

%maski - otoczenie punktu [mm]:
%%{
ptNeighbourhood = 5; 
[neighbors prnMaskPattern]	= getNeighbours(prn, ptNeighbourhood, pts);
[neighbors nMaskPattern]	= getNeighbours(n, ptNeighbourhood, pts);
[neighbors lalMaskPattern]	= getNeighbours(lal, ptNeighbourhood, pts);
[neighbors ralMaskPattern]	= getNeighbours(ral, ptNeighbourhood, pts);
[neighbors snMaskPattern]	= getNeighbours(sn, ptNeighbourhood, pts);
%%}

%modyfikacja masek:
[ixs center_Mask] = doubleMask(face_Mask, center_FaceMask);
[ixs nose_Mask]   = doubleMask(face_Mask, nose_FaceMask);
[ixs noseNear_Mask] = doubleMask(face_Mask, noseNear_FaceMask);
[ixs leftNose_Mask] = doubleMask(face_Mask, leftNose_FaceMask);
[ixs rightNose_Mask] = doubleMask(face_Mask, rightNose_FaceMask);

[ixs prn_Mask] = doubleMask(face_Mask, prn_FaceMask);
[ixs n_Mask] = doubleMask(face_Mask, n_FaceMask);
[ixs sn_Mask] = doubleMask(face_Mask, sn_FaceMask);
[ixs lal_Mask] = doubleMask(face_Mask, lal_FaceMask);
[ixs ral_Mask] = doubleMask(face_Mask, ral_FaceMask);

%-------------------------------------------------------------------------

% analiza wyciêcia twarzy:
%{
[tp tn fp fn] = compareBinaryMasks(faceMaskPattern, face_Mask);
accuracy    = (tp+tn)/(tp + tn + fp + fn);
precision   = tp/(tp+fp);
recall      = tp/(tp+fn);
f1          = 2 * precision * recall / (precision + recall);
fprintf('%i %i  %i %i  \t  %.4f %.4f  %.4f %.4f \n', tp, tn, fp, fn,  accuracy, precision, recall, f1);
%}

%analiza czasu wykonania od liczby punktów:
%fprintf('%d  %.4f  %.4f %.4f   %.4f %.4f    %.4f %.4f %.4f   %.4f   %.4f %.4f \n', ...
%        size(pts,1), sum(t(t~=inf)) ,t(1), t(2), t(3), t(4), t(5), t(6), t(7), t(8), t(9), t(10));

%koszty dopasowania
%fprintf('koszty: %.4f %.4f    %.4f %.4f %.4f %.4f %.4f \n',...
%        costs(1), costs(2), costs(3), costs(4), costs(5), costs(6), costs(7));
    
%jaka czêœæ nosa zmieœci³a siê w centralnej czêœci twarzy:
%[tp tn fp fn] = compareBinaryMasks(noseMaskPattern, center_Mask);
%fprintf('ulamekNosaWCentrum:\t %.4f \n', tp/sum(noseMaskPattern) );

%analiza wyciêcia nosa w twarzy
%[tp tn fp fn] = compareBinaryMasks(subMask(faceMaskPattern, noseMaskPattern),...
%                                   subMask(faceMaskPattern, noseNear_Mask) );
%accuracy    = (tp+tn)/(tp + tn + fp + fn);
%precision   = tp/(tp+fp);
%recall      = tp/(tp+fn);
%f1          = 2 * precision * recall / (precision + recall);
%fprintf('%i %i  %i %i  \t  %.4f %.4f  %.4f %.4f \n', tp, tn, fp, fn,  accuracy, precision, recall, f1);

%odleg³oœci centroidów twarzy:
%cpattern = getCentroid(pts(faceMaskPattern,:));
%cmask = getCentroid(pts(face_Mask,:));
%fprintf('%.4f \n', dist(cpattern,cmask) );

%odleg³oœci centroidów nosów:
%cpattern = getCentroid(pts(noseMaskPattern,:));
%cmask = getCentroid(pts(nose_Mask,:));
%fprintf('%.4f \n', dist(cpattern,cmask) );

%{
%obliczenie ile punktów na nosie siê mieœci w danych uznanych za nos:
prnds   = getDistances(prn, pts(noseNear_Mask,:) );
nds     = getDistances(n, pts(noseNear_Mask,:) );
snds    = getDistances(sn, pts(noseNear_Mask,:) );
lalds   = getDistances(lal, pts(noseNear_Mask,:) );
ralds   = getDistances(ral, pts(noseNear_Mask,:) );
fprintf('%.4f %.4f %.4f  %.4f %.4f \n', min(prnds), min(nds), min(snds), min(lalds), min(ralds) );
%}

%{
%jaki u³amek otoczenia punktów na nosie jest w punktach uznanych za nos:
no1 = sum(prnMaskPattern & noseNear_Mask) / sum(prnMaskPattern);
no2 = sum(nMaskPattern & noseNear_Mask) / sum(nMaskPattern);
no3 = sum(snMaskPattern & noseNear_Mask) / sum(snMaskPattern);
no4 = sum(lalMaskPattern & noseNear_Mask) / sum(lalMaskPattern);
no5 = sum(ralMaskPattern & noseNear_Mask) / sum(ralMaskPattern);
fprintf('%.4f %.4f %.4f  %.4f %.4f \n', no1, no2, no3, no4, no5);
%}

%{
% analiza wyciêcia punktów:
[tp tn fp fn] = compareBinaryMasks(nMaskPattern, n_Mask);
accuracy    = (tp+tn)/(tp + tn + fp + fn);
precision   = tp/(tp+fp);
recall      = tp/(tp+fn);
f1          = 2 * precision * recall / (precision + recall);
fprintf('%i %i  %i %i  \t  %.4f %.4f  %.4f %.4f \n', tp, tn, fp, fn,  accuracy, precision, recall, f1);
%}

%{
%odleg³oœci centroidów punktów:
cpattern = ral;
cmask = getCentroid(pts(ral_Mask,:));
fprintf('%.4f \n', dist(cpattern,cmask) );
%}

%weryfikacja statystyczna:
[height length width heightSnPrn wl wr ...
 heightP lengthP widthP heightSnPrnP wlP wrP...
 sex vaildDist vaildPt] = ...
 noseDistances(prn, n, sn, lal, ral);
fprintf('%.2f %.2f %.2f %.2f %.2f %.2f   %.4f %.4f %.4f %.4f %.2f %.2f  %c  %s\n', ...
    height, length, width, heightSnPrn, wl, wr, ...
    heightP, lengthP, widthP, heightSnPrnP, wlP, wrP, ...
    sex, fileName);      
fprintf('%i %i %i %i %i %i\n', vaildDist(1),vaildDist(2),vaildDist(3),vaildDist(4),vaildDist(5),vaildDist(6) );
fprintf('%i %i %i %i %i\n', vaildPt(1),vaildPt(2),vaildPt(3),vaildPt(4),vaildPt(5) );
      

%{
%obliczenie wskaŸników:

fprintf('----------------------\n');

% informacja o wejœciu:
fprintf('%s:  %i  %i %i  %i %i %i %i %i \n', fileName, size(pts,1), ...
    sum(faceMaskPattern), sum(noseMaskPattern), ...
    sum(prnMaskPattern), sum(nMaskPattern), sum(lalMaskPattern), ...
    sum(ralMaskPattern), sum(snMaskPattern) );

%czasy wykonania:
fprintf('czasy(%.2f): %.4f %.4f   %.4f %.4f    %.4f %.4f %.4f   %.4f   %.4f %.4f \n',...
             sum(t) ,t(1), t(2), t(3), t(4), t(5), t(6), t(7), t(8), t(9), t(10));
         
%koszty dopasowania
fprintf('koszty: %.4f %.4f    %.4f %.4f %.4f %.4f %.4f \n',...
        costs(1), costs(2), costs(3), costs(4), costs(5), costs(6), costs(7));

%--------------    
    
% wyciêcie twarzy:
[tp tn fp fn] = compareBinaryMasks(faceMaskPattern, face_Mask);
fprintf('twarz:\t %i %i  %i %i \n', tp, tn, fp, fn);

% wyciêcie nosa:
[tp tn fp fn] = compareBinaryMasks(noseMaskPattern, nose_Mask);
fprintf('nosWScenie:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(subMask(faceMaskPattern, noseMaskPattern),...
                                   subMask(faceMaskPattern, nose_Mask) );
fprintf('nosWTwarzy:\t %i %i  %i %i \n', tp, tn, fp, fn);

% wyciêcie nosa poszerzonego:
[tp tn fp fn] = compareBinaryMasks(noseMaskPattern, noseNear_Mask);
fprintf('nosPWScenie:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(subMask(faceMaskPattern, noseMaskPattern),...
                                   subMask(faceMaskPattern, noseNear_Mask) );
fprintf('nosPWTwarzy:\t %i %i  %i %i \n', tp, tn, fp, fn);

% jaka czêœæ znalezionych regionów pokrywa siê z otoczeniem oznaczonych pktów:
[tp tn fp fn] = compareBinaryMasks(prnMaskPattern, prn_Mask);
fprintf('prnWScenie:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(nMaskPattern, n_Mask);
fprintf('nWScenie:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(lalMaskPattern, lal_Mask);
fprintf('lalWScenie:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(ralMaskPattern, ral_Mask);
fprintf('ralWScenie:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(snMaskPattern, sn_Mask);
fprintf('snWScenie:\t %i %i  %i %i \n', tp, tn, fp, fn);

[tp tn fp fn] = compareBinaryMasks(subMask(noseMaskPattern,prnMaskPattern),...
    subMask(noseMaskPattern,prn_Mask));
fprintf('prnWTwarzy:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(subMask(noseMaskPattern,nMaskPattern),...
    subMask(noseMaskPattern,n_Mask));
fprintf('nWSTwarzy:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(subMask(noseMaskPattern,lalMaskPattern),...
    subMask(noseMaskPattern,lal_Mask));
fprintf('lalWTwarzy:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(subMask(noseMaskPattern,ralMaskPattern),...
    subMask(noseMaskPattern,ral_Mask));
fprintf('ralWTwarzy:\t %i %i  %i %i \n', tp, tn, fp, fn);
[tp tn fp fn] = compareBinaryMasks(subMask(noseMaskPattern,snMaskPattern),...
    subMask(noseMaskPattern,sn_Mask));
fprintf('snWTwarzy:\t %i %i  %i %i \n', tp, tn, fp, fn);

% odleg³oœci miêdzy punktami:
fprintf('odlPunktow:\t %.2f %.2f %.2f %.2f %.2f \n', ...
    dist(prn,cprn), dist(n, cn), dist(lal, clal), ...
    dist(ral, cral), dist(sn, csn) );

%-------------------------------------------------------------------------
%}


