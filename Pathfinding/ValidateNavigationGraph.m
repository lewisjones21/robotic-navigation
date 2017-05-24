function [ validWaypoints, validEdges, validWaypointTriIndices ] ...
    = ValidateNavigationGraph( wheelSpan, collisionRadius, ...
    waypoints, edges, ...
    waypointTriIndices, wallTriIndices, ...
    triangles, points )
%VALIDATENAVIGATIONGRAPH Find the valid subset of the navigation graph
%   Returns the areas in the navigation graph that do not intersect walls
%   using the collision radius given

%Default the relevant outputs
validWaypoints = [];
validEdges = [];
validWaypointTriIndices = [];

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
if size(waypointTriIndices, 1) ~= size(waypoints, 1)
    warning('Incorrect number of waypoint triangle indices given');
    return;
end
if size(waypointTriIndices, 2) ~= 2
    warning('Waypoint triangle indices given in incorrect format');
    return;
end

waypointIndexMap = zeros(size(waypoints, 1), 1);

%wheelSpanRadiusSquared = (wheelSpan * 0.5) ^ 2;

%Find out which waypoints are valid
currentIndex = 1;
for w = 1:size(waypoints, 1)
    
    valid = true;
    
    %Check triangle is not too narrow
%     valid = (max([ ...
%         abs(points(triangles(waypointTriIndices(w,1),1),1) ...
%             - points(triangles(waypointTriIndices(w),2),1)), ...
%         abs(points(triangles(waypointTriIndices(w),2),1) ...
%             - points(triangles(waypointTriIndices(w),3),1)), ...
%         abs(points(triangles(waypointTriIndices(w),3),1) ...
%             - points(triangles(waypointTriIndices(w),1),1)) ...
%         abs(points(triangles(waypointTriIndices(w),1),2) ...
%             - points(triangles(waypointTriIndices(w),2),2)), ...
%         abs(points(triangles(waypointTriIndices(w),2),2) ...
%             - points(triangles(waypointTriIndices(w),3),2)), ...
%         abs(points(triangles(waypointTriIndices(w),3),2) ...
%             - points(triangles(waypointTriIndices(w),1),2))], [], 2) ...
%                 > wheelSpan);
%     if waypointTriIndices(w,2) == -1
%         valid = (max([ ...
%             sum(points(triangles(waypointTriIndices(w,1),1),:) ...
%                 - points(triangles(waypointTriIndices(w,1),2),:) .^ 2), ...
%             sum(points(triangles(waypointTriIndices(w,1),2),:) ...
%                 - points(triangles(waypointTriIndices(w,1),3),:) .^ 2), ...
%             sum(points(triangles(waypointTriIndices(w,1),3),:) ...
%                 - points(triangles(waypointTriIndices(w,1),1),:) .^ 2)], ...
%             [], 2) > wheelSpanRadiusSquared);
%     else
%         valid = true;
%     end
    
    if valid
        for t = 1:size(wallTriIndices, 1)
            %Check that no walls are too close
            valid = ~CheckSphereTriangleCollision(points(triangles(wallTriIndices(t),:),:), ...
                waypoints(w,:), collisionRadius);

            if ~valid
                break;
            end
        end
    end
    %Add the current waypoint to the list of valid waypoints
    if valid
        waypointIndexMap(w) = currentIndex;
        currentIndex = currentIndex + 1;
    end
end

%Reduce the waypoints to those which are valid
validWaypoints = waypoints(waypointIndexMap > 0,:);

if size(edges, 1) > 0
    %Reduce the indices on the edges to match the new waypoint indices
    validEdges = [ waypointIndexMap(edges(:,1)), waypointIndexMap(edges(:,2)) ];
    
    %Reduce the edges to those which have two valid waypoints at their ends
    validEdges = validEdges(validEdges(:,1) > 0 & validEdges(:,2) > 0,:);
end

validWaypointTriIndices = waypointTriIndices(waypointIndexMap > 0,:);

%Find which edges don't have obstructions
% lengthSubdivision = 2;      %Defines resolution of edge obstruction checking
% validEdgesCheck = zeros(size(validEdges, 1), 1);
% for e = 1:size(validEdges, 1)
%     
%     validEdgesCheck(e) = true;
%     length = norm(validWaypoints(validEdges(e,1)), validWaypoints(validEdges(e,2)));
%     for i = 0:1/ceil(length*lengthSubdivision):1
%         testPoint = validWaypoints(validEdges(e,1)) * i + validWaypoints(validEdges(e,2)) * (1 - i);
%         for t = 1:size(wallTriIndices, 1)
% 
%             validEdgesCheck(e) ...
%                 = ~CheckSphereTriangleCollision(points(wallTriIndices(t,:),:), testPoint, collisionRadius);
%             if ~validEdgesCheck(e)
%                 break;
%             end
%         end
%         if ~validEdgesCheck(e)
%             break;
%         end
%     end
% end
% %Remove any edges that do have obstructions
% validEdges = validEdges(validEdgesCheck(:) == true,:);


end

