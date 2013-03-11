function ptCluster = octClustering(pts, clustersNo)

ptCluster = double(pl.quark.cc.octClustering(...
    pts(:,1), pts(:,2), pts(:,3), clustersNo));