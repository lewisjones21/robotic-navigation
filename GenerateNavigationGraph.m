function [ waypoints, edges, waypointTriangles ] = GenerateNavigationGraph(triangles, points, sharedSides)
%GENERATENAVIGATIONGRAPH Places waypoints on the triangles in relevant places
%   Places waypoints across the mesh defined by the triangles such that they
%   cover the traversable area to a suitable spatial resolution. Also
%   defines traversable edges between the waypoints.

%Define the waypoint matrix as a list of (X, Y, Z) coordinate triplets
%waypoints = zeros(size(triangles, 1), 3);

%Place a waypoint at the centre of each triangle
waypoints = [points(triangles(:,1),1) + points(triangles(:,2),1) + points(triangles(:,3),1), ...
            points(triangles(:,1),2) + points(triangles(:,2),2) + points(triangles(:,3),2), ...
            points(triangles(:,1),3) + points(triangles(:,2),3) + points(triangles(:,3),3)] / 3;

%Also record which triangles the waypoints are associated with
%For these triangles:
%[first triangle, second triangle]
%               = [incremental indices, -1 (no triangle)]
waypointTriangles = [cumsum(ones(size(triangles, 1), 1)), -1 * ones(size(triangles, 1), 1)];

edges = [];%This can only be accurately populated if sharedSides is given

if nargin > 2
    %A list of shared sides has been provided
    
    %Place waypoints at the midpoint of each shared edge
    waypoints = [waypoints;
        [points(sharedSides(:,3),1) + points(sharedSides(:,4),1), ...
        points(sharedSides(:,3),2) + points(sharedSides(:,4),2), ...
        points(sharedSides(:,3),3) + points(sharedSides(:,4),3)] / 2 ];
    waypointTriangles = [waypointTriangles; sharedSides(:,1), sharedSides(:,2)];
    
    %Find the index of the first waypoint that lies on a shared side
    sideWaypointIndex = find(waypointTriangles(:,2) ~= -1);
    sideWaypointIndex = sideWaypointIndex(1);
    
    %For every waypoint placed on a shared side, place two edges, each
    %leading to the centroid of each sharing triangle 
    edges = ones((size(waypointTriangles, 1) - sideWaypointIndex + 1) * 2, 2);
    edgeNumber = 1;
    for i = sideWaypointIndex:size(waypointTriangles, 1)
        
        edges(edgeNumber,:) = [ waypointTriangles(i, 1), i ];
        edgeNumber = edgeNumber + 1;
        edges(edgeNumber,:) = [ waypointTriangles(i, 2), i ];
        edgeNumber = edgeNumber + 1;
        
    end
    
end

end
