function pts = reduceDataSize(pts, outSize)

perm = randperm( size(pts,1) );
pts = pts( perm( 1:min([outSize size(pts,1)]) ), : );