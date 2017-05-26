function [ triangles ] = CullTriangles( triangles, points, ...
    maxSideLength, minSideLength, maxHeight )
%CULLTRIANGLES Removes invalid triangles
%   Removes triangles from the input list that are too large/ small/ high
%   to be valid parts of the tessellation

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end
if size(triangles, 1) <= 0
    warning('No triangles given');
    return;
end
if size(triangles, 2) ~= 3
    warning('Triangles given in incorrect format');
    return;
end

if nargin < 4
    minSideLength = 0;
end

maxdist2 = maxSideLength^2;
mindist2 = minSideLength^2;
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
