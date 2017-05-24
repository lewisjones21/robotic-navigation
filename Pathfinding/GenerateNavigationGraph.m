function [ waypoints, edges, waypointTriIndices ] ...
    = GenerateNavigationGraph(traversableTriIndices, triangles, points, ...
        travSharedSides, doubleWaypointLength)
%GENERATENAVIGATIONGRAPH Places waypoints on the triangles in relevant places
%	Places waypoints across the mesh defined by the triangles such that they
%	cover the traversable area to a suitable spatial resolution. Also
%	defines traversable edges between the waypoints.
%	doubleWaypointLength indicates how long a travSharedSide must be for more
%	than one waypoint to be placed on it

%	waypoints is a list of (X, Y, Z) coordinate triplets
%	edges is a list of (W1, W2) pairs indexing waypoints
%	waypointTriIndices is a list of (T1, T2) pairs indexing triangles
%	which the waypoints coincide with; for waypoints lying on just one
%	triangle, T2 = -1

%Default the relevant outputs
waypoints = [];
edges = [];
waypointTriIndices = [];

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end
if size(triangles, 1) <= 0
    warning('No triangles given');
    return;
end
if size(triangles, 2) ~= 3
    warning('Triangles given in incorrect format');
    return;
end


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
    if size(travSharedSides, 1) > 0
        
        %Place waypoints at the midpoint of each shared side
        waypoints = [waypoints;
            [points(travSharedSides(:,3),1) + points(travSharedSides(:,4),1), ...
            points(travSharedSides(:,3),2) + points(travSharedSides(:,4),2), ...
            points(travSharedSides(:,3),3) + points(travSharedSides(:,4),3)] / 2 ];
        waypointTriIndices = [waypointTriIndices; ...
            travSharedSides(:,1), travSharedSides(:,2)];
        
        if nargin > 4
            %Determine which sharedSides are long enough to warrant additional
            %waypoints
            longIndices = cumsum(ones(size(travSharedSides, 1), 1));
            longIndices = longIndices(sqrt(sum(abs(points(travSharedSides(:,3),:) ...
                - points(travSharedSides(:,4),:)).^2, 2)) > doubleWaypointLength);

            %Place waypoints at the quarter-points of each shared side that
            %has sufficient length
            waypoints = [waypoints;
                [points(travSharedSides(longIndices,3),1) * 3 ...
                    + points(travSharedSides(longIndices,4),1), ...
                points(travSharedSides(longIndices,3),2) * 3 ...
                    + points(travSharedSides(longIndices,4),2), ...
                points(travSharedSides(longIndices,3),3) * 3 ...
                    + points(travSharedSides(longIndices,4),3)] / 4 ];
            waypointTriIndices = [waypointTriIndices; ...
                travSharedSides(longIndices,1), travSharedSides(longIndices,2)];
            waypoints = [waypoints;
                [points(travSharedSides(longIndices,3),1) ...
                    + points(travSharedSides(longIndices,4),1) * 3, ...
                points(travSharedSides(longIndices,3),2) ...
                    + points(travSharedSides(longIndices,4),2) * 3, ...
                points(travSharedSides(longIndices,3),3) ...
                    + points(travSharedSides(longIndices,4),3) * 3] / 4 ];
            waypointTriIndices = [waypointTriIndices; ...
                travSharedSides(longIndices,1), travSharedSides(longIndices,2)];
        end

        % -For every waypoint placed on a shared side, place two edges, leading 
        %  to the centroids of each sharing triangle 
        %Find the index of the first waypoint that lies on a shared side
        sideWaypointIndex = find(waypointTriIndices(:,2) ~= -1);
        sideWaypointIndex = sideWaypointIndex(1);
        %Prep the edge array for insertion of new values
        edges = ones((size(waypointTriIndices, 1) - sideWaypointIndex + 1) * 2, 2);
        edgeNumber = 1;
        %Create an inverse map from triangle indices to centroid waypoint
        %indices
        imap(waypointTriIndices(1:sideWaypointIndex-1,1)) ...
            = 1:length(waypointTriIndices(1:sideWaypointIndex-1,1));
        %Populate the edge array
        for i = sideWaypointIndex:size(waypointTriIndices, 1)
            %Link waypoint i (cycling through all waypoints on a 
            %travSharedSide) with the two waypoints corresponding to the
            %joined triangles' centroids
            edges(edgeNumber,:) = [ imap(waypointTriIndices(i,1)), i ];
            edgeNumber = edgeNumber + 1;
            edges(edgeNumber,:) = [ imap(waypointTriIndices(i,2)), i ];
            edgeNumber = edgeNumber + 1;

        end 
        
        %Create edges between each side of each relevant triangle
        for w1 = sideWaypointIndex:size(waypointTriIndices, 1)
            for w2 = w1+1:size(waypointTriIndices, 1)

                %If these waypoints have a triangle in common
                if waypointTriIndices(w1,1) == waypointTriIndices(w2,1) ...
                    || waypointTriIndices(w1,1) == waypointTriIndices(w2,2) ...
                    || waypointTriIndices(w1,2) == waypointTriIndices(w2,1) ...
                    || waypointTriIndices(w1,2) == waypointTriIndices(w2,2)

                    %Link them
                    edges = [ edges; w1, w2 ];

                end

            end
        end
    end
end


end
