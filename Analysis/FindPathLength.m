function [ pathLength ] = FindPathLength( pathWaypoints )
%FINDPATHLENGTH Returns the length of the path
%   

pathLength = 0;

for w = 2:size(pathWaypoints, 1)
    
    pathLength = pathLength + pdist([pathWaypoints(w,:); pathWaypoints(w-1,:)], 'euclidean');
    
end


end

