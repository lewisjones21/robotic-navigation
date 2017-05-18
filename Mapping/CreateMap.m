function [ triangles, points, traversableTriIndices, wallTriIndices, ...
        sharedSides, boundaryPointIndices ] ...
    = CreateMap( points, maxSideLength, minObstacleHeight, maxIncline, ...
        triangles )
%CREATEMAP Creates a map of the environment
%   Generates a mesh (and accompanying components) based on the given set
%   of points

%Create a triangle mesh from the point cloud
if nargin <= 4
    [triangles, points] = ConvertToMesh(points, maxSideLength);
end

%Classify the triangles and sub-group them
% classifiedTriangles = ClassifyPolygons(triangles, points, 8, 30);
% groundTriangles = classifiedTriangles(classifiedTriangles(:,4)==1,1:3);
% traversableTriangles = [ groundTriangles; classifiedTriangles(classifiedTriangles(:,4)==2,1:3) ];
% wallTriangles = classifiedTriangles(classifiedTriangles(:,4)==3,1:3);
classifiedTriangles = ClassifyTriangles(triangles, points, maxIncline);
indices = cumsum(ones(size(classifiedTriangles, 1), 1));
traversableTriIndices = indices(classifiedTriangles(:,4) == 1);
wallTriIndices = indices(classifiedTriangles(:,4) == 2);

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
[sharedSides] = FindSharedSides(triangles(traversableTriIndices,:), points);

end

