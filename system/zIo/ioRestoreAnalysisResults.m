function [face_Mask, center_FaceMask, nose_FaceMask, noseNear_FaceMask, ... 
          leftNose_FaceMask, rightNose_FaceMask, ...
          prn_FaceMask, n_FaceMask, sn_FaceMask, lal_FaceMask, ral_FaceMask, ...
          prn, n, sn, lal, ral, ...
          costs, t] = ioRestoreAnalysisResults(path, pts)    
%Odczytuje wyniki analizy z pliku.       

face_Mask = logical( ioReadVector([path '_faceMask.txt'] ) );
center_FaceMask = logical( ioReadVector([path '_centerfaceMask.txt'] ) );
nose_FaceMask = logical( ioReadVector([path '_noseMask.txt'] ) );
noseNear_FaceMask = logical( ioReadVector([path '_nearnoseMask.txt'] ) );

leftNose_FaceMask = logical( ioReadVector([path '_leftnoseMask.txt'] ) );
rightNose_FaceMask = logical( ioReadVector([path '_rightnoseMask.txt'] ) );

prn_FaceMask = logical( ioReadVector([path '_prnMask.txt'] ) );
n_FaceMask = logical( ioReadVector([path '_nMask.txt'] ) );
sn_FaceMask = logical( ioReadVector([path '_snMask.txt'] ) );
lal_FaceMask = logical( ioReadVector([path '_lalMask.txt'] ) );
ral_FaceMask = logical( ioReadVector([path '_ralMask.txt'] ) );

costs = ( ioReadVector([path '_costs.txt'] ) );
t = ( ioReadVector([path '_time.txt'] ) );

if exist('pts', 'var')
    prn = mean( pts(prn_FaceMask, :) );
    n = mean( pts(n_FaceMask, :) );
    sn = mean( pts(sn_FaceMask, :) );
    lal = mean( pts(lal_FaceMask, :) );
    ral = mean( pts(ral_FaceMask, :) );    
end;    

try
   nosepts = ioLoad3dData([path '_pts.txt']);
  
   prn = nosepts(1,:);
   n = nosepts(2,:);
   sn = nosepts(3,:);
   lal = nosepts(4,:);
   ral = nosepts(5,:);
catch e
end;    