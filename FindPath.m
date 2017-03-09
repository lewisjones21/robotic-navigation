function [ waypointPath ] = FindPath( waypoints, edges, startCoords, targetCoords )
%FINDPATH Generates a path from the specified waypoint to the target
%coordinates
%   Generates a path through the provided navigation network from the
%   waypoint with the specified start index to the waypoint that is closest
%   to the given target coordinates

arbitraryLargeValue = 10000;

waypointPath = [];
maxIterations = size(waypoints, 1) + 10;     %Set this as a failsafe

%Find the start waypoint (the one closest to the start coordinates)
startWaypointIndex = 1;
%Set an arbitrary large value for waypoints to be closer than
bestDist2 = arbitraryLargeValue;
for i = 1:size(waypoints, 1)
    diff = waypoints(i,:) - startCoords;
    dist2 = dot(diff, diff);
    if dist2 < bestDist2
        bestDist2 = dist2;
        startWaypointIndex = i;
    end
end

%Find the target waypoint (the one closest to the target coordinates)
targetWaypointIndex = 1;
%Set an arbitrary large value for waypoints to be closer than
bestDist2 = arbitraryLargeValue;
for i = 1:size(waypoints, 1)
    diff = waypoints(i,:) - targetCoords;
    dist2 = dot(diff, diff);
    if dist2 < bestDist2
        bestDist2 = dist2;
        targetWaypointIndex = i;
    end
end

%Precalculate the length of all edges
edgeLengths = zeros(size(edges, 1), 1);
for e = 1:size(edges, 1)
    edgeLengths(e) = norm(waypoints(edges(e,1),:) - waypoints(edges(e,2),:));
end

%Find a path from the start waypoint to the target
%(Using Dijkstra's algorithm)
%Initialise distance tracker
waypointDistances = -ones(size(waypoints, 1), 1);
%Initialise route tracker
waypointBacktrace = zeros(size(waypoints, 1), 1);
%Find the shortest path to any waypoint
waypointDistances(startWaypointIndex) = 0;
[waypointDistances, waypointBacktrace] = SearchGraphRecursive( ...
    startWaypointIndex, waypointDistances, waypointBacktrace, ...
    edgeLengths, waypoints, edges);

%Check the target is in this navigation graph
if waypointBacktrace(targetWaypointIndex) == 0
    %The target wasn't found in this navigation graph, so is unreachable
    %Return the start waypoint as the path
    waypointPath = startWaypointIndex;
    warning('Target waypoint cannot be reached.')
    return;
end

%Find the shortest path to the target waypoints, given waypoint distances
iteration = 1;
currentWaypoint = targetWaypointIndex;
while iteration < maxIterations
    
    %Add the current waypoint to the path
    waypointPath = [waypointPath, currentWaypoint];
    
    if currentWaypoint == startWaypointIndex
        return;
    end
    
    currentWaypoint = waypointBacktrace(currentWaypoint);
    
    iteration = iteration + 1;
end

waypointPath = flip(waypointPath);


end

