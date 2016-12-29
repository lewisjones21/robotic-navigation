function [ triangles ] = CullTriangles( triangles, points, maxsidelength )
%CULLTRIANGLES Removes invalid triangles
%   Removes triangles from the input list that are too large to be valid
%   parts of the tessellation

maxdist2 = maxsidelength^2;
keeplist = ones(size(triangles,1),1);

for t = 1:size(triangles,1)
    
    a = points(:,triangles(t,1)) - points(:,triangles(t,2));
    if (dot(a,a) > maxdist2)
        keeplist(t) = 0;
        continue;
    end
    a = points(:,triangles(t,2)) - points(:,triangles(t,3));
    if (dot(a,a) > maxdist2)
        keeplist(t) = 0;
        continue;
    end
    a = points(:,triangles(t,3)) - points(:,triangles(t,1));
    if (dot(a,a) > maxdist2)
        keeplist(t) = 0;
        continue;
    end
    
end

triangles = triangles(logical(keeplist),:);

end

