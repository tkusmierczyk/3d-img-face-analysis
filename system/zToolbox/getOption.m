function [optionValue] = getOption(options, fieldName, defaultValue)
%Zwraca wartoœæ opcji. Jeœli jest ona dostêpna w strukturze 'options'
%w polu 'fieldName' to jest to wartoœæ z tej struktury. 
%Jeœli nie zwracana jest wartoœæ domyœlna: 'defaultValue'.

if isfield(options, fieldName)
    optionValue = getfield(options, fieldName);
else
    optionValue = defaultValue;
end;
