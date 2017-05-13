function [ triangles, points, traversableTriangles, wallTriangles, sharedSides, boundaryPoints ] ...
    = CreateMap( points, maxSideLength, minObstacleHeight )
%CREATEMAP Creates a map of the environment
%   Generates a mesh (and accompanying components) based on the given set
%   of points

%Create a triangle mesh from the point cloud
[triangles, points] = ConvertToMesh(points, maxSideLength);

%Classify the triangles and sub-group them
classifiedTriangles = ClassifyPolygons(triangles, points, 8, 30);
groundTriangles = classifiedTriangles(classifiedTriangles(:,4)==1,1:3);
traversableTriangles = [ groundTriangles; classifiedTriangles(classifiedTriangles(:,4)==2,1:3) ];
wallTriangles = classifiedTriangles(classifiedTriangles(:,4)==3,1:3);

%Remove walls that are too small (likely to be artefacts)
wallTriangles = wallTriangles(max([ ...
    abs(points(wallTriangles(:,1),3)-points(wallTriangles(:,2),3)), ...
    abs(points(wallTriangles(:,2),3)-points(wallTriangles(:,3),3)), ...
    abs(points(wallTriangles(:,3),3)-points(wallTriangles(:,1),3))], [], 2) ...
        > minObstacleHeight,1:3);

%Find sides that are common to more than one triangle
[sharedSides] = FindSharedSides(triangles, points);

%Find points that are on the boundary of the mesh
[boundaryPoints] = FindBoundaryPoints(points, sharedSides);

%Find sides that are common to more than one traversable triangle
[sharedSides] = FindSharedSides(traversableTriangles, points);

end

