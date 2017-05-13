function [ boundaryPoints ] = FindBoundaryPoints(points, sharedSides)
%FINDBOUNDARYPOINTS Finds points on the boundary of the mesh
%   Returns a list of indices of points that lie on the boundary of the
%   triangle mesh

%Start by assuming all points to be on the boundary
boundaryPoints = points;

%Find points that are on a shared side
innerIndices = [ sharedSides(:,3); sharedSides(:,4) ];
innerIndices = uniquetol(innerIndices, 0.001, 'ByRows', true);

%Remove points that are on a shared side; they cannot be at the boundary
boundaryPoints(innerIndices,:) = [];


end

