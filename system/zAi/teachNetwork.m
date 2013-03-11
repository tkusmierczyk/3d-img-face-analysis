function [net] = teachNetwork(net, teachSet, teachLabels, ...
    bpEpochs, lmEpochs, precision)
%[Aproksymacja funkcji jednej zmiennej]
%Uczy siec net wykorzystujac zbior uczacy teachSet metodami:
% 1) wstecznej propagacji, bpEpochs epok
% 2) Levenberga-Marquardta, lmEpochs epok
% z precyzja precision
% zwraca nauczona siec

    %uczenie wsteczna propagacja bledu
    net.trainFcn            = 'traingd';
    net.trainParam.goal     = precision;
    net.trainParam.epochs   = bpEpochs;
    net.trainParam.show     = NaN;
    net.trainParam.showWindow = false;
    net.trainParam.showCommandLine = false;
    net = train(net, teachSet, teachLabels );
    %pause(5)

    %uczenie algorytmem levenberga-marquardta
    net.trainFcn            = 'trainlm';
    net.trainParam.goal     = precision;
    net.trainParam.epochs   = lmEpochs;
    net.trainParam.show     = NaN;
    net.trainParam.showWindow = false;
    net.trainParam.showCommandLine = false;
    net = train(net, teachSet, teachLabels );
    %pause(5)
end
