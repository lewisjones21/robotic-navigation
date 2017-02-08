function [ waypoints ] = PlaceWaypoints(triangles, points, sharedEdges)
%PLACEWAYPOINTS Places waypoints on the triangles in relevant places
%   Places waypoints across the mesh defined by the triangles such that they
%   cover the traversable area to a suitable spatial resolution

%Define the waypoint matrix as a list of (X, Y, Z) coordinate triplets
%waypoints = zeros(size(triangles, 1), 3);

%Place a waypoint at the centre of each triangle
waypoints = [points(triangles(:,1),1) + points(triangles(:,2),1) + points(triangles(:,3),1), ...
            points(triangles(:,1),2) + points(triangles(:,2),2) + points(triangles(:,3),2), ...
            points(triangles(:,1),3) + points(triangles(:,2),3) + points(triangles(:,3),3)] / 3;

if nargin > 2
    %A list of shared edges has been provided
    
    %Place waypoints at the midpoint of each shared edge
    waypoints = [waypoints;
        [points(sharedEdges(:,3),1) + points(sharedEdges(:,4),1), ...
        points(sharedEdges(:,3),2) + points(sharedEdges(:,4),2), ...
        points(sharedEdges(:,3),3) + points(sharedEdges(:,4),3)] / 2 ];
    
end

end
