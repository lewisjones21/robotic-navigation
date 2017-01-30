classdef Polygon
    %POLYGON Represents a polygon
    %   Stores a collection of points representing the corners of a polygon
    
    properties
        Points
        Normal
        Class = -1  %Whether the polygon is 
        Valid = 0   %Whether the points are coplanar
    end
    
    methods
        function valid = checkValid()
            r = round([obj.Value],2);
        end
        function r = multiplyBy(obj,n)
            r = [obj.Value] * n;
        end
    end
    
end