function [ pathLength, directDistance, factorAboveDirect, pathHeightGain, ...
    maxIncline, maxFacedIncline, maxTroughAngle, maxRidgeAngle ] ...
        = AnalysePath( pathWaypointIndices,   waypointTriIndices, ...
        triangleInclines, waypoints, triangles, points, pathCoords )
%ANALYSEPATH Returns various data (explained herein) about the path
%   

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



%The total direct, Euclidean distance between successive pairs of path
%coords (minimum path length to pass through all path coords); the length
%of the path that was requested
directDistance = FindPathLength(pathCoords);

%The percentage by which the calculated path's length overshoots the
%minimum possible path length
factorAboveDirect = (pathLength - directDistance) / directDistance;
%Inf is acceptable here, as are negative values (sometimes the closest path
%waypoints don't quite reach the requested coords, so actually take a
%shorter route); -1 indicates zero path length (no path found)


end

