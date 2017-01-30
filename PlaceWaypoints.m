function [ waypoints ] = PlaceWaypoints(polygons, points)
%PLACEWAYPOINTS Places waypoints on the polygons in relevant places
%   Places waypoints across the mesh defined by the polygons such that they
%   cover the traversable area to a suitable spatial resolution

%Define the waypoint matrix as a list of (X, Y, Z) coordinate triplets
%waypoints = zeros(size(polygons, 1), 3);

%Place a waypoint at the centre of each polygon (assumed triangles for now)
waypoints = [points(polygons(:,1),1) + points(polygons(:,2),1) + points(polygons(:,3),1), ...
            points(polygons(:,1),2) + points(polygons(:,2),2) + points(polygons(:,3),2), ...
            points(polygons(:,1),3) + points(polygons(:,2),3) + points(polygons(:,3),3)] / 3;

end
