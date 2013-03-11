function [pts n u v] = ioRestore3dData(filePath)
% Reads file of 3d points.

data = load(filePath);

pts = data(:, [1 2 3]);
n = data(:, [4 5 6]);
u = data(:, [7 8 9]);
v = data(:, [10 11 12]);
