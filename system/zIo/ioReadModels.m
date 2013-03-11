function [models, descriptors] = ioReadModels(modelFiles, descFiles)
%[models, descriptors] = ioReadModels(modelFiles, descFiles)
%Wczytuje z plików zestaw modeli wraz z deskryptorami.
%Parametry:
% modelFiles - komórki zawieraj¹ce œcie¿ki modeli do wczytania.
% descFiles - komórki zawieraj¹ce œcie¿ki odpowiadaj¹cych modelom deskryptorów.
%Zwracane:
% models - komórki zawieraj¹ce modele.
% descriptors - komórki zawieraj¹ce deskryptory modeli.

noOfModels 	= length(modelFiles);
models 		= cell(noOfModels, 1);
descriptors	= cell(noOfModels, 1);

for i = 1: noOfModels	
	models{i} 		= ioLoad3dData( modelFiles{i} );
	descriptors{i} 	= ioRestoreModelDescriptor( descFiles{i} );
end;
