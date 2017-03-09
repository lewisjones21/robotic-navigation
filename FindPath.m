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

%Find a path from the start waypoint to the target
% %(For now, search randomly until the target is found)
% searchIteration = 1;
% currentWaypoint = startWaypointIndex;
% while currentWaypoint ~= targetWaypointIndex && searchIteration < maxIterations
%     
%     waypointPath = [waypointPath, currentWaypoint];
%     %Find all edges connecting to the current waypoint (and rearrange such
%     %that the current waypoint is stored under the first index)
%     connectedEdges = [ edges(edges(:,1)==currentWaypoint,:); ...
%         [ edges(edges(:,2)==currentWaypoint,2), edges(edges(:,2)==currentWaypoint,1) ]];
%     %Move to a randomly selected connected waypoint
%     currentWaypoint = connectedEdges(randi(size(connectedEdges, 1), size(1)),2);
%     
%     searchIteration = searchIteration + 1;
%     
% end
% %Add the final (hopefully target) waypoint index to the end of the path
% waypointPath = [waypointPath, currentWaypoint];

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
    
%     %Find a list of waypoints connected to the current one
%     %(Switch the indices so the current waypoint is first)
%     connectedEdges = [ edges(edges(:,1) == currentWaypoint,:); ...
%                         edges(edges(:,2) == currentWaypoint,[ 2 1 ]) ];
%     connectedEdgeLengths = [ edgeLengths(edges(:,1) == currentWaypoint); ...
%                         edgeLengths(edges(:,2) == currentWaypoint) ];
%     
%     %Move to the next waypoint whose distance matches it's distance away
%     for c = 1:size(connectedEdges, 1)
%         if waypointDistances(connectedEdges(c,2)) ...
%                 == waypointDistances(connectedEdges(c,1)) ...
%                     - connectedEdgeLengths(c)
%             currentWaypoint = connectedEdges(c,2);
%             break;
%         end
%     end
    
    iteration = iteration + 1;
end

waypointPath = flip(waypointPath);


end

