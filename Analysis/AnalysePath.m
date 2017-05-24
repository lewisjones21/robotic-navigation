function [ pathLength, directDistance, factorAboveDirect, pathHeightGain, ...
    maxIncline, maxFacedIncline, maxTroughAngle, maxRidgeAngle ] ...
        = AnalysePath( pathWaypointIndices, waypointTriIndices, ...
        triangleInclines, waypoints, triangles, points, pathCoords )
%ANALYSEPATH Returns various data (explained herein) about the path
%   

%Default the relevant outputs
pathLength = [];
directDistance = [];
factorAboveDirect = [];
pathHeightGain = [];
maxIncline = [];
maxFacedIncline = [];
maxTroughAngle = [];
maxRidgeAngle = [];

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
if size(triangleInclines, 1) ~= size(triangles, 1)
    warning('Incorrect number of triangle inclines given');
    return;
end
if size(triangleInclines, 2) ~= 1
    warning('Triangle inclines given in incorrect format');
    return;
end
if size(pathWaypointIndices, 1) <= 0
    warning('No path waypoint indices given');
    return;
end
if size(pathWaypointIndices, 2) ~= 1
    warning('Path waypoint indices given in incorrect format');
    return;
end
if size(waypointTriIndices, 1) ~= size(waypoints, 1)
    warning('Incorrect number of waypoint triangle indices given');
    return;
end
if size(waypointTriIndices, 2) ~= 2
    warning('Waypoint triangle indices given in incorrect format');
    return;
end

%Abbreviate the indexing into the path
pathWaypoints = waypoints(pathWaypointIndices,:);


%The total Euclidean distance between successive pairs of path waypoints
%(length of the path through all path waypoints); the length of the path
%that was found
pathLength = FindPathLength(pathWaypoints);

%Measures the total amount of upward vertical travel required to follow the
%path, ignoring how much downwards travel there may be (i.e. gauging how
%much extra energy will have to be put in, assuming energy cannot be
%recouped by travelling downhill)
pathHeightGain = FindPathHeightGain(pathWaypoints);

%Analyse the different incline characteristics of the path
[maxIncline, maxFacedIncline, maxTroughAngle, maxRidgeAngle] ...
    = FindPathInclines(pathWaypointIndices, waypointTriIndices, ...
        triangleInclines, waypoints, triangles, points);

%The percentage by which the calculated path's length overshoots the
%minimum possible path length
factorAboveDirect = (pathLength - directDistance) / directDistance;
%Inf is acceptable here, as are negative values (sometimes the closest path
%waypoints don't quite reach the requested coords, so actually take a
%shorter route); -1 indicates zero path length (no path found)


end

