function [ inclineChange ] = FindTriangleInclineChange( triangle1Index, triangle2Index, approachAngle, triangles, points )
%FINDTRIANGLEINCLINECHANGE Returns the change in slope between the specified triangles in radians
%   Determines the change in incline from the first triangle to the second,
%   where a concave shared edge gives a positive result and a convex shared
%   edge gives a negative result. The given approach angle accounts for the
%   fact that approaching a ridge/ trough from an angle decreases the
%   effective magnitude of the angle change.

if triangle1Index < 1 || triangle2Index < 1
    inclineChange = -1;
    return;
end

%Determine the first centroid
c1 = (points(triangles(triangle1Index,1),:) ...
    + points(triangles(triangle1Index,2),:) ...
    + points(triangles(triangle1Index,3),:)) / 3;

%Determine the first normal
a1 = points(triangles(triangle1Index,2),:) - points(triangles(triangle1Index,1),:);
b1 = points(triangles(triangle1Index,3),:) - points(triangles(triangle1Index,1),:);
n1 = cross(a1, b1);

%Determine the incline from the first normal
if (abs(n1(3)) > 0)
    n1 = n1 * sign(n1(3));
    n1 = n1 / norm(n1);
    %incline1 = atan(sqrt(n1(1) * n1(1) + n1(2) * n1(2)) / n1(3));
else
    return      %Return null
    %incline1 = pi / 2;
end

%Determine the second centroid
c2 = (points(triangles(triangle2Index,1),:) ...
    + points(triangles(triangle2Index,2),:) ...
    + points(triangles(triangle2Index,3),:)) / 3;

%Determine the second normal
a2 = points(triangles(triangle2Index,2),:) - points(triangles(triangle2Index,1),:);
b2 = points(triangles(triangle2Index,3),:) - points(triangles(triangle2Index,1),:);
n2 = cross(a2, b2);

%Determine the incline from the second normal
if (abs(n2(3)) > 0)
    n2 = n2 * sign(n2(3));
    n2 = n2 / norm(n2);
    %incline2 = atan(sqrt(n2(1) * n2(1) + n2(2) * n2(2)) / n2(3));
else
    return      %Return null
    %incline2 = pi / 2;
end

if dot(n2 - n1, c2 - c1) > 0
    %Difference in normals points in direction from triangle 1 to triangle 2
    %Therefore the shared edge is convex; return negative result
    %inclineChange = min(incline1, incline2) - max(incline1, incline2);
    inclineChange = -acos(dot(n1, n2));
else
    %Difference in normals points in other direction
    %Therefore the shared edge is concave; return positive result
    %inclineChange = max(incline1, incline2) - min(incline1, incline2);
    inclineChange = acos(dot(n1, n2));
end

maxCos = max(max(cos(approachAngle)));      %Accounts for being able to enter multiple approach angles
inclineChange = inclineChange * maxCos;     %Haven't checked this is correct trigonometrically


end

