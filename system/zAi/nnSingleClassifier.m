function net = nnSingleClassifier(seedData, labels, mins, maxs, options)
%Tworzy klasyfikator w postaci sieci neuronowej. 
%Parametry:
% seedData - dane ucz¹ce
% labels - klasy
% mins/maxs - przedzia³y danych ucz¹cych
%Zwracane: 
% net - obiekt sieci neuronowej

%--------------------------------------------------------------------------

%Liczba ukrytych neuronów:
hiddenNeurons = getOption(options, 'hiddenNeurons', 5);
%Epoki uczenia wsteczn¹ propagacj¹ b³êdów:
bpEpochs = getOption(options, 'bpEpochs', 250);
%Epoki uczenia metod¹ L-M:
lmEpochs = getOption(options, 'lmEpochs', 100); 

%--------------------------------------------------------------------------

%budowa sieci:
net = newff([mins' maxs'], [hiddenNeurons 1], {'logsig' 'logsig'} );
net = init(net);
net = teachNetwork(net, seedData', labels', bpEpochs, lmEpochs, 0.0001);

%--------------------------------------------------------------------------

