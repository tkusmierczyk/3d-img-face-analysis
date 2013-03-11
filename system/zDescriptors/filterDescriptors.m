function [h k] = filterDescriptors(spin1, spin2, rule)
% [h k] = filterDescriptors(h, k, rule)
%
% Filters bins in two descriptor using AND/OR - rule
% Parameters:
%  spin1, spin2 - single histograms
%  rule - 'AND'/'OR'/'NONE'

%Wybór indeksów:
switch rule
    case 'AND' %(oba musza byc rozne od 0)
        nonZeroIxs = spin1(:)~=0 & spin2(:)~=0; 
        
    case  'OR' %(jedno rozne od 0)
        nonZeroIxs = spin1(:)~=0 | spin2(:)~=0;
        
    case 'NONE'
        nonZeroIxs = ones( length(spin1), 1) == 1;
        
    otherwise 
        error('Illegal `rule` value (OR/NONE/AND allowed) !');
end; %switch

%Przefiltorwanie:
h = spin1(nonZeroIxs);
k = spin2(nonZeroIxs);



%        if strcmp(rule, 'AND')
%            nonZeroIxs = spin1(:)~=0 & spin2(:)~=0; %AND rule (oba musza byc rozne od 0)
%        elseif strcmp(rule, 'OR')
%            nonZeroIxs = spin1(:)~=0 | spin2(:)~=0; %OR rule (jedno rozne od 0)
%        elseif strcmp(rule, 'NONE')
%            nonZeroIxs = ones( length(spin1), 1) == 1;
%        else
%            error('Rule parameter must be either equal to AND or to OR.');
%        end;
        
