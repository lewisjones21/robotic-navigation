function [ incline ] = FindTriangleIncline( triangleIndex, triangles, points )
%FINDTRIANGLEINCLINE Returns the slope of the specified triangle in radians
%   

if triangleIndex < 1
    incline = -1;
    return;
end

%Determine the normal
a = points(triangles(triangleIndex,2),:) - points(triangles(triangleIndex,1),:);
b = points(triangles(triangleIndex,3),:) - points(triangles(triangleIndex,1),:);
n = cross(a, b);

%Determine the incline from the normal
if (abs(n(3)) > 0)
    incline = atan(sqrt(n(1) * n(1) + n(2) * n(2)) / n(3));
else
    incline = pi / 2;
end


end

