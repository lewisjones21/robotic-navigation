function [ maxIncline, maxFacedIncline, maxTroughAngle, maxRidgeAngle ] ...
    = FindPathInclines( pathWaypointIndices, waypointTriIndices, ...
        triangleInclines, waypoints, triangles, points )
%FINDPATHMAXINCLINE Finds the maximum incline of the path
%   Finds the steepest region of the path (maxIncline), which might pertain
%   to no actual uphill travel if the path traverses horizontally across
%	that region; this might be considered when determining the risk of the
%	robot slipping in any direction whilst traversing this path segment
%   
%   Also finds the steepest incline that is faced by the path
%   (maxFacedIncline), that is the steepest slope that the robot would have
%   to climb or descend in order to follow the path; this might be
%   considered when determining the risk of the robot slipping whilst
%   climbing this slope
%   
%   Also finds the sharpest trough angle; that is, the greatest positive
%   change in path incline; this might be considered when determining the
%   risk of bumpers extending beyond the robot wheelbase might catch on the
%   ground in this trough
%   
%   Also finds the sharpest ridge angle; that is, the greatest negative
%   change in path incline; this might be considered when determining the
%   risk of the robot base catching on the ground on this ridge


maxIncline = [];
maxFacedIncline = [];
maxTroughAngle = [];
maxRidgeAngle = [];


if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(triangles, 1) <= 0
    warning('No triangles given');
    return;
end
if size(waypoints, 1) <= 0
    warning('No waypoints given');
    return;
end
if size(pathWaypointIndices, 1) <= 0
    warning('No path waypoint indices given');
    return;
end
if size(waypointTriIndices, 1) <= 0
    warning('No waypoint triangle indices given');
    return;
end
if size(triangleInclines, 1) <= 0
    warning('No triangle inclines given');
    return;
end

%Find the inclines of all primary triangles in the 
pathTriangleInclines ...
    = triangleInclines(waypointTriIndices(pathWaypointIndices,1))

%Find the maximum incline
maxIncline = max(pathTriangleInclines);
%If the first or last waypoints lie on a sharedSide, the secondary triangle
%associated with those waypoints could have a greater incline, so check
if waypointTriIndices(pathWaypointIndices(1),2) > 0
    %The first waypoint is on a sharedSide
    maxIncline = max(maxIncline, FindTriangleInclines( ...
        triangles(waypointTriIndices(pathWaypointIndices(1),2),:), points));
end
if waypointTriIndices(pathWaypointIndices(size(pathWaypointIndices,1)),2) > 0
    %The first waypoint is on a sharedSide
    maxIncline = max(maxIncline, FindTriangleInclines( ...
        triangles(waypointTriIndices(pathWaypointIndices( ...
            size(pathWaypointIndices,1)),2),:), points));
end

%Find the direction vector of each path segment
d = waypoints(pathWaypointIndices(2:size(pathWaypointIndices, 2)), :) ...
    - waypoints(pathWaypointIndices(1:size(pathWaypointIndices, 2)-1), :);
%Find the angle between each direction vector and the horizontal plane
angles = atan2(d(:,3), sqrt(d(:,1).^2 + d(:,2).^2));
%atan2 effectively handles vertical path segments (although these shouldn't
%exist)

%Find the maximum incline
maxFacedIncline = max(angles);

%Find the changes in angle between path segments
angleDeltas = angles(2:size(angles, 1)) - angles(1:size(angles, 1) - 1);

%Find the maximum trough angle (positive change in slope: _/ or \/ shape)
maxTroughAngle = max(angleDeltas);
maxTroughAngleWaypointIndex = find(angleDeltas == maxTroughAngle) + 1;

%Find the maximum ridge angle (positive change in slope: ,- or /\ shape)
maxRidgeAngle = min(angleDeltas);
maxRidgeAngleWaypointIndex = find(angleDeltas == maxRidgeAngle) + 1;

end

