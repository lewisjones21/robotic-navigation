function [ inclines ] = FindTriangleInclines( triangles, points )
%FINDTRIANGLEINCLINES Returns the slopes of the triangles in radians
%   

%Determine the normals
a = points(triangles(:,2),:) - points(triangles(:,1),:);
b = points(triangles(:,3),:) - points(triangles(:,1),:);
n = cross(a, b);

%Determine the incline from the angle between the normal and the vertical,
%accounting for upside-down triangles
inclines = atan2(sqrt(n(:,1) .^ 2 + n(:,2) .^ 2), abs(n(:,3)));


end

