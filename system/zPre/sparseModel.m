function [pts_sparsed n_sparsed] = sparseModel(pts, n, sparse_times)
% Reduces matrix of points selecting 1 of each 'sparse times' rows.
% Zmniejsza macierz punktow wybierajac 1 z kazdych 'sparse times' wierszy.

sparse_indexes = 1: sparse_times: size(pts,1);
pts_sparsed = pts(sparse_indexes, :);    
n_sparsed = n(sparse_indexes, :);

