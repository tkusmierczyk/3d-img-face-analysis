function [assignment,cost] = matchDescriptors(costMatrix)
% function [assignment,cost] = matchDescriptors(costMatrix);
%
% Finds best assignment between two sets. 
% Matrix costMatrix is a matrix of assignment costs of every two points
% (one from first set, second from another set). 
% For every row number (index of an element from the first
% set) algorithm finds column number in the way that minimizes total
% assignment cost.

wbar = guiStartWaitBar(0, ['Matching ' num2str(size(costMatrix,1)) 'x' ...
   num2str(size(costMatrix,2)) ' descriptors...']);

[assignment,cost] = munkres(costMatrix);

guiStopWaitBar(wbar);