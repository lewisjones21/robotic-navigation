function [ triangles, points, traversableTriIndices, wallTriIndices, ...
        sharedSides, traversableSharedSides, boundaryPointIndices, ...
        triangleInclines ] ...
    = CreateMap( points, maxSideLength, minObstacleHeight, maxIncline, ...
        triangles )
%CREATEMAP Creates a map of the environment
%   Generates a mesh (and accompanying components) based on the given set
%   of points

%Create a triangle mesh from the point cloud
if nargin <= 4
    [triangles, points] = ConvertToMesh(points, maxSideLength);
end

%Classify the triangles and find subsets of their indices representing
%traversable areas and walls 
triangleInclines = FindTriangleInclines(triangles, points);
% [classifiedTriangles, triangleSlopes] ...
%     = ClassifyTriangles(triangles, points, maxIncline);
indices = cumsum(ones(size(triangles, 1), 1));
traversable = (triangleInclines <= maxIncline * pi / 180);
traversableTriIndices = indices(traversable);
wallTriIndices = indices(~traversable);

%Remove walls that are too small (likely to be artefacts)
wallTriIndices = wallTriIndices(max([ ...
    abs(points(triangles(wallTriIndices,1),3) ...
        - points(triangles(wallTriIndices,2),3)), ...
    abs(points(triangles(wallTriIndices,2),3) ...
        - points(triangles(wallTriIndices,3),3)), ...
    abs(points(triangles(wallTriIndices,3),3) ...
        - points(triangles(wallTriIndices,1),3))], [], 2) ...
        >= minObstacleHeight);

%Find sides that are common to more than one triangle
[sharedSides] = FindSharedSides(triangles, points);

%Find points that are on the boundary of the mesh
[boundaryPointIndices] = FindBoundaryPoints(points, sharedSides);

%Find sides that are common to more than one traversable triangle
[traversableSharedSides] ...
    = FindSharedSides(triangles(traversableTriIndices,:), points);
%Remap the triangle indices of this subset of shared sides; currently they
%index the array of traversable triangles - they should index the global
%array of triangles
traversableSharedSides(:,1) ...
    = traversableTriIndices(traversableSharedSides(:,1));
traversableSharedSides(:,2) ...
    = traversableTriIndices(traversableSharedSides(:,2));

end

