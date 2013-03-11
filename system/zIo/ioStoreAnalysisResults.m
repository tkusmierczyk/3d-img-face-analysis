function ioStoreAnalysisResults(path, ...
          face_Mask, center_FaceMask, nose_FaceMask, noseNear_FaceMask, ... 
          leftNose_FaceMask, rightNose_FaceMask, ...
          prn_FaceMask, n_FaceMask, sn_FaceMask, lal_FaceMask, ral_FaceMask, ...
          prn, n, sn, lal, ral, ...
          costs, t)
%Zapisuje wyniki analizy. 

ioStoreVectorSafe([path '_faceMask.txt'], double(face_Mask));
ioStoreVectorSafe([path '_centerfaceMask.txt'], double(center_FaceMask));
ioStoreVectorSafe([path '_noseMask.txt'], double(nose_FaceMask));
ioStoreVectorSafe([path '_nearnoseMask.txt'], double(noseNear_FaceMask));

ioStoreVectorSafe([path '_leftnoseMask.txt'], double(leftNose_FaceMask));
ioStoreVectorSafe([path '_rightnoseMask.txt'], double(rightNose_FaceMask));

ioStoreVectorSafe([path '_prnMask.txt'], double(prn_FaceMask));
ioStoreVectorSafe([path '_nMask.txt'], double(n_FaceMask));
ioStoreVectorSafe([path '_snMask.txt'], double(sn_FaceMask));
ioStoreVectorSafe([path '_lalMask.txt'], double(lal_FaceMask));
ioStoreVectorSafe([path '_ralMask.txt'], double(ral_FaceMask));

ioStoreVectorSafe([path '_costs.txt'], double(costs));
ioStoreVectorSafe([path '_time.txt'], double(t));

try
    ioStore3dRawData([path '_pts.txt'], [prn; n; sn; lal; ral]);
catch e
end;    