function [points] = FindPointsOnPlane(points, planeNormal, planePoint, tolerance)

if dot(planeNormal, planeNormal) ~= 1
    planeNormal = planeNormal / length(planeNormal);
end

planeDistance = dot(planePoint, planeNormal);

indices = zeros(size(points, 2));

for i = 1:size(points,2)
    pointDistance = dot(points(:,i), planeNormal) - planeDistance
    if pointDistance >= -tolerance && pointDistance <= tolerance
        indices(i) = 1;
    end
end

points = points(indices);
return;

end