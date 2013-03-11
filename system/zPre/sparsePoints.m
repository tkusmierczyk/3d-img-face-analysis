function [pt_sparsed] = sparsePoints(pt, sparse_times)
% Reduces matrix of points selecting 1 of each 'sparse times' rows.
% Zmniejsza macierz punktow wybierajac 1 z kazdych 'sparse times' wierszy.

sparse_indexes = [1: sparse_times: size(pt,1)];
pt_sparsed = pt(sparse_indexes, :);    
    
end