function [ pathLength, directDistance, factorAboveDirect, ...
    projectedFactorAboveDirect ] ...
        = AnalysePathMinimal( pathWaypointIndices, ...
            waypoints, triangles, points, pathCoords, coordErrors )
%ANALYSEPATHMINIMAL Returns length data about the path
%   

%Default the relevant outputs
pathLength = [];
directDistance = [];
factorAboveDirect = [];
projectedFactorAboveDirect = [];

%Validate the path coord inputs
if size(pathCoords, 1) <= 0
    warning('No path coords given');
    return;
end
if size(pathCoords, 2) ~= 3
    warning('Path coords given in incorrect format');
    return;
end

%The total direct, Euclidean distance between successive pairs of path
%coords (minimum path length to pass through all path coords); the length
%of the path that was requested
directDistance = FindPathLength(pathCoords);


%Validate more inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end
if size(triangles, 1) <= 0
    warning('No triangles given');
    return;
end
if size(triangles, 2) ~= 3
    warning('Triangles given in incorrect format');
    return;
end
if size(waypoints, 1) <= 0
    warning('No waypoints given');
    return;
end
if size(waypoints, 2) ~= 3
    warning('Waypoints given in incorrect format');
    return;
end

%Abbreviate the indexing into the path
pathWaypoints = waypoints(pathWaypointIndices,:);


%The total Euclidean distance between successive pairs of path waypoints
%(length of the path through all path waypoints); the length of the path
%that was found
pathLength = FindPathLength(pathWaypoints);
%Find the length of the path if it were projected onto the z=0 plane (as in
%the Plane environment)
projectedPathLength = FindPathLength( ...
    [ pathWaypoints(:, 1:2), zeros(size(pathWaypoints, 1), 1) ]);

%Correct the path length to make it more representative
%   + the distance required at either end to reach the target coords
%	+ the distance required to reach the intermediate target coords and
%       then get back to the path to continue traversing it
pathLength = pathLength ...
    + sum(coordErrors([1, size(coordErrors, 1)])) ...
    + 2 * sum(coordErrors(2:size(coordErrors,1)-1));
%Also do this for the projected length
projectedPathLength = projectedPathLength ...
    + sum(coordErrors([1, size(coordErrors, 1)])) ...
    + 2 * sum(coordErrors(2:size(coordErrors,1)-1));

%The percentage by which the calculated path's length overshoots the
%minimum possible path length
factorAboveDirect = (pathLength - directDistance) / directDistance;
%Inf is acceptable here, as are negative values (sometimes the closest path
%waypoints don't quite reach the requested coords, so actually take a
%shorter route); -1 indicates zero path length (no path found)

%Find the equivalent value for the projected path length
projectedFactorAboveDirect = (projectedPathLength - directDistance) / directDistance;

end

