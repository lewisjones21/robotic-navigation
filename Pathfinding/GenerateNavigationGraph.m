function [ waypoints, edges, waypointTriIndices ] ...
    = GenerateNavigationGraph(traversableTriIndices, triangles, points, ...
        sharedSides, doubleWaypointLength)
%GENERATENAVIGATIONGRAPH Places waypoints on the triangles in relevant places
%   Places waypoints across the mesh defined by the triangles such that they
%   cover the traversable area to a suitable spatial resolution. Also
%   defines traversable edges between the waypoints.
%   doubleWaypointLength indicates how long a sharedSide must be for more
%   than one waypoint to be placed on it

%Define the waypoint matrix as a list of (X, Y, Z) coordinate triplets
%waypoints = zeros(size(triangles, 1), 3);

traversableTriangles = triangles(traversableTriIndices,:);

%Place a waypoint at the centre of each traversable triangle
waypoints = [points(traversableTriangles(:,1),1) ...
                + points(traversableTriangles(:,2),1) ...
                + points(traversableTriangles(:,3),1), ...
            points(traversableTriangles(:,1),2) ...
                + points(traversableTriangles(:,2),2) ...
                + points(traversableTriangles(:,3),2), ...
            points(traversableTriangles(:,1),3) ...
                + points(traversableTriangles(:,2),3) ...
                + points(traversableTriangles(:,3),3)] / 3;

%Also record which triangles the waypoints are associated with
%For these triangles:
%[first triangle, second triangle]
%               = [incremental indices, -1 (no triangle)]
waypointTriIndices = [traversableTriIndices(cumsum(ones(size(traversableTriangles, 1), 1))), ...
                    -1 * ones(size(traversableTriangles, 1), 1)];

edges = [];%This can only be accurately populated if sharedSides is given

if nargin > 3
    %A list of shared sides has been provided; check it is not empty
    if size(sharedSides, 1) > 0
        
        %Place waypoints at the midpoint of each shared side
        waypoints = [waypoints;
            [points(sharedSides(:,3),1) + points(sharedSides(:,4),1), ...
            points(sharedSides(:,3),2) + points(sharedSides(:,4),2), ...
            points(sharedSides(:,3),3) + points(sharedSides(:,4),3)] / 2 ];
        waypointTriIndices = [waypointTriIndices; sharedSides(:,1), sharedSides(:,2)];
        
        if nargin > 4
            %Determine which sharedSides are long enough to warrant additional
            %waypoints
            longIndices = cumsum(ones(size(sharedSides, 1), 1));
            longIndices = longIndices(sqrt(sum(abs(points(sharedSides(:,3),:) ...
    - points(sharedSides(:,4),:)).^2, 2)) > doubleWaypointLength);

            %Place waypoints at the quarter-points of each shared side that
            %has sufficient length
            waypoints = [waypoints;
                [points(sharedSides(longIndices,3),1) * 3 ...
                    + points(sharedSides(longIndices,4),1), ...
                points(sharedSides(longIndices,3),2) * 3 ...
                    + points(sharedSides(longIndices,4),2), ...
                points(sharedSides(longIndices,3),3) * 3 ...
                    + points(sharedSides(longIndices,4),3)] / 4 ];
            waypointTriIndices = [waypointTriIndices; ...
                sharedSides(longIndices,1), sharedSides(longIndices,2)];
            waypoints = [waypoints;
                [points(sharedSides(longIndices,3),1) ...
                    + points(sharedSides(longIndices,4),1) * 3, ...
                points(sharedSides(longIndices,3),2) ...
                    + points(sharedSides(longIndices,4),2) * 3, ...
                points(sharedSides(longIndices,3),3) ...
                    + points(sharedSides(longIndices,4),3) * 3] / 4 ];
            waypointTriIndices = [waypointTriIndices; ...
                sharedSides(longIndices,1), sharedSides(longIndices,2)];
        end

        %Find the index of the first waypoint that lies on a shared side
        sideWaypointIndex = find(waypointTriIndices(:,2) ~= -1);
        sideWaypointIndex = sideWaypointIndex(1);

        %For every waypoint placed on a shared side, place two edges, leading 
        %to the centroids of each sharing triangle 
        edges = ones((size(waypointTriIndices, 1) - sideWaypointIndex + 1) * 2, 2);
        edgeNumber = 1;
        for i = sideWaypointIndex:size(waypointTriIndices, 1)

            edges(edgeNumber,:) = [ waypointTriIndices(i,1), i ];
            edgeNumber = edgeNumber + 1;
            edges(edgeNumber,:) = [ waypointTriIndices(i,2), i ];
            edgeNumber = edgeNumber + 1;

        end 
    end
    
end

%Create edges between each side of each relevant triangle
for w1 = sideWaypointIndex:size(waypointTriIndices, 1)
    for w2 = sideWaypointIndex+1:size(waypointTriIndices, 1)
        
        %If these waypoints have a triangle in common
        if waypointTriIndices(w1,1) == waypointTriIndices(w2,1) ...
            || waypointTriIndices(w1,1) == waypointTriIndices(w2,2) ...
            || waypointTriIndices(w1,2) == waypointTriIndices(w2,1) ...
            || waypointTriIndices(w1,2) == waypointTriIndices(w2,2)
            
            %Link them
            edges(edgeNumber,:) = [ w1, w2 ];
            edgeNumber = edgeNumber + 1;
            
        end
        
    end
end


end
