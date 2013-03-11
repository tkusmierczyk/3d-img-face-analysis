function [pts] = ioLoad3dData(filePath)
% [pts] = ioLoad3dData(filePath)
% Reads file of 3d points.
% Each row in format: [x y z]

try
    file =  fopen(filePath);
    pts = fscanf( file, '%f', [3 inf])';  
    fclose(file);
catch e
    error(['Failed opening ' filePath ': ' e.message]);
end;    

%Przemieszaj, bo w wejsciu sa jakies struktury: (ale z tym siê robi syf)
%pts = pts( randperm(size(pts,1)) , :);