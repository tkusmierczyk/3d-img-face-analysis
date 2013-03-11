function selIxs = getSeedPoints(pts, fractionOfSeedPoints)
% Selects index of points on which descriptors will be based.

selIxs = getSeedPointsNo(pts, round( size(pts,1)*fractionOfSeedPoints ) );