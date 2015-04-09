function [voxels] = distanceTransform3D(voxels, flag_debug)
% clear, close all
% voxels - binary voxels of size N x N x N
% voxel_cell_sz - size of each voxel, assuming cube voxels

%% setup space
voxels_orig=voxels;
xgv = linspace(-1.0,1.0,size(voxels,1));%-1.2:cell_sz:1.2;
ygv = linspace(-1.0,1.0,size(voxels,2));%-1.2:cell_sz:1.2;
zgv = linspace(-1.0,1.0,size(voxels,3));%:cell_sz:1.2;

ids_ones = find(voxels==1);
[v,u,zz] = ind2sub([length(xgv) length(ygv) length(zgv)], ids_ones);

%% compute voxel values
for x=1:length(xgv)
    for y=1:length(ygv)
        for z=1:length(zgv)
            d = dist2([x y z],[v(:),u(:),zz(:)]);
            [~,d_sorted_id]=sort(d,2);
            voxels(x,y,z) = d(d_sorted_id(1));%sqrt((D_x(14-y+1,z))^2 + (D_y(z,14-x+1))^2 + (D_z(y,14-x+1))^2);
        end
    end
end

%% normalize from 0 to 1
voxels = voxels ./ max(voxels(:));


%% display
if flag_debug==1
    if max(voxels(:))>0 && ~isinf(max(voxels(:)))
        figure(1), clf, hold on, 
        colors = parula(ceil(max(voxels(:))*100)+1);
        for x=1:length(xgv)
            for y=1:length(ygv)
                for z=1:length(zgv)
                    voxel_cell_sz = [xgv(x) ygv(y) zgv(z)];
                    voxel_cell_sz = voxel_cell_sz + voxel_cell_sz/2;
                    if voxels_orig(x,y,z)==1
                        plot3(voxel_cell_sz(1), voxel_cell_sz(2), voxel_cell_sz(3), 'r.', 'MarkerSize', 20);
                    else
                        plot3(voxel_cell_sz(1), voxel_cell_sz(2), voxel_cell_sz(3), '.', 'Color', colors(ceil(voxels(x,y,z)*100)+1,:), 'MarkerSize', 20);
                    end
                end
            end
        end
        xlabel('X') 
        ylabel('Y') 
        zlabel('Z') 
        hold off
    end
end

disp('computed 3d distance transform');

