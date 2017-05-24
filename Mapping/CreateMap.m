function [ triangles, points, traversableTriIndices, wallTriIndices, ...
        sharedSides, traversableSharedSides, boundaryPointIndices, ...
        triangleInclines ] ...
    = CreateMap( maxIncline, meshDecimationFraction, maxSideLength, ...
        minObstacleHeight, points, triangles)
%CREATEMAP Creates a map of the environment
%   Generates a mesh (and accompanying components) based on the given set
%   of points

%Default the relevant outputs
triangles = [];
traversableTriIndices = [];
wallTriIndices = [];
sharedSides = [];
traversableSharedSides = [];
boundaryPointIndices = [];

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end

%Create a triangle mesh from the point cloud, unless triangles are already
%given
if nargin <= 5 || size(triangles, 1) <= 0
    [triangles, points] = ConvertToMesh(points, ...
        maxSideLength, meshDecimationFraction);
else
    %If triangles are given, validate their format
    if size(triangles, 2) ~= 3
        warning('Triangles given in incorrect format');
        return;
    end
end

%Check there are now some triangles
if size(triangles, 1) <= 0
    warning('No triangles found');
    return;
end

maxInclineRads = maxIncline * pi / 180;

%Classify the triangles and find subsets of their indices representing
%traversable areas and walls 
triangleInclines = FindTriangleInclines(triangles, points);
% [classifiedTriangles, triangleSlopes] ...
%     = ClassifyTriangles(triangles, points, maxIncline);
indices = cumsum(ones(size(triangles, 1), 1));
traversable = (triangleInclines <= maxInclineRads);
traversableTriIndices = indices(traversable);
wallTriIndices = indices(~traversable);

%sharedSides = FindSharedSides(triangles, points);

%Find sides that are on the boundary of the mesh
[boundarySides, sharedSides] = FindSideTypes(triangles, points);

%Find points that are on the boundary of the mesh
boundaryPointIndices = [ boundarySides(:,1); boundarySides(:,2) ];
boundaryPointIndices = unique(boundaryPointIndices);

traversableSharedSides ...
    = sharedSides((triangleInclines(sharedSides(:,3)) ...
                                            <= maxInclineRads) ...
                & (triangleInclines(sharedSides(:,4)) ...
                                            <= maxInclineRads), :);

% if size(traversableTriIndices, 1) > 0
%     %Find sides that are common to more than one traversable triangle
%     traversableSharedSides ...
%         = FindSharedSides(triangles(traversableTriIndices,:), points);
%     %Remap the triangle indices of this subset of shared sides; currently they
%     %index the array of traversable triangles - they should index the global
%     %array of triangles
%     traversableSharedSides(:,1) ...
%         = traversableTriIndices(traversableSharedSides(:,1));
%     traversableSharedSides(:,2) ...
%         = traversableTriIndices(traversableSharedSides(:,2));
% end


if size(wallTriIndices, 1) > 0
    %Remove walls that are too small (likely to be artefacts)
    wallTriIndices = wallTriIndices(max([ ...
        abs(points(triangles(wallTriIndices,1),3) ...
            - points(triangles(wallTriIndices,2),3)), ...
        abs(points(triangles(wallTriIndices,2),3) ...
            - points(triangles(wallTriIndices,3),3)), ...
        abs(points(triangles(wallTriIndices,3),3) ...
            - points(triangles(wallTriIndices,1),3))], [], 2) ...
            >= minObstacleHeight);
end


end

