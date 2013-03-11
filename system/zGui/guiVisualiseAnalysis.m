function guiVisualiseAnalysis(pts, face_Mask, nose_FaceMask,  ... 
    prn_FaceMask, n_FaceMask, sn_FaceMask, lal_FaceMask, ral_FaceMask)
%Wizualizuje wyniki analizy obrazu twarzy.

hold on;
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');


try
    guiDraw3d( pts(~face_Mask,:), 1, 'k');
catch 
end;   

try
    facePts = pts(face_Mask, :);
    guiDraw3d( facePts(~nose_FaceMask,:), 1, 'g');
catch 
end;    


try
    guiDraw3d( facePts(nose_FaceMask,:), 1);
catch 
end;    
    

try
    guiDraw3d( mean(facePts(prn_FaceMask,:)), 30, 'b', '*');
catch 
end;    

try
    guiDraw3d( mean(facePts(n_FaceMask,:)), 30, 'k', '*');
catch 
end;    

try
    guiDraw3d( mean(facePts(sn_FaceMask,:)), 30, 'k', '*');
catch 
end;    

try
    guiDraw3d( mean(facePts(lal_FaceMask,:)), 30, 'r', '*');
catch 
end;    

try
    guiDraw3d( mean(facePts(ral_FaceMask,:)), 30, 'r', '*');
catch 
end;    