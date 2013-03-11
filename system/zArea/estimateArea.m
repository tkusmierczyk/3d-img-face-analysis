function [estimatedArea ptsDensity] = estimateArea ...
    (pts, noOfTestPts, referenceDistance)
%Estymuje powierzchniê modelu.
%Parametry:
% pts - punkty modelu w wierszach (x,y,z)
% noOfTestPts - dla ilu punktów dokonuje siê estymaty gêstoœci powierzchniowej.
% referenceDistance - promieñ s¹siedztwa dla jakiego 
% 	dokonuje siê estymaty gêstoœci powierzchniowej modelu. 

	
ptsDensity = estimatePtsDensity(pts, noOfTestPts, referenceDistance);
estimatedArea = size(pts,1) / ptsDensity;