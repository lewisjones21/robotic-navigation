function [ classifiedTriangles, triangleSlopes ] ...
    = ClassifyTriangles( triangles, points, maxIncline )
%CLASSIFYPOLYGONS Appends a classifying enum value to each polygon
%   Determines the normal of each polygon and assigns an index to it to
%   indicate whether the polygon is Traversable (1) or a Wall (2); triangle
%   slopes are returned in degrees

inclineTolerance = atan(maxIncline * pi / 180);

classifications = ones(size(triangles, 1), 1) * 2;%Default: Wall (2)
triangleSlopes = zeros(size(triangles, 1), 1);

for t = 1:size(triangles,1)
    
    %Determine the normal
    a = points(triangles(t,2),:) - points(triangles(t,1),:);
    b = points(triangles(t,3),:) - points(triangles(t,1),:);
    n = cross(a, b);
    
    if (abs(n(3)) > 0)
        %Turn the normal into a pair of ratios: x/z, y/z
        n = n / abs(n(3));
        horizontalFactor = sqrt(n(1) * n(1) + n(2) * n(2));
        
        triangleSlopes(t) = tan(horizontalFactor) * 180 / pi;

        if (horizontalFactor < inclineTolerance )
            classifications(t) = 1;
            continue;
        end
    end
    
end

classifiedTriangles = [ triangles, classifications ];

end

