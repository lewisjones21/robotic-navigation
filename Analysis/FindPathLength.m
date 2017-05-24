function [ pathLength ] = FindPathLength( pathWaypoints )
%FINDPATHLENGTH Returns the length of the path
%   


pathLength = [];

if size(pathWaypoints, 1) <= 0
    warning('No path waypoints given');
    return;
end

%For N points in pathWaypoints:
%Take the sum of the (N-1) sqrts of the (N-1) squared differences between
%(N) adjacent waypoints in the path
pathLength = sum(sqrt(sum(abs(pathWaypoints(1:size(pathWaypoints,1)-1,:) ...
    - pathWaypoints(2:size(pathWaypoints,1),:)).^2, 2)));

end

