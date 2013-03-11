function [areas] = estimateModelsArea(models, noOfTestPts, referenceDistance)
%[areas] = estimateModelsArea(models)
%Estymuje powierzchniê modeli.
%Zwraca:
% areas - wektor estymowanych powierzchni modeli.

noOfModels	= length(models);
areas 		= zeros(noOfModels, 1);

for i = 1: noOfModels	
	areas(i) = estimateArea(models{i}, noOfTestPts, referenceDistance);
end;
