function loadAndStoreMarkedData2Dir(dirPath, maskSuffix, outSuffix)
%Dla wszystkich plików w katalogu ³aduje plik oraz maskê. 
%Nastêpnie wycina z wczytanych danych punkty odpowiadaj¹ce masce i zapisuje je do pliku.

f = dir([dirPath '*.txt']);
noOfFiles = length(f);

for fileNo = 1:noOfFiles
	dataPath = [dirPath f(fileNo).name];
	maskPath = [dirPath f(fileNo).name maskSuffix];
	outPath  = [dirPath f(fileNo).name outSuffix];
	
	loadAndStoreMarkedData2(dataPath, maskPath, outPath);
end;    
