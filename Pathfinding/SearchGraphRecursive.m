function [ waypointDistances, waypointBacktrace ] ...
    = SearchGraphRecursive( currentWaypoint, waypointDistances, ...
        waypointBacktrace, edgeLengths, waypoints, edges )
%SEARCHGRAPHRECURSIVE Checks the surrounding waypoints to see if this
%waypoint offers a shorter path to it
%   

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
if size(edgeLengths, 1) ~= size(edges, 1)
    warning('Incorrect number of edge lengths given');
    return;
end
if size(edgeLengths, 2) ~= 1
    warning('Edges given in incorrect format');
    return;
end
if size(waypointDistances, 1) ~= size(waypoints, 1)
    warning('Incorrect number of waypoint distances given');
    return;
end
if size(waypointDistances, 2) ~= 1
    warning('Waypoint distances given in incorrect format');
    return;
end

%Find a list of waypoints connected to the current one
%(Switch the indices so the current waypoint is first)
connectedEdges = [ edges(edges(:,1) == currentWaypoint,:); ...
                    edges(edges(:,2) == currentWaypoint,[ 2 1 ]) ];
connectedEdgeLengths = [ edgeLengths(edges(:,1) == currentWaypoint); ...
                    edgeLengths(edges(:,2) == currentWaypoint) ];

%Check if any connected waypoints are closer
shouldSearch = zeros(size(connectedEdges, 1), 1);
for c = 1:size(connectedEdges, 1)
    newDist = waypointDistances(connectedEdges(c,1)) ...
        + connectedEdgeLengths(c);
    if newDist < waypointDistances(connectedEdges(c,2)) ...
            || waypointDistances(connectedEdges(c,2)) < 0
        %A shorter path to waypoint(connectedEdges(c,2)) has been found
        waypointDistances(connectedEdges(c,2)) = newDist;
        waypointBacktrace(connectedEdges(c,2)) = connectedEdges(c,1);
        shouldSearch(c) = true;
    end
end

%For those waypoints that were closer, search them too
for c = 1:size(connectedEdges, 1)
    if shouldSearch(c) == true
        [waypointDistances, waypointBacktrace] = SearchGraphRecursive( ...
            connectedEdges(c,2), waypointDistances, waypointBacktrace, ...
            edgeLengths, waypoints, edges);
    end
end

end

