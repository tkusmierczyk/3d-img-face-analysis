function [spinImage selIxs] = ioRestoreModelDescriptor(filePath)
% Reads spin images table from the file.

try
    data = load(filePath);

    selIxs = data(:,1);
    spinImage = data(:, 2:size(data,2) );
catch e
     error(['Failed opening ' filePath ': ' e.message]);
end;    
