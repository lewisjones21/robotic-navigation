function [ boundaryPointIndices ] ...
    = FindBoundaryPoints(points, boundarySides)
%FINDBOUNDARYPOINTS Finds points on the boundary of the mesh
%   Returns a list of indices of points that lie on the boundary of the
%   triangle mesh


boundaryPointIndices = [];

if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end
if size(sharedSides, 1) <= 0
    warning('No shared sides given');
    return;
end
if size(sharedSides, 2) ~= 4
    warning('Shared sides given in incorrect format');
    return;
end


%Assume all sides are on the boundary
boundarySides = combnk(1:size(points, 1), 2);
for s = 1:size(sharedSides, 1)
    %Remove any sides that are shared
    indices = (boundarySides(:,1) == sharedSides(s,3) ...
                & boundarySides(:,2) == sharedSides(s,4)) ...
                | (boundarySides(:,1) == sharedSides(s,4) ...
                & boundarySides(:,2) == sharedSides(s,3))
    boundarySides(indices,:) = [];
end

%Boundary points are those which lie on boundary sides
boundaryPointIndices = [ boundarySides(:,1); boundarySides(:,2) ];
boundaryPointIndices = unique(boundaryPointIndices);


end

