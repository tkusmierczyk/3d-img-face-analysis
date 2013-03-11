function [features evec] = pca(features, comp_count)
% features - cechy (w wierszach kolejne probki, w kolumnach cechy)
% comp_count do ilu cech zredukowac

    evec = getPcaVec(features);     %wektory wlasne
	trmx = evec(:, 1:comp_count);	%macierz konwersji
	features = features * trmx;		%rzutowanie do podprzestrzeni

end
