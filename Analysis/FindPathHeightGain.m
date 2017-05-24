function [ pathHeightGain ] = FindPathHeightGain( pathWaypoints )
%FINDHEIGHTGAIN Calculates the total climb of the path
%   Calculates the sum of the upwards travel of the path (as opposed to the
%   net change in height) - upwards moving segments contribute positively;
%   downward moving segments do not contribute

%Default the output
pathHeightGain = [];

%Validate inputs
if size(pathWaypoints, 1) <= 0
    warning('No path waypoints given');
    return;
end
if size(pathWaypoints, 2) ~= 3
    warning('Path waypoints not given in correct form');
    return;
end

%Check there are at least two waypoints, otherwise a height difference
%can't be found
if size(pathWaypoints, 1) <= 1
    pathHeightGain = 0;
    warning('Only one path waypoints given');
    return;
end

%For N points in pathWaypoints:
%Take the sum of the (N-1) values, where each value is the maximum of zero
% and the (N-1) height increases between (N) adjacent waypoints in the path
pathHeightGain = sum(max(0, pathWaypoints(2:size(pathWaypoints, 1),3) ...
    - pathWaypoints(1:size(pathWaypoints, 1) - 1,3)));


end

