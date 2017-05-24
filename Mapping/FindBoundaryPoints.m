function [ boundaryPointIndices ] = FindBoundaryPoints(points, sharedSides)
%FINDBOUNDARYPOINTS Finds points on the boundary of the mesh
%   Returns a list of indices of points that lie on the boundary of the
%   triangle mesh


boundaryPointIndices = [];

if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(sharedSides, 1) <= 0
    warning('No shared sides given');
    return;
end

%Start by assuming all points to be on the boundary
boundaryPointIndices = cumsum(ones(size(points, 1), 1));

%Find points that are on a shared side and hence are internal to the mesh
innerIndices = [ sharedSides(:,3); sharedSides(:,4) ];
innerIndices = unique(innerIndices);

%Remove points that are on a shared side; they cannot be at the boundary
boundaryPointIndices(innerIndices) = [];


end

