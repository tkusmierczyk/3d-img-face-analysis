function [occurences] = countOccurences(set, minValue, maxValue)
% Calculates how many times each of values between minValue & maxValue
% occurs in the set.

occurences = zeros(maxValue-minValue+1, 1);
for i = minValue:maxValue
   occurences(i-minValue+1) = sum( set==i );
end;
