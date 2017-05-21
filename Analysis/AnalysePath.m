function [ pathLength, pathHeightGain, maxIncline, maxInclineChange, ...
    directDistance, factorAboveDirect ] ...
        = AnalysePath( pathWaypointIndices, waypoints, ...
        waypointTriIndices, triangles, points, pathCoords )
%ANALYSEPATH Returns various data (explained herein) about the path
%   

pathWaypoints = waypoints(pathWaypointIndices,:);

pathLength = FindPathLength(pathWaypoints);

%Measures the total amount of upward vertical travel required to follow the
%path, ignoring how much downwards travel there may be (i.e. gauging how
%much extra energy will have to be put in, assuming energy cannot be
%recouped by travelling downhill)
pathHeightGain = 0;
for w = 2:size(pathWaypoints, 1)
    pathHeightGain = pathHeightGain + max(0, pathWaypoints(w,3) - pathWaypoints(w - 1,3));
end

%The maximum incline of any point on the path (currently this is distinct
%from the maximum incline that the path faces; travelling sideways across a
%steep area is easier than travelling directly up it)
maxIncline = 0;
for w = 1:size(pathWaypointIndices, 2)
    maxIncline = max(maxIncline, FindTriangleIncline( ...
        waypointTriIndices(pathWaypointIndices(w),1), ...
        triangles, points));
    if waypointTriIndices(pathWaypointIndices(w),2) > 0
        maxIncline = max(maxIncline, FindTriangleIncline( ...
            waypointTriIndices(pathWaypointIndices(w),2), ...
            triangles, points));
    end
end

%The maximum change in incline faced when moving from one triangle to
%another (relevant for checking ground clearance for a robot, e.g. from its
%bumpers)
%### The below section is only correct assuming perpendicular approach to
%the edge (unlikely) and completely ignores the case of triangles that face
%each other ###
maxInclineChange = 0;
for w = 1:size(pathWaypointIndices, 2)
    if waypointTriIndices(pathWaypointIndices(w),2) > 0
        incline1 = FindTriangleIncline( ...
            waypointTriIndices(pathWaypointIndices(w),1), ...
            triangles, points);
        incline2 = FindTriangleIncline( ...
            waypointTriIndices(pathWaypointIndices(w),2), ...
            triangles, points);
        if incline1 >= 0 && incline2 >= 0
            maxInclineChange = max(maxInclineChange, abs(incline1 - incline2));
        end
    end
end

%The total direct, Euclidean distance between successive pairs of path
%coords (minimum path length to pass through all path coords)
directDistance = sum(sqrt(sum(abs(pathCoords(1:size(pathCoords,1)-1,:) ...
    - pathCoords(2:size(pathCoords,1),:)).^2, 2)))
%The percentage by which the calculated path's length overshoots the
%minimum Euclidean distance
factorAboveDirect = (pathLength - directDistance) / directDistance;        %Inf is acceptable here


end

