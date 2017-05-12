function [ triangles ] = CullTriangles( triangles, points, maxsidelength, minsidelength )
%CULLTRIANGLES Removes invalid triangles
%   Removes triangles from the input list that are too large to be valid
%   parts of the tessellation

if nargin < 4
    minsidelength = 0;
end

maxdist2 = maxsidelength^2;
mindist2 = minsidelength^2;
keeplist = ones(size(triangles,1),1);

for t = 1:size(triangles,1)
    
    a = points(triangles(t,1),:) - points(triangles(t,2),:);
    dist2 = dot(a,a);%Calculate the distance between these vertices
    if (dist2 > maxdist2 || dist2 < mindist2)
        keeplist(t) = 0;
        continue;
    end
    a = points(triangles(t,2),:) - points(triangles(t,3),:);
    dist2 = dot(a,a);%Calculate the distance between these vertices
    if (dist2 > maxdist2 || dist2 < mindist2)
        keeplist(t) = 0;
        continue;
    end
    a = points(triangles(t,3),:) - points(triangles(t,1),:);
    dist2 = dot(a,a);%Calculate the distance between these vertices
    if (dist2 > maxdist2 || dist2 < mindist2)
        keeplist(t) = 0;
        continue;
    end
    
end

triangles = triangles(logical(keeplist),:);

end
