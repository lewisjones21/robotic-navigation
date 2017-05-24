function [ boundarySides, sharedSides ] = FindSideTypes(triangles, points)
%FINDSIDETYPES Finds different types of triangle sides
%   
%   Returns a list of all of the sides that are on the boundary of the
%   mesh; each output row records the indices of the two points that define
%   the shared side and the index of the triangle owning the side
%   
%   Returns a list of all of the sides that are shared by a pair triangles;
%   each output row records the indices of the two points that define
%   the shared side and the indices of the triangles sharing the side

%Default the output
boundarySides = [];

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

n = size(points, 1);

sideTriangleCount = combnk(1:n, 2);
sideTriangleCount = [ sideTriangleCount, ...
                        zeros(size(sideTriangleCount, 1), 3) ];

for t = 1:size(triangles, 1)
    %Check each combination of sides
    for pIndex1 = 1:3
        for pIndex2 = pIndex1+1:3
            point1 = min(triangles(t,pIndex1), triangles(t,pIndex2));
            point2 = max(triangles(t,pIndex1), triangles(t,pIndex2));
            
            index = point2 - point1 + sum((n+1-point1):(n-1));
            
            if sideTriangleCount(index, 3) == 0
                %This is the first triangle associated with this side
                %Therefore it might be a boundary side
                sideTriangleCount(index, 3) = t;
                sideTriangleCount(index, 4) = -1;
            else
                %This is the second triangle associated with this side
                %Therefore it might be a shared side
                if sideTriangleCount(index, 4) == -1
                    sideTriangleCount(index, 4) = t;
                    sideTriangleCount(index, 5) = -1;
                else
                    %More than two triangles are associated with this side
                    %Therefore it must be a non-manifold side
                    sideTriangleCount(index, 5) = inf;
                end 
            end 
        end
    end
end

%   [point1, point2,    0,   0,   0] -> Edge not in mesh
%   [point1, point2,   t1,  -1,   0] -> Boundary edge (1 triangle uses it)
%   [point1, point2,   t1,  t2,  -1] -> Shared edge (2 triangles use it)
%   [point1, point2,   t1,  t2, inf] -> Non-manifold edge

boundarySides = sideTriangleCount((sideTriangleCount(:,4) == -1),1:3);
sharedSides = sideTriangleCount((sideTriangleCount(:,5) == -1),1:4);
%nonManifoldSides = sideTriangleCount((sideTriangleCount(:,5) == inf),1:2);


end

