function [ pathLength, pathHeightGain, maxIncline, maxInclineChange, directDistance, factorAboveDirect ] ...
    = AnalysePath( pathWaypointsIndices, waypoints, waypointTriangles, triangles, points )
%ANALYSEPATH Returns various data (explained herein) about the path
%   

pathWaypoints = waypoints(pathWaypointsIndices,:);

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
for w = 1:size(pathWaypointsIndices, 1)
    maxIncline = max(maxIncline, FindTriangleIncline(waypointTriangles(pathWaypointsIndices(w),1), triangles, points));
    maxIncline = max(maxIncline, FindTriangleIncline(waypointTriangles(pathWaypointsIndices(w),2), triangles, points));
end

%The maximum change in incline faced when moving from one triangle to
%another (relevant for checking ground clearance for a robot, e.g. from its
%bumpers)
%### The below section is only correct assuming perpendicular approach to
%the edge (unlikely) and completely ignores the case of triangles that face
%each other ###
maxInclineChange = 0;
for w = 1:size(pathWaypointsIndices, 1)
    incline1 = FindTriangleIncline(waypointTriangles(pathWaypointsIndices(w),1), triangles, points);
    incline2 = FindTriangleIncline(waypointTriangles(pathWaypointsIndices(w),2), triangles, points);
    if incline1 >= 0 && incline2 >= 0
        maxInclineChange = max(maxInclineChange, incline1 - incline2, incline2 - incline1);
    end
end

%The direct, Euclidean distance from the start waypoint to the end waypoint
directDistance = pdist([pathWaypoints(1,:); pathWaypoints(size(pathWaypoints, 1),:)], 'euclidean');

%The percentage by which the calculated path's lenght overshoots the
%minimum Euclidean distance
factorAboveDirect = (pathLength - directDistance) / directDistance;        %Inf is acceptable here


end

