function [ classifiedpolygons ] = ClassifyPolygons( polygons, points, maxgroundangle, maxslopeangle )
%CLASSIFYPOLYGONS Appends a classifying enum value to each polygon
%   Determines the normal of each polygon and assigns a index to it to
%   indicate whether the polygon is Ground (1), Slope (2) or Wall (3)

groundtolerance = atan(maxgroundangle * pi / 180);
slopetolerance = atan(maxslopeangle * pi / 180);

classifications = ones(size(polygons,1),1) * 3;%Default: Wall (3)

for p = 1:size(polygons,1)
    
    %Determine the normal
    a = points(polygons(p,2),:) - points(polygons(p,1),:);
    b = points(polygons(p,3),:) - points(polygons(p,1),:);
    n = cross(a, b);
    
    if (abs(n(3)) > 0)
        %Turn the normal into a pair of ratios: x/z, y/z
        n = n / abs(n(3));
        horizontalfactor = sqrt(n(1) * n(1) + n(2) * n(2));

        if (horizontalfactor < groundtolerance)
            classifications(p) = 1;
            continue;
        else
            if (horizontalfactor < slopetolerance)
                classifications(p) = 2;
                continue;
            end
        end
    end
    
end

classifiedpolygons = [ polygons, classifications ];

end

