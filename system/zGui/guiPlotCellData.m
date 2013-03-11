function guiPlotCellData(args, cellVals, ixs)
%Rysuje kilka wykresów na jednej formatce. 
%Kolejne wartoœci dla wektora argumentów 'args' w komórkach 'cellVals'.
%Rysowane s¹ tylko zakresy nale¿¹ce do zbiorów indeksów 'ixs'.

colors = {'r', 'b', 'g', 'y', 'c', 'm', 'k'};

hold on;
for i=ixs
    plot(args, cellVals{i}, colors{ mod(i, 7)+1 });
    plot(args, cellVals{i}, [colors{ mod(i, 7)+1 } '.']);
end;    