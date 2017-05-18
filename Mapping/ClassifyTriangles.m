function [ classifiedTriangles ] ...
    = ClassifyTriangles( triangles, points, maxIncline )
%CLASSIFYPOLYGONS Appends a classifying enum value to each polygon
%   Determines the normal of each polygon and assigns an index to it to
%   indicate whether the polygon is Traversable (1) or a Wall (2)

inclineTolerance = atan(maxIncline * pi / 180);

classifications = ones(size(triangles, 1), 1) * 2;%Default: Wall (2)

for p = 1:size(triangles,1)
    
    %Determine the normal
    a = points(triangles(p,2),:) - points(triangles(p,1),:);
    b = points(triangles(p,3),:) - points(triangles(p,1),:);
    n = cross(a, b);
    
    if (abs(n(3)) > 0)
        %Turn the normal into a pair of ratios: x/z, y/z
        n = n / abs(n(3));
        horizontalfactor = sqrt(n(1) * n(1) + n(2) * n(2));

        if (horizontalfactor < inclineTolerance )
            classifications(p) = 1;
            continue;
        end
    end
    
end

classifiedTriangles = [ triangles, classifications ];

end

