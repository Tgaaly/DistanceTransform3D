
voxels = zeros(14,14,14);
voxels(randi(14,2),randi(14,1),randi(14,2))=1;

dt3D = distanceTransform3D(voxels,1);