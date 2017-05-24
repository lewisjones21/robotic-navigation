function [ pathWaypointIndices, coordErrors ] = FindPath( waypoints, edges, coords )
%FINDPATH Generates a path from the specified waypoint to the target
%coordinates
%   Generates a path through the provided navigation network that passes
%   through the closest waypoints to the given coordinates

%Default the relevant outputs
pathWaypointIndices = [];
coordErrors = [];

%Validate the inputs
if size(waypoints, 1) <= 0
    warning('No waypoints given');
    return;
end
if size(waypoints, 2) ~= 3
    warning('Waypoints given in incorrect format');
    return;
end
if size(edges, 1) <= 0
    warning('No edges given');
    return;
end
if size(edges, 2) ~= 2
    warning('Edges given in incorrect format');
    return;
end
if size(coords, 1) <= 0
    warning('No coords given');
    return;
end
if size(coords, 2) ~= 3
    warning('Coords given in incorrect format');
    return;
end

%If more than 2 coordinates are given, the path must pass through
%intermediate points; routes for these are calculated recursively
if size(coords, 1) > 2
    [ priorWaypointPath, coordErrors ] ...
        = FindPath(waypoints, edges, coords(1:size(coords,1)-1,:));
    startCoords = coords(size(coords,1)-1,:);
    targetCoords = coords(size(coords,1),:);
else
    if size(coords, 1) == 2
        priorWaypointPath = [];
        coordErrors = [];
        startCoords = coords(1,:);
        targetCoords = coords(2,:);
    else
        error('Not enough coordinate given; path cannot be found.');
    end
end

arbitraryLargeValue = 10000;
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
%If this is the smallest sub-path in the coordinate chain, note the
%distance of the start waypoint from the specified start position
if size(priorWaypointPath, 1) == 0
    coordErrors = [ coordErrors; sqrt(bestDist2) ];
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
%Tally how far the target waypoint is from the specified target position
coordErrors = [ coordErrors; sqrt(bestDist2) ];

%Precalculate the lengths of all edges
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
    pathWaypointIndices = startWaypointIndex;
    warning('Target waypoint cannot be reached.')
else
    %Find the shortest path to the target waypoints, given waypoint distances
    iteration = 1;
    currentWaypoint = targetWaypointIndex;
    while iteration < maxIterations

        %Add the current waypoint to the path
        pathWaypointIndices = [pathWaypointIndices, currentWaypoint];

        if currentWaypoint == startWaypointIndex
            break;
        end

        currentWaypoint = waypointBacktrace(currentWaypoint);

        iteration = iteration + 1;
    end

    %Flip the path back to the correct direction
    pathWaypointIndices = flip(pathWaypointIndices);
end

%Prepend the path calculated for previous intermediate coordinates
pathWaypointIndices = [ priorWaypointPath, pathWaypointIndices ];

%Remove the path waypoints that are repeated at the end of each segment
repetitionIndices = [(pathWaypointIndices(1:size(pathWaypointIndices,2)-1) ...
    - pathWaypointIndices(2:size(pathWaypointIndices,2)) == 0), 0];
pathWaypointIndices = pathWaypointIndices(~repetitionIndices);



end

