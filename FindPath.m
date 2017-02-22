function [ waypointPath ] = FindPath( waypoints, edges, startWaypointIndex, targetCoords )
%FINDPATH Generates a path from the specified waypoint to the target
%coordinates
%   Generates a path through the provided navigation network from the
%   waypoint with the specified start index to the waypoint that is closest
%   to the given target coordinates

waypointPath = [];
maxIterations = 25;     %Set this as a failsafe; make it a function of graph size

%Find the target waypoint (the one closest to the target coordinates)
targetWaypointIndex = 1;
bestDist2 = 10000000;     %Arbitrary large value for waypoints to be closer than
for i = 1:size(waypoints, 1)
    dist2 = dot(waypoints(i,:), targetCoords);
    if dist2 < bestDist2
        dist2 = bestDist2;
        targetWaypointIndex = i;
    end
end

%Find a path from the start waypoint to the target
%(For now, search randomly until the target is found)
searchIteration = 1;
currentWaypointIndex = startWaypointIndex;
while currentWaypointIndex ~= targetWaypointIndex && searchIteration < maxIterations
    
    waypointPath = [waypointPath, currentWaypointIndex];
    %Find all edges connecting to the current waypoint (and rearrange such
    %that the current waypoint is stored under the first index)
    connectedEdges = [ edges(edges(:,1)==currentWaypointIndex,:); ...
        [ edges(edges(:,2)==currentWaypointIndex,2), edges(edges(:,2)==currentWaypointIndex,1) ]];
    %Move to a randomly selected connected waypoint
    currentWaypointIndex = connectedEdges(randi(size(connectedEdges, 1), size(1)),2);
    
    searchIteration = searchIteration + 1;
    
end
%Add the final (hopefully target) waypoint index to the end of the path
waypointPath = [waypointPath, currentWaypointIndex];

%Find a path from the start waypoint to the target
%(Using Djikstra's algorithm)
% currentWaypointIndex = startWaypointIndex;
% while
% 
% end



end

