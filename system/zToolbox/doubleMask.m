function  [selIxs mask] = doubleMask(outerMask, innerMask, dataLength)
%Wybiera indeksy za pomoc¹ dwupoziomowej maski (wektorów bitowych lub
%list indeksów).
%
%Pierwsza maska wybiera elementy z danych wejœciowych. Jej rozmiar jest 
%równy datalenght. Druga maska wybiera elementy z danych wybranych
% przez pierwsz¹ (wstêpnie przefiltrowanych). Rozmiar drugiej maski
%jest równy liczbie indeksów wybranych przez pierwsz¹ maskê.
%
%Parametry:
% dataLength - rozmiar danych które s¹ maskowane.
%Zwracane:
% selIxs - indeksy danych wejœciowych które zosta³y wybrane
% mask - maska (wektor bitowy) danych wejœciowych wybieraj¹ca elementy. 
    
try
    %Wybranie indeksów:
    if isnumeric(outerMask) %indeksy :
        selIxs = outerMask;
    else %maska binarna:
        dataLength = length(outerMask);
        selIxs = find(outerMask);
    end;
    selIxs = selIxs(innerMask);

    %Zbudowanie maski:
    mask = zeros(dataLength, 1);
    mask(selIxs) = 1;
    mask = logical(mask);
    
catch e
    selIxs = [];
    mask = ones(dataLength, 0 ) == 0;
end;    