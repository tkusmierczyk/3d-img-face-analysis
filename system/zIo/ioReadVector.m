function v = ioReadVector(filePath)
%Reads vector from file.

try
    file =  fopen(filePath);
    v = fscanf( file, '%f', [1 inf])';  
    fclose(file);
catch e
    error(['Failed opening ' filePath ': ' e.message]);
end;    
